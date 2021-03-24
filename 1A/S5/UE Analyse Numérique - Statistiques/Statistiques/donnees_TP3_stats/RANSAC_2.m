function [rho_F_1,theta_F_1] = RANSAC_2(rho,theta,parametres)
n = length (theta);
ecart_min = inf;
rho_F_min = inf;
theta_F_min = inf;
S1 = parametres(1);
S2 = parametres(2);
K = parametres(3);
for i = 1:K
    indices = randperm(n,2);
    [rho_F,theta_F] = estimation_F(rho(indices),theta(indices));
    ecart = abs(rho - rho_F*cos(theta-theta_F));
    d_conforme = (ecart <= S1);
    if mean(d_conforme)>S2
        [rho_F0,theta_F0] = estimation_F(rho(d_conforme),theta(d_conforme));
        ecart_moyen = mean(abs(rho(d_conforme) - rho_F*cos(theta(d_conforme)-theta_F0)));
        if ecart_min> ecart_moyen
            rho_F_min = rho_F0
            theta_F_min = theta_F0
            ecart_min = ecart_moyen;
        end
    end
end
rho_F_1 = rho_F_min;
theta_F_1= theta_F_min;

  

