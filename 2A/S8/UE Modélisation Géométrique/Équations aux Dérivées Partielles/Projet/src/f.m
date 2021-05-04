function VolumeForce = f(x);
% 
% Code de la fonction f apparaissant dans l'EDP elliptique (au sens physique,
% il s'agit d'une force volumique). Ce code est fait pour etre appele sur un
% ou plusieurs points.
%
% Entrees :
%	X : matrice de points en lesquels f doit etre calculee.
%	Chaque ligne represente un point 2D; X a donc necessairement deux
%	colonnes.
%
% Sortie :
%	VolumeForce : vecteur colonne des valeurs de f en les points definis
%	par X. Si X contient N lignes, f est un vecteur de taille N*1.
%
% Source : J. Alberty, C. Carstensen and S. A. Funken  (1999)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exemple choisi : f est la fonction constante egale a 1
VolumeForce = ones(size(x,1),1);
%VolumeForce = 2*(pi)^2*sin(pi*x(1))*sin(pi*x(2));
%
