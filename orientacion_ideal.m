function [beta, gamma, n_hat] = orientacion_ideal(s_hat, r_hat)
% ORIENTACION_IDEAL orientaci?\'on de un heli\'ostato
%
%   [beta, gamma] = orientacion_ideal()
% Calcula la orientaci\'on de un rayo conociendo la posici\'on del sol, a
% partir de \hat{s} = [s_x, s_y, s_z] y \hat{r} = [r_x, r_y, r_z]
% n_hat es el vector normal del plano del heliostato

n_hat = (-s_hat + r_hat) / norm(-s_hat + r_hat);

beta = acos(n_hat(3));
gamma = atan2(-n_hat(2), n_hat(1));





