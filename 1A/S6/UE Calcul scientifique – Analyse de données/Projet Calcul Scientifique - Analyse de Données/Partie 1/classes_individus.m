clear variables
close all

% chargement du jeu de donn�es
load('dataset.mat')

[nb_indiv,nb_param] = size(X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULE de LA MATRICE DE VARIANCE/COVARIANCE DU TABLEAU DES DONNEES X, ET
% LES AXES PRINCIPAUX. REORDONNER CES AXES PAR ORDRE DECROISSANT DU
% CONTRASTE QU'ILS FOURNISSENT.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_mean = mean(X);
X_centre = X-X_mean;
sigma = (1/(nb_indiv))*(X_centre')*X_centre;
[W,D] = eig(sigma);
pourcentages = (1/trace(D))*diag(D);
[pourcentages_tries, I]= sort(pourcentages,'descend');
W(:,I);
C = X_centre*W;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFFICHER UNE FIGURE MONTRANT LE POURCENTAGE D'INFORMATION APPORTEE PAR
% CHAQUE COMPOSANTE PRINCIPALE. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
plot([1:nb_param],pourcentages_tries,'r+'); grid on;
title('Pourcentage d info contenue sur chaque composante ppale -- 2 classes')
xlabel('num de la comp. ppale');ylabel('pourcentage d info');

% On a besoin de 6 6 composantes principales pour obtenir un taux
% d'information suffisant sur l'ensemble des données.

% Affichage de la projection des donnees sur 1er, 2ème et 3ème axes 
%principaux dans l'espace.
figure(2),
plot3(C(:,1),C(:,2),C(:,3),'b+');grid on
title('Projection des donnees sur les 3 premiers axes principaux')

% On trouve 7 classes d'individus.

%Affichage des différentes classes de variables en couleurs différentes.
indices = kmeans(C(:,1:3),7);
figure(3),
for i = 1:7
    indice = find(indices == i);
    plot3(C(indice,1),C(indice,2),C(indice,3),'+');grid on;hold on
end
title("Projection des donnees sur les 3 premiers axes principaux en affichant les classes")
legend("Classe 1","Classe 2","Classe 3","Classe 4","Classe 5","Classe 6","Classe 7")
