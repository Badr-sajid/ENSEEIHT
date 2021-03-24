donnees;
exercice_2;

% Tirage aleatoire uniforme de C et R :
nb_tirages = 100000;
moyenne = (nb_tirages)/2;
variance = ((nb_tirages+1)^2)/12;

C_test = (taille-R_0)*(2*(randn(nb_tirages,2)*sqrt(variance)+moyenne)-1);
R_test = 2*R_0*(randn(nb_tirages,1)*sqrt(variance)+moyenne);
[C_estime R] = estimation_2(x_donnees_bruitees,y_donnees_bruitees,C_test,R_test);

% Affichage du cercle estime :
x_cercle_estime = C_estime(1)*ones(nb_points_cercle,1) + ...
                  R*cos(theta_cercle);
y_cercle_estime = C_estime(2)*ones(nb_points_cercle,1) + ...
                  R*sin(theta_cercle);
plot(x_cercle_estime([1:end 1]),y_cercle_estime([1:end 1]),'b--','LineWidth',3);
legend(' Cercle reel', ...
	' Donnees bruitees', ...
	' Cercle estime', ...
	'Location','Best');