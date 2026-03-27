function funcao_plotar_graficos(arquivo)

load(arquivo);

g = figure(3);
set(g,'name','Evolução no tempo das velocidades linear e angular do robô');
subplot(211)
plot(tempo,Pvel(1,:))
hold on
plot(tempo,Pvel_medido(1,:),'r')
xlabel('tempo em segundos')
ylabel('V [cm/s]')
legend('desejado','medido')
subplot(212)
% plot(tempo,Pvel(1,:)*180/pi)
plot(tempo,Pvel(2,:))
hold on
% plot(tempo,Pvel_medido(1,:)*180/pi,'r')
plot(tempo,Pvel_medido(2,:),'r')
xlabel('tempo em segundos')
ylabel('W [rad/s]')
legend('desejado','medido')

g2 = figure(4);
set(g2,'name','Evolução no tempo da configuração do robô')
subplot(311)
plot(tempo,P(1,:))
hold on
xlabel('tempo em segundos')
ylabel('x [cm]')
subplot(312)
plot(tempo,P(2,:))
hold on
xlabel('tempo em segundos')
ylabel('y [cm]')
subplot(313)
% plot(tempo,P(3,:)*180/pi)
plot(tempo,P(3,:))
hold on
xlabel('tempo em segundos')
ylabel('theta [radiano]')

g4 = figure(5);
set(g4,'name','Evolução no tempo das velocidades das rodas Fie e FId');
subplot(211)
plot(tempo,Pfi(1,:))
hold on
plot(tempo,Pfi_real(1,:))
xlabel('tempo em segundos')
ylabel('FI_e [rad/s]')
legend('desejado','medido')
subplot(212)
plot(tempo,Pfi(2,:))
hold on
plot(tempo,Pfi_real(2,:))
xlabel('tempo em segundos')
ylabel('FI_d [rad/s]')
legend('desejado','medido')


