clear
close all
clc

%% Configuração das características do experimento simulado (Apenas para SIMULAÇÃO).
experimento.rbx = 200; %posição inicial do robô no eixo x [cm] (apenas para a simulação)
experimento.rby = 530; %posição inicial do robô no eixo y [cm] (apenas para a simulação)
experimento.ang = 0;  %orientação do robô em relação ao eixo x do ambiente [graus] (apenas para a simulação)
experimento.tamos = 0.05; %tempo de amostragem em segundos (10 ms) (apenas para a simulação)
% mapabmp = 'vazio.bmp'; % mapa do ambiente simulado (apenas para a simulação)
##mapabmp = 'mapareal.bmp'; % mapa do ambiente simulado (apenas para a simulação)
mapabmp = 'mapa_lab.bmp'; % mapa do ambiente simulado (apenas para a simulação)

%% Posição de destino desejada (ambiente de experimento para o robô real vai até (X,Y) = (580,320) aproximadamente (em centímetros)
experimento.dx = 1460; %posição de destino no eixo x [cm]
experimento.dy = 318; %posição de destino no eixo y [cm]

%% Carregando o modelo Kinodinâmico do Zuadento
configuracao_robo
robo.ruido = 0; %desvio padrão do ruído do sensor
robo.saturacao = 1000; %limite do alcance sensorial em cm

%% Parâmetros da simulação
tipodeplot = 3; % em terceira pessoa = 3 --- em primeira pessoa = 1  ---- sem plot = 0
tempo_max = 40; % tempo máximo do experimento em segundos
tempo_total = tic; % controle de custo computacional (debug apenas)

%% Habilitar controle do robô usando o joystick (ainda não testado)
joy_manual = 0; % joy_manual igual a 1 p usar o joystick. joy_manual igual a 0 para usar controle automático (controle_e_navegacao)

%% Simulador do Calma-N
CALMA_N_SIMULADOR(experimento,robo,mapabmp,tipodeplot,tempo_max,joy_manual);

toc(tempo_total) % controle de custo computacional (debug apenas)
%% Funções para visualização do resultado
funcao_plotar_caminho_robo('experimento.mat')
funcao_plotar_graficos('experimento.mat')

