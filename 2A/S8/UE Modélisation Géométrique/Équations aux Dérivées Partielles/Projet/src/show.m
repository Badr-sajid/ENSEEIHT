function show(elements3,elements4,coordinates,u)
%
% Fonction d'affichage de la solution u sur le maillage defini par
% elements3, elements4, coordinates.
%
% Entrees:
%	elements3 : matrice a trois colonnes contenant les elements triangles
%	de la discretisation, identifies par les indices de leurs trois
%	sommets.
%	elements4 : matrice a quatre colonnes contenant les elements 
%	quadrangles de la discretisation, identifies par les indices de leurs 
%	quatre sommets.
%	coordinates : matrice a deux colonnes contenant les coordonnes 2D des
%	points de la discretisation.
%	u : vecteur colonne de longueur egale au nombre de lignes de
%	coordinates contenant les valeurs de la solution a afficher aux
%	points de la discretisation.
%
% Sorties : Aucune, mais la fonction doit s'afficher dans une figure.
%
% Source : J. Alberty, C. Carstensen and S. A. Funken  (1999)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trisurf(elements3,coordinates(:,1),coordinates(:,2),u','facecolor','interp')
hold on
trisurf(elements4,coordinates(:,1),coordinates(:,2),u','facecolor','interp')
hold off
view(10,40);
title('Solution of the Problem')
