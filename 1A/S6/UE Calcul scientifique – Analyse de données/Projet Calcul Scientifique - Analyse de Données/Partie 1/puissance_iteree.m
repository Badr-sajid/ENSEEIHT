clear variables;clc
% tolerance relative minimum pour l'ecart entre deux iteration successives 
% de la suite tendant vers la valeur propre dominante 
% (si |lambda-lambda_old|/|lambda_old|<eps, l'algo a converge)
eps = 1e-8;
% nombre d iterations max pour atteindre la convergence 
% (si i > kmax, l'algo finit)
kmax = 5000; 

% Generation d une matrice rectangulaire aleatoire A de taille n x p.
% On cherche le vecteur propre et la valeur propre dominants de AA^T puis
% de A^TA
n = 1500; p = 500;
A = 5*randn(n,p);
% AAt, AtA sont deux matrices carrees de tailles respectives (n x n) et 
% (p x p). Elles sont appelees "equations normales" de la matrice A
AAt = A*A'; AtA = A'*A;
%% Methode de la puissance iteree pour la matrice AAt de taille nxn
% Point de depart de l'algorithme de la puissance iteree : un vecteur
% aleatoire, normalise
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
t_v1 = cputime-t_v1; % t_version1 : temps d execution de l algo de la 
% puissance iteree pour la matrice AAt

%% Methode de la puissance iteree pour la matrice AtA de taille pxp
% Point de depart de l'algorithme de la puissance iteree : un vecteur
% aleatoire, normalise
y = ones(p,1); y = y/norm(y);
lambda2 = y'*AtA*y;
cv = false;
iv2 = 0;  % pour compter le nombre d iterations effectuees
t_v2 =  cputime; % pour calculer le temps d execution de l'algo
err2 = 0; % residu de la norme du vecteur propre. On sort de la boucle 
% quand err2 <eps 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODER L ALGORITHME DE LA PUISSANCE ITEREE TEL QUE DONNE DANS L'ENONCE
% POUR LA MATRICE AtA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(~cv)
   mu2 = lambda2;
   y = AtA*y;
   y = y/norm(y);
   lambda2 = y'*AtA*y;
   iv2 = iv2 + 1;
   err2 = abs(lambda2-mu2)/abs(mu2);
   cv = (err2<=eps || iv2>kmax);
    % /!\ Ce break sert a eviter que vous rentriez dans une boucle infini
    % si vous lancez ce script avant de l'avoir modifier. Pensez a le
    % supprimer quand vous coderez la puissance iteree
end
t_v2 = cputime-t_v2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APRES VOUS ETRE ASSURE DE LA CONVERGENCE DES DEUX METHODES, AFFICHER 
% L'ECART RELATIF ENTRE LES DEUX VALEURS PROPRES TROUVEES, ET LE TEMPS
% MOYEN PAR ITERATION POUR CHACUNE DES DEUX METHODES. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Erreur relative pour la methode avec la grande matrice = %0.3e\n',err1);
fprintf('Erreur relative pour la methode avec la petite matrice = %0.3e\n',err2);
fprintf('Ecart relatif entre les deux valeurs propres trouvees = %1.2e\n', abs(lambda-lambda2)/abs(lambda));
fprintf('Temps pour une ite avec la grande matrice = %0.3e\n',t_v1/iv1);
fprintf('Temps pour une ite avec la petite matrice = %0.3e\n',t_v2/iv2);
