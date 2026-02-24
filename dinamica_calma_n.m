function [Ksir_real, X] = dinamica_calma_n(U,robo,Tamos,X)

    %Xp = Ma*X + Mb*U
    % Y = Mc*X + Md*U

%     U = [U U U]; %[Ud ; Ue]
%     U = U'; % descomentar essa linha pra usar no octave
%     [Y,T,X] = lsim(robo.Modelo,U,[0:Tamos:2*Tamos],X);
%     X = X(2,:)';
%     Ksir_real = [Y(2,1) ; 0 ; Y(2,2)];
    
    A = robo.Modelo.A;
    B = robo.Modelo.B;
    C = robo.Modelo.C;
    D = robo.Modelo.D;
    
    xp = A*X+B*U; %F1
    X2 = X + xp*Tamos; %com F1 calcula X no final do intervalo
    xp2 = A*X2+B*U; %F2 que é estimativa no final do intervalo
    fi = xp/2 + xp2/2; 
    X3 = X + fi*Tamos/2;  %com média de F1 e F2 calcula X no meio
    xp3 = A*X3+B*U; %F3 que é estimativa no meio do intervalo
    fi = xp/3 + xp2/3 + xp3/3;
    X = X + fi*Tamos/2; %estimativa final de X no final do intervalo
    Y = C*X + D*U; %saída y = [V W];
    Ksir_real = [Y(1) ; 0 ; Y(2)];

end

