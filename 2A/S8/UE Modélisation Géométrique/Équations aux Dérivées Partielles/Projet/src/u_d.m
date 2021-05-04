function DirichletBoundaryValue = u_d(x)
%
% Fonction codant la valeur de la solution imposees sur la frontiere
% de Dirichlet. Ce code est fait pour etre appele sur un ou plusieurs
% points.
%
% Entrees :
%       X : matrice de points en lesquels f doit etre calculee.
%       Chaque ligne represente un point 2D; X a donc necessairement deux
%       colonnes.
%
% Sortie :
%       DirichletBoundaryValue : vecteur colonne des valeurs de u_d en les 
%	points definis par X. Si X contient N lignes, u_d est un vecteur de 
%	taille N*1.
%
% Source : J. Alberty, C. Carstensen and S. A. Funken  (1999)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exemple de reference : u_d est la fonction constante egale a 0
DirichletBoundaryValue = ones(size(x,1),1);
%
%	
