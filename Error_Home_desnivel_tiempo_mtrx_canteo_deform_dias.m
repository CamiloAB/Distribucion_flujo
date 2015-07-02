% Script de prueba
close all
clear all
clc

%% Ejemplo de un d?a espec?fico
latitud = 29.03;

% Vector de los tiempos en un d?a
T = 7*60:15:17*60;
%Error en el tiempo
dt = 0;
T2=T+dt/60; % Tiempo corrido en minutos

%dias=[15,46,74,105,135,166,196,227,258,288,319,349];
dias=[15,46,74,105,135,166,196,227,258,288,319,349];


text_dias=['Jun';'Jul';'May';'Aug';'Apr';'Sep';'Mar';'Oct';'Feb';'Nov';'Jan';'Dec'];
% dias=[15,166];


% Vector del heliostato al blanco
altura=17;
dist=20*altura;
% Angulo respecto al eje del campo
ang=0*pi/12;

% Vector relativo
lateral=sin(ang)*dist;
longitudinal=cos(ang)*dist;
r = [longitudinal, lateral , altura];
r_hat = r/norm(r); % Unitario

% Errores angulares (desviaci?n constante por cada heliostato)
dbeta = 0.00;
dgamma = 0.00;
%Desnivel en rad y matriz de rotación
epsilon = 0.003;
kapa =0*pi/4;
%Error de canteo
xi=0.00;
%Error de deformacion
etamax=0.0;
%Error inclinación
rotx = [cos(epsilon)*(cos(kapa))^2+(sin(kapa))^2,(-cos(epsilon)+1)*cos(kapa)*sin(kapa),sin(epsilon)*cos(kapa);...
    (1-cos(epsilon))*cos(kapa)*sin(kapa),cos(epsilon)*(sin(kapa))^2+(cos(kapa))^2,-sin(epsilon)*sin(kapa);...
    -sin(epsilon)*cos(kapa),sin(epsilon)*sin(kapa),cos(epsilon)];

for num=1:length(dias)
    num_dia=dias(num);
    
    %% Variables para guardar datos
    XXX = zeros(size(T));
    YYY = zeros(size(T));
    RRR = zeros(size(T));
    
    
    for min = 1:length(T)
        % Posición solar
        [thetaZ, gammaS] = posicion_solar(latitud, num_dia, T(min));
        
        s_hat = vec_unit_pos_solar( thetaZ, gammaS );
        
        [beta, gamma, n] = orientacion_ideal(s_hat, r_hat);
        
        % Posicion solare con adelanto de tiempo
        [thetaZerr, gammaSerr]=posicion_solar(latitud, num_dia, T2(min));
        
        s_hat_err = vec_unit_pos_solar( thetaZerr, gammaSerr);
        
        
        %error deformacion
        eta=etamax*cos(beta);
        
        %error de home
        [betaEH, gammaEH, nEH] = orientacion_error_home(beta, gamma, dbeta+eta, dgamma);
        
        %error de canteo
        [betaEC, gammaEC, nEC]=error_canteo(betaEH, gammaEH, xi);
        
        
        % Error de inclinación de pedestal
        nEIP = rotx * nEC.';
        
        r_error = punto_impacto_2(r, s_hat_err, nEIP.');
        
        XXX(min) = -r_error(2)/norm(r);
        YYY(min) = r_error(3)/norm(r);
        RRR(min) = sqrt(XXX(min)^2+YYY(min)^2);
    end
    
    mx = mean(XXX);
    my = mean(YYY);
    dvx = std (XXX);
    dvy = std (YYY);
    
    if num_dia==15
        createfigure_mod_b(XXX,YYY);
%         plot(T,RRR,'LineWidth',1.5)
      	plot(XXX,YYY,'-b','LineWidth',1.5)
        plot(XXX(1),YYY(1),'bo','MarkerFaceColor','b','MarkerSize',6);
        plot(XXX(41),YYY(41),'bo','MarkerFaceColor','b','MarkerSize',6);
        text(XXX(1),YYY(1),'7:00','FontName','Times New Roman','FontSize',16,...
            'VerticalAlignment','Bottom','HorizontalAlignment','Right');
        text(XXX(3),YYY(3),'(b)','FontName','Times New Roman','FontSize',24,...
            'VerticalAlignment','Bottom','HorizontalAlignment','Right');
        text(XXX(41),YYY(41),num2str(num),'FontName','Times New Roman','FontSize',16,...
               'VerticalAlignment','Middle','HorizontalAlignment','Left');
        %        R(num)=sqrt(XXX(21)^2+YYY(21)^2);
    elseif num_dia==166
        %         plot(T,RRR,'LineWidth',1.5)
        plot(XXX,YYY,'-r','LineWidth',1.5)
        plot(XXX(41),YYY(41),'bo','MarkerFaceColor','b','MarkerSize',6);
        text(XXX(41),YYY(41),num2str(num),'FontName','Times New Roman','FontSize',16,...
              'VerticalAlignment','Middle','HorizontalAlignment','Left');
%                R(num)=sqrt(XXX(21)^2+YYY(21)^2);
    else
%         plot(T,RRR,'LineWidth',1.5)
        plot(XXX,YYY,'LineWidth',1.5)
        plot(XXX(41),YYY(41),'bo','MarkerFaceColor','b','MarkerSize',6);
        text(XXX(41),YYY(41),num2str(num),'FontName','Times New Roman','FontSize',16,...
              'VerticalAlignment','Middle','HorizontalAlignment','Left');
%                R(num)=sqrt(XXX(21)^2+YYY(21)^2);
    end
    hold on
end
text(XXX(1),YYY(1),text_dias,'FontName','Times New Roman','FontSize',13,...
    'VerticalAlignment','Middle','HorizontalAlignment','Left');








