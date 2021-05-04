function [coordinates, elements3, elements4, dirichlet, neumann] = maillage_carre(n)
%
% Une discretisation possible d'une EDP elliptique sur le domaine ]0,1[ x ]0,1[
% Le carre [0,1]x[0,1] est maille uniquement avec des triangles => elements4=[]; 
% Les conditions limites sont de type Dirichlet uniquement     => neumann  =[];
%
% Entrees :
%	n : nombre de points par cote du care => Npts points de discretisation au
%	total
%
% Sorties :
%	coordinates : matrice a deux colonnes. Chaque ligne contient les 
%	coordonnes 2D d'un des points de la discretisation. Ces sommets seront 
%	identifies a l'indice de la ligne correspondante dans la matrice
%	coordinates.
%	elements3 : matrice a trois colonnes. Chaque ligne contient les indices 
%	des sommets d'un element triangle, dans le sens antihoraire. 
%	elements4 : matrice a quatre colonnes. Chaque ligne contient les indices
%	des sommets d'un element quadrangle, dans le sens antihoraire. 
%	(elements4 est vide sur cet exemple)
%	dirichlet : vecteur colonne des indices des sommets de la frontiere de
%	Dirichlet.
%	neumann : matrice a deux colonnes. Chaque ligne contient les indices 
%	des deux sommets d'une arete de la frontiere de Neumann.
%	(neumann est vide sur cet exemple)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h           = 1./(n-1);
npoin       = n*n ; 
nelem       = 2*(n-1)*(n-1) ;
coordinates = zeros(npoin,2) ; 
elements3   = zeros(nelem,3) ;
elements4   = [];
neumann     = [];
% Coordonnees et connectivites :
e = 0 ; 
p = 0 ;
x = [0 :h :1] ;
for j = 1 :n
    for i = 1 :n
        p = p + 1 ; 
        coordinates(p,1) = x(i) ; 
        coordinates(p,2) = x(j) ;
        if i ~= n & j ~= n
           p1 = p ; p2 = p1 + 1 ; p3 = p1 + n ; p4 = p2 + n ;
           e = e + 1 ; elements3(e,1) = p1 ; elements3(e,2) = p2 ; elements3(e,3) = p3 ;
           e = e + 1 ; elements3(e,1) = p4 ; elements3(e,2) = p3 ; elements3(e,3) = p2 ;
        end
    end
end
% Liste des sommets de la frontiere de Dirichlet:
dirichlet = [1:n] ;                          % bas
dirichlet = [dirichlet,n*(2:n-1)] ;          % droite
dirichlet = [dirichlet,(n^2):-1:(n^2-n+1)] ; % haut
dirichlet = [dirichlet,n*(n-1:-1:2)-n+1] ;   % gauche
dirichlet = dirichlet';
