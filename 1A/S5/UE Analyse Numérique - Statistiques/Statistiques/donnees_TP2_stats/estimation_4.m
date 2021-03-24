function [cos_theta_estime,sin_theta_estime,rho_estime] = estimation_4(x_donnees_bruitees,y_donnees_bruitees)
x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
C1(1,:) = (x_donnees_bruitees - x_G);
C1(2,:) = (y_donnees_bruitees - y_G);
C = C1';
[V D] = eig(C1*C);
vp = diag(D);
[m, ind] = min(vp);
Y = V(:,ind);
cos_theta_estime = Y(1);
sin_theta_estime = Y(2);
rho_estime = x_G*cos_theta_estime + y_G*sin_theta_estime;


