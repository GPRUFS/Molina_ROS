function [V , W ] = controle_e_navegacao(Pos,Pdes,encoder,v_lidar,s2,s,angs,mapa,mapa2,i,tempo,Vmax,Wmax)

%%%%%%%%%%%%%%%%%%%%%%%%%% DESCRIÇÃO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pos = vetor coluna de dimensão 3 [x ; y ; theta] -> configuração do robô
% x em [m] / y em [m] / theta em [rad] de -pi a pi

% Pdes = vetor coluna de dimensão 2 [x_des ; y_des] -> destino do robô
% xdes em [m] / ydes em [m]

% encoder = vetor coluna com 4 elementos nessa ordem:
% posição angular da roda esquerda
% posição angular da roda direita
% velocidade angular da roda esquerda
% velocidade angular da roda direita

% v_lidar = vetor com as distancias medidas pelo Lidar em [m].
% Cada elemento do vetor é a distância em metros medida pelo sensor
% até o obstáculo.

% s2 = matriz de dimensão 2xN. Cada coluna de 's2' é um ponto (x,y)
% representando no sistema de coordenadas do ambiente as medições do Lidar.

% s = matriz de dimensão 2xN. Cada coluna de 's' é um ponto (x,y)
% representando no sistema de coordenadas do robô as mediçãos do Lidar.

% angs = vetor com a mesma dimensão de v_lidar. Representa os ângulos de cada uma
% das leituras do Lidar (medidos em [rad] em relação ao eixo x do sistema
% de coordenadas no robô - frente do robô)

% (não implementado) mapa = matriz de dimensão 2xN que representa o mapa do ambiente
% disponível para o sistema de planejamento. O mapa é uma representação
% discretizada do ambiente utilizando grade regular (decomposição aproximada).
% 'N' é o número de células ocupadas por obstáculos e as colunas da matriz 'mapa'
% são as posições dos obstáculos (x,y) definidas no sistema de coordenadas
% do ambiente em  [m].
% CUIDADO! -> O MAPA PODE NAO SER PERFEITO, PODE SER DESATUALIZADO E
% PODEM HAVER OBSTÁCULOS MÓVEIS NO AMBIENTE COMO OUTROS ROBÔS, POR EXEMPLO.

% (não implementado) mapa2 = matriz de mesma dimensão que o ambiente. Representa a mesma
% informação que a variável Mapa, mas organizada de forma diferente. O
% elemento (i,j) de mapa2 representa uma célula do mapa discreizado. As
% células livre (navegáveis) são representadas por 255 e as células
% ocupadas (obstáculos) são representadas por 0.
% CUIDADO! -> O MAPA PODE NAO SER PERFEITO, PODE SER DESATUALIZADO E
% PODEM HAVER OBSTÁCULOS MÓVEIS NO AMBIENTE COMO OUTROS ROBÔS, POR EXEMPLO.

% i = contador. Número de vezes que o algoritmo de controle e navegação foi
% chamado. Primeira chamada tem valor i = 1.

%tempo = vetor de instantes de tempo. tempo(i) é o instante atual em segundos.

% !!!!!! - você pode manipular essas variáveis como quiser. Alguns exemplos de
% manipulações úteis aparecem abaixo.

%% Distância até o destino (d)
d = sqrt((Pdes(1)-Pos(1))^2 + (Pdes(2)-Pos(2))^2); %distância até o destino

%% Cálculo do erro de orientação para o destino (theta_e)
theta_d = atan2((Pdes(2)-Pos(2)),(Pdes(1)-Pos(1))); % ângulo de destino de -pi a pi
theta_e = theta_d - Pos(3);
% converte theta_e para -pi a pi
if theta_e > pi, theta_e = theta_e - 2*pi; end
if theta_e < -pi, theta_e = theta_e + 2*pi; end

k1 = 1;
k2 = 0.5;

V = Vmax*tanh(k1*d);
W = Wmax*tanh(k2*theta_e);
% 
% V = 0;
% W = Wmax;

end







