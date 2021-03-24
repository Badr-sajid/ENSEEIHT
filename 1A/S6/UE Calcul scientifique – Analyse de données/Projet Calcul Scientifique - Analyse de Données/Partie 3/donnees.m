clear all
close all

% Choix des images parmi les 37 individus et 6 postures faciales :
numeros_individus = [1:37];
numeros_postures = [1:6];

% Chargement et conversion des images
chemin = './Images_Projet_2020';
X=[];
for i=numeros_individus
     for j=numeros_postures
         fichier = [chemin '/' num2str(i+3) '-' num2str(j) '.jpg'];
         Im=importdata(fichier);
         I=rgb2gray(Im);
         I=im2double(I);
         X=[X;I(:)'];
    end
end

% Nombre de lignes n de X (nombre d'images selectionnees) :
 nb_individus = length(numeros_individus);
 nb_postures = length(numeros_postures);
 n = nb_individus*nb_postures;
 
 % Dimensions des images
nb_lignes= 480;
nb_colonnes = 640;
p = nb_lignes*nb_colonnes;


% Affichage des images des 4 premiers individus
% (un individu par ligne, une posture par colonne) :
colormap gray;
for l = 1:24
	j = numeros_individus(floor((l-1)/nb_postures)+1);
	k = numeros_postures(mod((l-1),nb_postures)+1);
	img = reshape(X(l,:),nb_lignes,nb_colonnes);
	%subplot(nb_individus,nb_postures,l);
	subplot(4,6,l);     % Pour affichier 24 figure sinon on décommente la ligne d'avant
	imagesc(img);
	axis image;
	axis off;
	title(sprintf('Ind. %s, Post. %s',num2str(j,'%2d'),num2str(k,'%1d')),'Fontsize',15);
end

save donnees
