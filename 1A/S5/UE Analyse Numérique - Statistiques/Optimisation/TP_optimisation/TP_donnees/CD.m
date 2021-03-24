%-------------------------------------------------------------------------%
% 1SN - TP Optimisation                                                   %
% INP Toulouse - ENSEEIHT                                                 %
%                                                                         %
% Ce fichier contient le programme principal permettant l'estimation      %
% des parametres de la fonction de Cobb-Douglas par une approche          %
% des moindres carres.                                                    %
% Modele : Y(K,L) = A*K^(alpha)*L^(1-alpha)                               %
%-------------------------------------------------------------------------%

clear 
close all
clc
format short
% Initialisation

% Donnees 
global Ki Li Yi
Ki = [0.14; 0.71; 0.28; 0.64; 0.02; 0.81; 0.36; 0.49; 0.94; 0.58];
Li = [0.39; 0.18; 0.14; 0.95; 0.31; 0.72; 0.59; 0.81; 0.45; 0.63];
Yi = [0.12; 0.27; 0.14; 0.45; 0.01; 0.48; 0.24; 0.36; 0.43; 0.37];

% Estimation a priori des parametres du modele
beta0 = [0.35; 0.2]; % beta0 = [A; alpha];

% Calcul et affichage du modele initial -----------------------------------
xmin = 0;
xmax = 1.5;
x = linspace(xmin, xmax, 100*(xmax-xmin));

ymin = 0;
ymax = 1.5;
y = linspace(ymin, ymax, 100*(ymax-ymin));

[K_plot,L_plot] = meshgrid(x, y);
[mK,nK] = size(K_plot);
Y_plot = zeros(mK,nK);

for i = 1:mK
   for j = 1:nK
      Y_plot(i,j) = beta0(1)*K_plot(i,j)^beta0(2)*L_plot(i,j)^(1-beta0(2));
   end
end

figure(1)
    subplot 121
    title('Modele initial')
    xlabel('K')
    ylabel('L')
    zlabel('Y')
    hold on
    plot3(Ki, Li, Yi, 'or')
    contour3(K_plot, L_plot, Y_plot, nK);
    axis([0 1 0 1 0 0.6])
    view(50,5)
    legend('Donnees','Modele','Location','NorthWest');
    grid on

%--------------------------------------------------------------------------
% Evaluation de la fonction des moindres carres (= 0.5*||residu||^2)

xmin = 0;
xmax = 2;
x = linspace(xmin, xmax, 100*(xmax-xmin));

ymin = 0;
ymax = 3;
y = linspace(ymin,ymax,100*(ymax-ymin));

[A_plot,alpha_plot] = meshgrid(x,y);
[mA,nA] = size(A_plot);
MC_plot = zeros(mA,nA);
for i = 1:mA
   for j = 1:nA
      MC_plot(i,j) = MC_CD([A_plot(i,j),alpha_plot(i,j)]);
   end
end

%--------------------------------------------------------------------------
% Methode de Newton

% Affichage des lignes de niveau de la fonction des moindres carres
figure(2)
    subplot 121
    title('Methode de Newton')
    xlabel('A')
    ylabel('alpha')
    axis equal
    hold on
    contour(A_plot,alpha_plot,log(MC_plot+1),100);
    plot(beta0(1),beta0(2),'ok')
    text(beta0(1),beta0(2),'  depart')

%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1- Minimisation de la fonction des moindres carres par la methode 
%    de Newton
% 2- Affichage des parametres au cours de la minimisation

% Initialisation
beta = beta0;



% Boucle





%%%%%%%%%% END TO DO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% Methode de Gauss-Newton

% Affichage des lignes de niveau de la fonction des moindres carres
figure(2)
    subplot 122
    title('Methode de Gauss-Newton')
    xlabel('A')
    ylabel('alpha')
    axis equal
    hold on
    contour(A_plot,alpha_plot,log(MC_plot+1),100);
    plot(beta0(1),beta0(2),'ok')
    text(beta0(1),beta0(2),'  depart')

%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1- Minimisation de la fonction des moindres carres par la méthode 
%    de Gauss-Newton
% 2- Affichage des des parametres au cours de la minimisation

% Initialisation
beta = beta0;



% Boucle





%%%%%%%%%% END TO DO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Affichage du modele final -----------------------------------------------

for i = 1:mK
   for j = 1:nK
      Y_plot(i,j) = beta(1)*K_plot(i,j)^beta(2)*L_plot(i,j)^(1-beta0(2));
   end
end

figure(1)
    subplot 122
    title('Modele final')
    xlabel('K')
    ylabel('L')
    zlabel('Y')
    hold on
    plot3(Ki,Li,Yi,'or')
    contour3(K_plot,L_plot,Y_plot,nK);
    axis([0 1 0 1 0 0.6])
    view(50,5)
    legend('Donnees','Modele','Location','NorthWest');
    grid on


