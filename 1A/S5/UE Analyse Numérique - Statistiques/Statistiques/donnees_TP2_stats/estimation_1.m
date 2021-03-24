function [a_estime,b_estime] = estimation_1(x_donnees_bruitees,y_donnees_bruitees,psi_tests)
x_G = mean(x_donnees_bruitees);
y_G = mean(y_donnees_bruitees);
for i = 1:length(psi_tests)
    somme(i) = sum(((y_donnees_bruitees-y_G) - tan(psi_tests(i))*(x_donnees_bruitees-x_G)).^2);
end
[m ind] = min(somme);
a_estime = tan(psi_tests(ind,:));
b_estime = y_G - a_estime*x_G;

