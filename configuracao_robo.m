%% dados do robô Calma-N.

%modelo similar para as duas rodas (considerando a FT do sistema controlado
%e já linearizado. chamando isso aqui de:
% MC(s)= (A*s^2 + B*s + C)/(s^3 + D*s^2 + E*s + F) = d_FI(s)/U(s) para cada um dos motores

%     -1.223 s^2 + 221.1 s + 1370
%   --------------------------------
%   s^3 + 36.51 s^2 + 450.5 s + 1370
A = -1.223;
B = 221.1;
C = 1370;
D = 36.51;
E = 450.5;
F = 1370;
% o sistema então é colocado em variáveis de estado para:
% U = [U_e ; U_d] = [ U_1 ; U_2] = entradas 
% X = estado = sem definição física específica, mas de 6a ordem
% Y = [V ; W] = saídas

robo.r = 6.5/2; %raio da roda em cm
robo.L = 17.5/2; %distância da roda ao centro do robô (metade da distancia entre as rodas) em cm

%% matrizes do modelo em variáveis de estado

mt = [-D 1 0 ; -E 0 1 ; -F 0 0];
Ma = [mt 0*mt ; 0*mt mt];
Mb = [A 0 ; B 0 ; C 0 ; 0 A ; 0 B ; 0 C]*[robo.r/2 , robo.r/2 ; -robo.r/(2*robo.L) robo.r/(2*robo.L)];
Mc = [1 0 0 0 0 0 ; 0 0 0 1 0 0];
Md = [0 0 ; 0 0];

robo.Modelo.A = Ma;
robo.Modelo.B = Mb;
robo.Modelo.C = Mc;
robo.Modelo.D = Md;

% U = [U_d ; U_e] entradas de - a 1
% X = [FI_d ; FI_e] estado
% Y = [V ; W] saídas

robo.raio = 10; %raio do robô para verificar colisão e plotar o robô [cm]
robo.Modcin = [robo.r/2 , robo.r/2 ; -robo.r/(2*robo.L) robo.r/(2*robo.L)]; %modelo cinemático direto
% robo.ganhoft = [B/A_ ; D/C_];
% U = inv(robo.Modcin)*[V ; W];

%% cálculo da velocidade máxima de rotação do motor

%encoder de 11 PPR
%medição em quadratura do encoder dá um total de 44 PPR (no encoder)
%redução de 1:20.4
%velocidade na roda dá um total de 44*20.4 PPR = 897.6 PPR
    % (44*20.4)/360 = 2.4933 Pulsos por Grau
    % 360/(44*20.4) = 0.4011 Graus por pulso
    % (2*pi)/(44*20.4) = 0.007 radianos por pulso
    res = (2*pi)/(44*20.4); %em radianos por pulso
%resolução em graus na roda é de: 0.4011 graus por pulso
%resolução em radianos é 2*pi/897.6 = 0.007 radianos por pulso

%Fi_max calculado é 35 pulsos / 10 ms = 35/(10^-2) = 3500 PPS

%Fi_max calculado em rad/s 3500*0.007 = 24.5 rad/s
robo.enc_max = 35;
robo.fi_max = 25.2; %velocidade máxima de rotação da roda em radianos por segundo


Fi = [robo.fi_max ; robo.fi_max];
aux = robo.Modcin*Fi;
robo.Vmax = aux(1); %cálculo da vellcidade linear máxima a partir do modelo identificado [cm/s]
Fi = [-robo.fi_max ; robo.fi_max];
aux = robo.Modcin*Fi;
robo.Wmax = aux(2); %cálculo da vellcidade angular máxima a partir do modelo identificado [rad/s]
