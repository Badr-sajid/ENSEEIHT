function [theta_estime,rho_estime] = estimation_3(x_donnees_bruitees,y_donnees_bruitees,theta_tests)
x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
for i = 1:length(theta_tests)
    somme(i) = sum(((x_donnees_bruitees-x_G)*cos(theta_tests(i)) + (y_donnees_bruitees-y_G)*sin(theta_tests(i))).^2);
end
[m ind] = min(somme);
 theta_estime = theta_tests(ind);
 rho_estime = x_G*cos(theta_estime) + y_G*sin(theta_estime);
