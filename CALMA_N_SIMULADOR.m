function CALMA_N_SIMULADOR(experimento,robo,mapabmp,tipodeplot,tempo_max,joy_manual)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AQUI VAI O CÓDIGO DO P3DX_SIM_CONTROL QUE VAI COMEÇAR COMO O BOTÃO %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inicialização das variáveis globais
global Pos Pdes v_sensor s s2 angs Mapa Mapa2 i tempo tamos;

colidiu = 0; % verifica se o robô colidiu para finalizar a simulação
raio_robo = robo.raio; %raio para verificar colisão e plotar o robô
tamos = experimento.tamos; % tempo de amostragem da simulação em segundos
% janela de observação para navegação em primeira pessoa
janela = robo.saturacao; %saturação do sensor
%inicialização do ruido de medição em [%]
ruido = robo.ruido;
% inicialização da posição do robô
x = experimento.rbx;
y = experimento.rby;
theta = experimento.ang*pi/180; % inicia orientado para o eixo x do plano
Pos = [x ; y ; theta]; % é a posição atual do robô (aqui é a posição inicial).

%% carregando o mapa do ambiente
A = imread(mapabmp);
A = A(:,:,1);
A = A./(max(max(A)));
A = A.*255;
%A = rgb2gray(A);
Mapa2 = A;
% A2 = A(end:-1:1,:); % utilizada no plot para parecer a imagem no SC padrão
[Ay , Ax] = find(A~=255);
Mapa = [Ax,Ay]';

% variáveis para acelerar a simulação sensorial
[ymaxA , xmaxA] = size(A);
AA = [255*ones(ymaxA,janela) A 255*ones(ymaxA,janela)];
AA = [255*ones(janela, xmaxA+2*janela) ; AA ; 255*ones(janela, xmaxA+2*janela)];

%% vetores sobre o experimento
P = zeros(3,round(tempo_max/tamos));
P(:,1) = Pos;
Pvel = zeros(2,round(tempo_max/tamos));
Pvel_medido = zeros(2,round(tempo_max/tamos));
Pfi = zeros(2,round(tempo_max/tamos));
Pfi_real = zeros(2,round(tempo_max/tamos));
X = [0 ; 0 ; 0 ; 0 ; 0 ; 0]; % estado do sistema para simulação dinâmica

%% inicialização da posição de destino do robô
Pdes = [experimento.dx ; experimento.dy ];


%% definição dos ângulos dos sensores
resang = 2;
angs = (0:resang:360-resang)*pi/180;

%% inicialização dos sensores com zero
s = zeros(2,length(angs));
s_i = s;
s2 = s; %sensor com ruído de medição no SC do ambiente

% limite do campo de visão para primeira pessoa.
% [vlimitex,vlimitey] = scircle2(0,0,1,0); % circulo limite de visão MATLAB
aux = linspace(0,2*pi*100,100);
vlimitex = cos(aux)';
vlimitey = sin(aux)';
xc = vlimitex*raio_robo';
yc = vlimitey*raio_robo';

%% inicialização das variáveis do loop while
Vmedido = 0;
Wmedido = 0;
dist = sqrt( (Pdes(1)-Pos(1))^2 + (Pdes(2)-Pos(2))^2 ); % distância linear para o destino
i = 0;  % contador
tempo = 0:tamos:tempo_max;  % controle de tempo

