clear variables;close all;clc;

%% Creation de 100 individus de R2 pour montrer comment s'effectue le changement de repere via l'ACP
nb_indiv = 100;

% Creation d'un nuage de points de R2:
% On cree separement les coordonnees des abscisses et des ordonnees, afin 
% d'avoir un nuage plus etendu dans une dimension que dans l'autre
X1 = randn(nb_indiv,1);
X2 = 5*randn(nb_indiv,1); 
X = [X1 X2];

% On decale le nuage de point. Puisqu'il s'agit de deux lois normales 
% centrees reduites, l'individu moyen est a peu pres nul. Il correspond 
% donc a peu pres a l'origine du repere canonique. On veut pouvoir 
% visualiser le changement de repere, donc on decale le nuage de points
X = X + 5*ones(nb_indiv,2);

% on va faire "tourner" le nuage, pour que les axes de la base trouvee via
% l'ACP ne soient pas confondus avec ceux de la base canonique.
angle = pi/6; 
R = [cos(angle) -sin(angle); sin(angle) cos(angle)]; 
X = X*R; 

%  On affiche le nuage de points dans le repere canonique
figure(1), axis equal, % axis equal : permet d'avoir la meme taille
% des axes pour les abscisses et les ordonnees.
p1 = plot(X(:,1),X(:,2),'r+',0, 0,'mo',...
    [0 5],[0 0],'k--',...
    [0 0],[0 5],'b--','linewidth',2);grid on;% stocker le graphe dans p1 
% permet de generer simplement une legende prenant en compte tous les 
% affichages de la figure

% l'ACP correspond a un changement de repere de l'espace des donnees : le 
% centre du repere devient l'individu moyen, les vecteurs de la base 
% maximisent la dispersion et ne sont pas correles


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULER LA MATRICE DE VARIANCE/COVARIANCE DU TABLEAU DES DONNEES X ET
% LES AXES PRINCIPAUX. REORDONNER CES AXES PAR ORDRE DECROISSANT DU
% CONTRASTE QU'ILS FOURNISSENT
% (cf - TP1 RVB)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_mean = mean(X);
X_centre = X-X_mean;
n = length(X);
sigma = (1/(n-1))*(X_centre')*X_centre;
[W,D] = eig(sigma);
[~,ordre] = sort(diag(D),'descend');
W(:,ordre);
C = X_centre*W;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFFICHER LE NOUVEAU REPERE DEFINI PAR LES AXES PRINCIPAUX ET L'ELEMENT 
% MOYEN SUR LA FIGURE (1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1), hold on, axis equal % axis equal : permet d'avoir la meme taille
% des axes pour les abscisses et les ordonnees. Sans cela, il est impossible
% de voir que les deux axes principaux sont orthogonaux
p2 = plot(X_mean(1),X_mean(2),'go',...
    [X_mean(1) 5*W(1,1)+X_mean(1)],[X_mean(2) 5*W(2,1)+X_mean(2)],'m',...
    [X_mean(1) 5*W(1,2)+X_mean(1)],[X_mean(2) 5*W(2,2)+X_mean(2)],...
    'b','linewidth',2);grid on % /!\ L'affichage du point (0,0) ne sert a rien ici
% a part a montrer comment creer une legende qui reunit les courbes de deux
% plots differents (cf lignes de code 58-59)
title('Changement de repere : repere canonique VS repere principal')
legend([p1;p2],'nuage de points','origine','premier axe canonique','deuxieme axe canonique',...
    'individu moyen','premier axe principal','deuxieme axe principal','Location','southeast');

%% Creation de 100 individus de R10 pour montrer l'interet de projeter 
%  sur les composantes principales plutot que sur n'importe quel axe

% Creation d'un echantillon d'individus beaucoup plus disperse sur ses
% deux dernieres variables que sur les autres
X1 =  8*randn(nb_indiv,1);
X2 = 10*randn(nb_indiv,1);
X = randn(nb_indiv,8); 
X = [X,X1,X2];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULER LA MATRICE DE VARIANCE/COVARIANCE DU TABLEAU DES DONNEES X ET
% LES AXES PRINCIPAUX. REORDONNER CES AXES PAR ORDRE DECROISSANT DU
% CONTRASTE QU'ILS FOURNISSENT.
% CALCULER LA MATRICE C DE L'ECHANTILLON X DANS CE NOUVEAU REPERE [i.e. LA 
% PROJECTION DES LIGNES DU TABLEAU CENTRE XC DANS LA NOUVELLE BASE] :
% CHAQUE COLONNE DE C CORRESPOND A CE QUE L'ON APPELLE UNE COMPOSANTE
% PRINCIPALE DE X
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_mean = mean(X);
X_centre = X-X_mean;
n = length(X);
sigma = (1/(n-1))*(X_centre')*X_centre;
[W,D] = eig(sigma);
[~,ordre] = sort(diag(D),'descend');
W(:,ordre);
C = X_centre*W;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUR UNE MEME FIGURE, AFFICHER EN ROUGE LA PROJECTION DES INDIVIDUS DE XC
% SUR LES DEUX PREMIERS AXES DE LA BASE CANONIQUE [i.e. EN UTILISANT POUR 
% CHAQUE IND. SES COEFFICIENTS DANS LES DEUX PREMIERES COLONNES DE XC], 
% PUIS EN BLEU LA PROJECTION DE CES INDIVIDUS SUR LES DEUX PREMIERS AXES
% PRINCIPAUX [i.e. EN UTILISANT POUR CHAQUE IND. SES COEFFICIENTS DANS LES
% DEUX PREMIERES COLONNES DE C]
%
% QUESTION 3 RAPPORT :
% QUE REMARQUEZ-VOUS ? (A EXPLIQUER DANS LE RAPPORT)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
% NB : ATTENTION A BIEN AFFICHER LA PROJECTION DES INDIVIDUS DE XC (ET NON
% DE X) SUR LES DEUX PREMIERS AXES CANONIQUES. SINON LES DEUX NUAGES DE
% POINTS NE SERONT PAS CENTRES SUR LE MEME POINT ET IL SERA PLUS DUR D'EN
% TIRER DES CONSEQUENCES
%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%
figure(2), hold on, axis equal
p3 = plot(X_centre(:,1),X_centre(:,2),'r+',0, 0,'mo',...
    [0 5],[0 0],'k--',...
    [0 0],[0 5],'b--','linewidth',2);grid on;
p4 = plot(C(:,1),C(:,2),'b+',X_mean(1),X_mean(2),'ko'); grid on;
title('Projections sur axes canoniques VS axes principaux')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULER L'INFORMATION -- i.e. LA PROPORTION DE CONTRASTE -- CONTENUE 
% DANS LES DEUX PREMIERES COMPOSANTES PRINCIPALES POUR L'ECHANTILLON X, VIA
% LES ELEMENTS SPECTRAUX DE LA MATRICE DE VARIANCE/COVARIANCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
info_axe_1 = D(1,1)/trace(D);
info_axe_2 = D(2,2)/trace(D);
info_axe_3 = (D(1,1)+D(2,2))/trace(D);
fprintf('Pourcentage d info sur la premiere composante principale = %.3f\n',info_axe_1);
fprintf('Pourcentage d info sur la deuxieme composante principale = %.3f\n',info_axe_2);
fprintf('Pourcentage d info sur les deux premieres composantes    = %.3f\n',info_axe_3);
