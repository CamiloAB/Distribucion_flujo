function s_hat = vec_unit_pos_solar( thetaZ, gammaS )
%VEC_UNIT_POS_SOLAR Obtiene el vector unitario de posici\'on solar
%   s_hat = vec_unit_pos_solar( thetaZ, gammaS )
% A partir de thetaZ y gammaS se obtiene s_hat, el vector unitario de
% posicion solar (un vector de 3 elementos [s_x, s_y, s_z])
%
%  s_hat es el vector que viene del sol hacia el heliostato
% El sistema de coordenadas es con el eje x hacia el sur, el y hacia el
% este y el z hacia el cenit.

s_hat = [-cos(gammaS)*sin(thetaZ), sin(gammaS)*sin(thetaZ), -cos(thetaZ)];

s_hat = s_hat/norm(s_hat);

end

