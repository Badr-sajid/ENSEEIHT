clear;
close all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
load donnees;
figure('Name','Individu moyen et eigenfaces','Position',[0,0,0.67*L,0.67*H]);

% Calcul de l'individu moyen :
X_m = mean(X);

% Centrage des donnees :
X_c = X - X_m;

% Calcul de la matrice Sigma_2 (de taille n x n) [voir Annexe 1 pour la nature de Sigma_2] :
Sigma_2 = (1/(n-1))*(X_c)*X_c';

% Calcul des vecteurs/valeurs propres de la matrice Sigma_2 :
[W1,D] = eig(Sigma_2);

% Tri par ordre decroissant des valeurs propres de Sigma_2 :
[~,ordre] = sort(diag(D),'descend');

% Tri des vecteurs propres de Sigma_2 dans le meme ordre :
W1(:,ordre);

% Elimination du dernier vecteur propre de Sigma_2 :
W1 = W1(:,1:n-1);

% Vecteurs propres de Sigma (deduits de ceux de Sigma_2) :
W = X_c'*W1;

% Normalisation des vecteurs propres de Sigma
% [les vecteurs propres de Sigma_2 sont normalisés
% mais le calcul qui donne W, les vecteurs propres de Sigma,
% leur fait perdre cette propriété] :
for i = 1:n-1
    W(:,i) = W(:,i)/norm(W(:,i));
end

% Affichage de l'individu moyen et des eigenfaces sous forme d'images :
colormap gray;
img1 = reshape(X_m,nb_lignes,nb_colonnes);
subplot(4,6,1);
imagesc(img);
axis image;
axis off;
title('Individu moyen','FontSize',15);
for k = 1:15
    img = reshape(W(:,k),nb_lignes,nb_colonnes);
    %subplot(nb_individus,nb_postures,l);
	subplot(4,6,k+1);     % Pour affichier 24 figure sinon on décommente la ligne d'avant
    imagesc(img);
    axis image;
    axis off;
    title(['Eigenface ',num2str(k)],'FontSize',15);
end

save exercice_1;
