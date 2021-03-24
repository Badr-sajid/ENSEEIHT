function [a_estime,b_estime] = estimation_2(x_donnees_bruitees,y_donnees_bruitees)
A1(1,:) = x_donnees_bruitees;
A1(2,:) = ones(1,length(x_donnees_bruitees));
A = A1'
B = y_donnees_bruitees';
X = pinv(A)*B;
a_estime = X(1);
b_estime = X(2);
