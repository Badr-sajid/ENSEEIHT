clear;
close all;
load donneesCouleur;
load exercice_1_Couleur;
figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.6*L,0.5*H]);

% Seuil de reconnaissance a regler convenablement
s = 1e+00;

% Pourcentage d'information 
per = 0.95;

% Tirage aleatoire d'une image de test :
%individu = randi(37);
individu = randi(7);
posture = randi(6);
chemin = './Images_Projet_2020';
fichier = [chemin '/' num2str(individu+3) '-' num2str(posture) '.jpg']
Im=importdata(fichier);
I=im2double(Im);
image_test=I(:)';
 

% Affichage de l'image de test :
colormap gray;
imagesc(I);
axis image;
axis off;

% Nombre N de composantes principales a prendre en compte 
% [dans un second temps, N peut etre calcule pour atteindre le pourcentage
% d'information avec N valeurs propres] :
N = 18;

% N premieres composantes principales des images d'apprentissage :
C = X_c * W;
CN = C(:,1:N);

% N premieres composantes principales de l'image de test :
C_image = (image_test - X_m) * W;
image_test_N = C_image(:,1:N);

% Determination de l'image d'apprentissage la plus proche (plus proche voisin) :
% Creation des classes
classe = 1:37;

% Creation du label
label = repmat(numeros_individus,nb_postures,1);
label = label(:);
labelT = repmat(numeros_individus,6,1);
labelT = label(:);

k = 3;
[Partition,d,indice_proche,~] = kppv(CN,image_test_N,label,k,classe,labelT);
    
N = histcounts(Partition);
[~, max_indice] = max(N);
individu_trouve = Partition(max_indice);
% Affichage du resultat :
if min(d) < s 
	individu_reconnu = individu_trouve;
	individu_reconnu = Partition(10,1);
    title({['Posture numero ' num2str(posture) ' de l''individu numero '...
    num2str(individu+3)];
    ['Je reconnais l''individu numero ' num2str(individu_reconnu+3)]},'FontSize',20);
else
	title({['Posture numero ' num2str(posture) ' de l''individu numero '...
        num2str(individu+3)];
        'Je ne reconnais pas cet individu !'},'FontSize',20);
end


% Affichage de l'image requête
postures = mod(indice_proche, nb_postures).';
postures(postures == 0) = nb_postures;
label_et_Posture = [label(indice_proche) postures'];

figure('Name',"Résultat d’une requête sur une base de visages",'Position',[0.2*L,0.2*H,0.6*L,0.5*H]);
subplot(1, k + 1, 1);
colormap gray;
imagesc(I);
axis image;
title("Requête");

for i = 1:k
    subplot(1, k+1, i+1);
    fichier = [chemin '/' num2str(label_et_Posture(i, 1) + 3) '-' num2str( label_et_Posture(i, 2) ) '.jpg'];
    Im = importdata(fichier);
    I = im2double(Im);
    imagesc(I);
    axis image;
    title("Trouvée - choix " + i);
end

