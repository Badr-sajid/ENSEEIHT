clear variables;clc
% tolerance relative minimum pour l'ecart entre deux iteration successives 
% de la suite tendant vers la valeur propre dominante 
% (si |lambda-lambda_old|/|lambda_old|<eps, l'algo a converge)
eps = 1e-8;
% nombre d iterations max pour atteindre la convergence 
% (si i > kmax, l'algo finit)
kmax = 5000; 

% Generation d une matrice rectangulaire aleatoire A de taille n x p.
% On cherche le vecteur propre et la valeur propre dominants de AA^T 
n = 1500; p = 500; m = 3;
A = 5*randn(n,p);
% AAt est une matrice carree de tailles respectives (n x n).
AAt = A*A';

%% La méthode de puissance itérée apliquée a AAt en utilisant un vecteur normalisé
x = ones(n,1); x = x/norm(x);
lambda = x'*AAt*x;
cv = false;
iv1 = 0;  % pour compter le nombre d'iterations effectuees
t_v1 =  cputime; % pour calculer le temps d execution de l'algo
err1 = 0; % residu de la norme du vecteur propre. On sort de la boucle 
% quand err1 <eps 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODER L'ALGORITHME DE LA PUISSANCE ITEREE TEL QUE DONNE DANS L'ENONCE
% POUR LA MATRICE AAt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(~cv)
   mu = lambda;
   x = AAt*x;
   x = x/norm(x);
   lambda = x'*AAt*x;
   iv1 = iv1 + 1;
   err1 = abs(lambda-mu)/abs(mu);
   cv = (err1<=eps || iv1>kmax);
   % /!\ Ce break sert a eviter que vous rentriez dans une boucle infini 
   % si vous lancez ce script avant de l'avoir modifier. Pensez a le 
   % supprimer quand vous coderez la puissance iteree
end




%% Methode de la puissance iteree pour la matrice AAt en utilisant une matrice orthogonale
% Point de depart de l'algorithme de la puissance iteree : une matrice
% aleatoire, orthogonale
v = ones(n,m); v = mgs(v);
% Pour la modification de la question 3 on utilise la norme
H = (v'*AAt*v);
cv = false;
iv = 0;  % pour compter le nombre d'iterations effectuees
t_v =  cputime; % pour calculer le temps d execution de l'algo
err = 0; % residu de la norme du vecteur propre. On sort de la boucle 
% quand err1 <eps 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODER L'ALGORITHME DE LA PUISSANCE ITEREE TEL QUE DONNE DANS L'ENONCE
% POUR LA MATRICE AAt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(~cv)
   v = AAt*v;
   for i = 1:m
       v(:,i) = v(:,i)/norm(v(:,i));
   end
   h = v'*AAt*v;
   mu = H;
   H = (h);
   iv = iv + 1;
   err = abs(H - mu)./abs(mu);
   cv = (max(err<=eps)) ;
   % /!\ Ce break sert a eviter que vous rentriez dans une boucle infini 
   % si vous lancez ce script avant de l'avoir modifier. Pensez a le 
   % supprimer quand vous coderez la puissance iteree
end
lambda2 = H;