%% inicio do loop while
while  (((abs(dist) > 5) || (abs(Vmedido) > 10) || abs(Wmedido) > 1) && (colidiu == 0) && i*tamos<tempo_max)
      % distancia maior que 5 cm ou vlin maior q 5 cm/s ou vrot maior que 0.1 rad/s

    % atualização das variáveis de controle de tempo
    i = i+1;
    tempo(i) = (i-1)*tamos;

    simulacao_sensores

    %% %%%%%%%%%%%%%%%%% CONTROLADOR INÍCIO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %s_i = sensores no sistema de coordenadas do ambiente
    %    = sem ruído e não deve ser usado pelo controlador

    %s = sensores no sistema de coordenadas do robô
    %  = com ruído adicionado. Esse pode ser utilizado pelo controlador.

    %s2 = sensores no sistema de coordenadas do ambiente
    %  = com ruído adicionado. Esse pode ser utilizado pelo controlador.
    tamos_controle = 0.05; %atualizar a cada 40 ms
    if (mod(tempo(i),tamos_controle)==0)
        if joy_manual == 1
            if i == 1
                joy = vrjoystick(1);
                pause(0.2);
                joy_dados = read(joy);
                off_setV = joy_dados(2);
                off_setW = joy_dados(1);
            end
            joy_dados = read(joy);
            %acelerador = button(joy, 3); %quadrado do controle
            %freio = button(joy, 3); %% x do controle
            V = -(robo.Vmax)*(joy_dados(2)-off_setV);
            W = -(robo.Wmax)*(joy_dados(1)-off_setW);
            U = robo.Modcin\[V ; W]; %FI = [FI_e ; FI_d];
        else
            Vmax = robo.Vmax/100; %em m/s
            Wmax = robo.Wmax; %em rad/s
            Wmax = Wmax/2;
            mapa = Mapa;
            mapa2 = Mapa2;
            fs = s./100;
            fs2 = s2./100;
            v_lidar = v_sensor/100;
            if i == 1
                encoder = [0 0 0 0]';
            end
            fPdes = Pdes/100;
            fPos = [Pos(1)/100 ; Pos(2)/100 ; Pos(3)];
            [V , W] = controle_e_navegacao(fPos,fPdes,encoder,v_lidar,fs2,fs,angs,mapa,mapa2,i,tempo,Vmax,Wmax);

            %saturação das velocidades com prioridade para angular
            if W > Wmax, W = Wmax; end
            if W < -Wmax, W = -Wmax; end
            Vmax_w = Vmax*(1-abs(W)/Wmax);
            if V > Vmax_w, V = Vmax_w; end
            if V < -Vmax_w, V = -Vmax_w; end

            V = V*100; %devolve para cm/s para simular

            U = robo.Modcin\[V ; W]; %U = [FI_e ; FI_d];


            % U = controle_e_navegacao(robo);
        end
        Ud = U;
    end
    if abs(U(1)) > robo.fi_max  %limita ao máximo que o foi determinado para o robô que é 33.2 rad/s =~ 35 Pulsos/10ms
        U(1) = sign(U(1))*robo.fi_max;
    end
    if abs(U(2)) > robo.fi_max
        U(2) = sign(U(2))*robo.fi_max;
    end
    %% %%%%%%%%%%%%%%%%%%% CONTROLADOR FIM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% SIMULAÇÃO do robô
    R = [cos(Pos(3)) sin(Pos(3)) 0 ; -sin(Pos(3)) cos(Pos(3)) 0 ; 0 0 1]; % matriz de rotação
    [Ksir_real, X] = dinamica_calma_n(U,robo,tamos,X); %retorna as velocidades V e W reais no SC do robô

    Ksi_I = R\Ksir_real; % coloca as velocidades V e W reais no SC do ambiente
    Pos = Pos + Ksi_I*tamos; % atualização da posição do robô (integração no SC do ambiente)
    % converte theta para -pi a pi
    if Pos(3) > pi, Pos(3) = Pos(3) - 2*pi; end
    if Pos(3) < -pi, Pos(3) = Pos(3) + 2*pi; end

    %% organização das variáveis para plot dos resultados

    Vmedido = Ksir_real(1);
    Wmedido = Ksir_real(3);

    Fi = robo.Modcin\[Vmedido ; Wmedido]; % velocidade real das rodas
    encoder = [0 0 Fi(1) Fi(2)]';

    Ksir_d = robo.Modcin*Ud; % converte para comandos de velocidade (apenas para registro e plots futuros)

    Pvel(:,i+1) = Ksir_d; % atualiza o vetor das velocidades (comandos) do robô durante o experimento - desejadas.
    Pvel_medido(:,i+1) = [Vmedido ; Wmedido]; % atualiza o vetor das velocidades reais do robô durante o experimento.
    P(:,i+1) = Pos; % atualiza o vetor das posições do robô durante o experimento (SC do ambiente).
    Pfi(:,i+1) = Ud; % U = [Fi_e ; Fi_d] % valor desejado de fi
    Pfi_real(:,i+1) = Fi; % U = [Fi_e ; Fi_d] % valor real de fi

    dist = sqrt( (Pdes(1)-Pos(1))^2 + (Pdes(2)-Pos(2))^2 ); % atualiza a distância para o destino

    % PLOT DO GRÁFICO "ON LINE"
    plot_graficos_online

end

%% finalização dos vetores e salvando o arquivo do experimento
tempo = tempo(1:i+1);
P = P(:,1:i+1);
Pvel = Pvel(:,1:i+1);
Pvel_medido = Pvel_medido(:,1:i+1);
Pfi = Pfi(:,1:i+1);
Pfi_real = Pfi_real(:,1:i+1);
%%%% Salvando os dados no arquivo
save -mat experimento.mat  P Pvel Pvel_medido Pfi Pfi_real tempo A Ax Ay Pdes raio_robo

end
