if tipodeplot == 1      
        if i == 1
            % plot do robô em primeira pessoa
            pxyc = [cos(pi/2) -sin(pi/2) ; sin(pi/2) cos(pi/2)]*[xc' ; yc'];
            plot(pxyc(1,:),pxyc(2,:))
            hold on
            plot([0 0],[0 raio_robo],'r');
            plot(vlimitex*(50),vlimitey*(50),'g')%,'g','LineWidth',1)
            plot(vlimitex*(100),vlimitey*(100),'g')%,'g','LineWidth',1)
            plot(vlimitex*(150),vlimitey*(150),'g')%,'g','LineWidth',1)
            plot(vlimitex*(200),vlimitey*(200),'g')%,'g','LineWidth',1)
            plot(vlimitex*(250),vlimitey*(250),'g')%,'g','LineWidth',1)
            axis equal;
            set(gca,'xtick',[],'ytick',[])
            xlim([-(janela+50)-10 (janela+50)+10])
            ylim([-(janela+50)-10 (janela+50)+10])
            
            % função: rotacionar 90 graus para ficar condizente com o plot do
            % robô, que é apontado para cima.
            Ps_i = [cos(pi/2) -sin(pi/2) ; sin(pi/2) cos(pi/2)]*s;
            p1 = plot(Ps_i(1,:),Ps_i(2,:),'.','MarkerEdgeColor','k','MarkerSize',7);
            % plota o destino no ambiente de navegação
            Rmapa = [cos(-Pos(3)+pi/2) sin(-Pos(3)+pi/2); -sin(-Pos(3)+pi/2) cos(-Pos(3)+pi/2)]; % matriz de rotação do mapa para o robô
            Pdesmapa = Rmapa\[Pdes(1)-Pos(1)  Pdes(2)-Pos(2)]';
            if dist > (janela+50) 
                angmapa = atan2(Pdesmapa(2),Pdesmapa(1));
                p2 = plot(cos(angmapa)*(janela+50),sin(angmapa)*(janela+50),'.','MarkerEdgeColor','r','MarkerSize',20);       
            else
                p2 = plot(Pdesmapa(1),Pdesmapa(2),'.','MarkerEdgeColor','r','MarkerSize',20);
            end
        end    
        % função: rotacionar 90 graus para ficar condizente com o plot do
        % robô, que é apontado para cima.
        Ps_i = [cos(pi/2) -sin(pi/2) ; sin(pi/2) cos(pi/2)]*s;
        set(p1,'Xdata',Ps_i(1,:),'Ydata',Ps_i(2,:));
        % plota o destino no ambiente de navegação
        Rmapa = [cos(-Pos(3)+pi/2) sin(-Pos(3)+pi/2); -sin(-Pos(3)+pi/2) cos(-Pos(3)+pi/2)]; % matriz de rotação do mapa para o robô
        Pdesmapa = Rmapa\[Pdes(1)-Pos(1)  Pdes(2)-Pos(2)]';
        if dist > (janela+50) 
            angmapa = atan2(Pdesmapa(2),Pdesmapa(1));
            set(p2,'Xdata',cos(angmapa)*(janela+50),'Ydata',sin(angmapa)*(janela+50))       
        else
            set(p2,'Xdata',Pdesmapa(1),'Ydata',Pdesmapa(2))
        end
    end
    
    if tipodeplot == 3 % plot do robô em terceira pessoa      
      if i == 1
        p00 = plot(Ax,Ay,'.k');
        hold on
%         colormap(gray(2))
        
        % plot do robô em terceira pessoa
        pxyc = [cos(Pos(3)) -sin(Pos(3)) ; sin(Pos(3)) cos(Pos(3))]*[xc' ; yc'];
        xc3 = pxyc(1,:)+Pos(1);
        yc3 = pxyc(2,:)+Pos(2);
        p1 = plot(xc3,yc3,'b');
        p2 = plot([Pos(1) Pos(1)+raio_robo*cos(Pos(3))],[Pos(2) Pos(2)+raio_robo*sin(Pos(3))],'r');
        axis equal;
        p3 = plot(s2(1,:),s2(2,:),'.','MarkerEdgeColor','m','MarkerSize',7);
        
        % plota o destino no ambiente de navegação
        plot(Pdes(1),Pdes(2),'.','MarkerEdgeColor','r','MarkerSize',20)
        set(gca,'xtick',[],'ytick',[])        
        xlim([0 size(A,2)])
        ylim([0 size(A,1)])        
      end      
      % plot do robô em terceira pessoa
      pxyc = [cos(Pos(3)) -sin(Pos(3)) ; sin(Pos(3)) cos(Pos(3))]*[xc' ; yc'];
      xc3 = pxyc(1,:)+Pos(1);
      yc3 = pxyc(2,:)+Pos(2);
      set(p1,'Xdata',xc3,'Ydata',yc3);
      set(p2,'Xdata',[Pos(1) Pos(1)+raio_robo*cos(Pos(3))],'Ydata',[Pos(2) Pos(2)+raio_robo*sin(Pos(3))]);
      set(p3,'Xdata',s2(1,:),'Ydata',s2(2,:));
      set(p00,'Xdata',Ax,'Ydata',Ay);
    end
    
    drawnow