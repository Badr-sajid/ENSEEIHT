% Ce programme est le script principal permettant d'illustrer
% un algorithme de reconnaissance de chiffres.

% Nettoyage de l'espace de travail
clear all; close all;

% Repertories contenant les donnees et leurs lectures
addpath('Data');
addpath('Utils')

rng('shuffle')


% Bruit
sig0=0.02;

%tableau des csores de classification
% intialisation aléatoire pour affichage
r=rand(6,5);
r2=rand(6,5);

Precision = 0.8;

for k=1:5
% Definition des donnees
file=['D' num2str(k)]

% Recuperation des donnees
disp('Generation de la base de donnees');
sD=load(file);
D=sD.(file);
%

% Bruitage des données
Db= D+sig0*rand(size(D));


%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des donnees 
%%%%%%%%%%%%%%%%%%%%%%%
disp('PCA : calcul du sous-espace');
%%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
disp('TO DO')

[m,n] = size(Db);

% Calcul de l'individu moyen
Xm = mean(Db,2);

% Calcul de l'individu centré
Xc = Db - Xm;

% Calcul de sigma
sigma = (1/n)*Xc*(Xc');

% Calcul de la svd de sigma
[U,D,~] = svd(sigma);
d = diag(D);

% Calcul de K permettant d'atteindre la précision
K = 1;
precApprox = 0;
while precApprox < Precision && K<n
   precApprox = 1 - sqrt(d(K)/d(1));
   K = K+1;
end

% Calcul du sous-espace représentatif de la classe
UK = U(:,1:K);

%%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

disp('kernel PCA : calcul du sous-espace');
%%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
% Calcul de la matrice K
matrice_K = zeros(n);
for i = 1:n
    for j = 1:n
        matrice_K(i,j) = fun_k(Xc(:,i),Xc(:,j));
    end
end


% Calcul de la svd de la matrice K
[matrice_U,matrice_D,~] = svd(matrice_K);

% Calcul des valeurs propres
valeurs_propres = diag(matrice_D);


% Calcul de K permettant d'atteindre la précision
K1 = 1;
precApprox = 0;
while precApprox < Precision && K1<n
   precApprox = 1 - sqrt(valeurs_propres(K1)/valeurs_propres(1));
   K1 = K1+1;
end

% Calcul des vecteurs alpha_i
alpha = zeros(n,K1);

for i=1:K1
    alpha(:,i) = matrice_U(:,i)/sqrt(valeurs_propres(i));
end


%%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reconnaissance de chiffres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Lecture des chiffres à reconnaitre
 disp('test des chiffres :');
 tes(:,1) = importerIm('test1.jpg',1,1,16,16);
 tes(:,2) = importerIm('test2.jpg',1,1,16,16);
 tes(:,3) = importerIm('test3.jpg',1,1,16,16);
 tes(:,4) = importerIm('test4.jpg',1,1,16,16);
 tes(:,5) = importerIm('test5.jpg',1,1,16,16);
 tes(:,6) = importerIm('test9.jpg',1,1,16,16);


 for tests=1:6
    % Bruitage
    tes(:,tests)=tes(:,tests)+sig0*rand(length(tes(:,tests)),1);
    x = tes(:,tests) - Xm;
    
    % Classification depuis ACP
     %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
     disp('PCA : classification');
     
     r(tests,k) = norm((eye(m) - UK*UK')*x)/norm(x);
          
     if(tests==k)
        % Composante pricipale
        image_ACP = UK*(UK')*x + Xm;
        figure(100+k)
        subplot(1,3,1); 
        imshow(reshape(tes(:,tests),[16,16]));
        title('image_Kernel_ACP');
        subplot(1,3,2);
        imshow(reshape(image_ACP,[16,16]));
        title('ACP');
        sgtitle('Reconstruction de l''image_Kernel_ACP');
     end 
     
    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%
  
   % Classification depuis kernel ACP
     %%%%%%%%%%%%%%%%%%%%%%%%% TO DO %%%%%%%%%%%%%%%%%%
     disp('kernel PCA : classification');
     
     % Calcul du nominateur de la distance
     nom = 0;
     
     for j = 1:K1
         s = 0;
         norme_vj = 0;
        for i = 1:n
            for l = 1:n
               norme_vj = norme_vj + alpha(i,j)*alpha(l,j)*matrice_K(i,l); 
            end
            s = s + alpha(i,j)*fun_k(x,Xc(:,i)) - alpha(i,j)*mean(matrice_K(:,i));
        end
        nom = nom + (s^2)*norme_vj;
     end
     
     
     % Calcul du denominateur de la distance
     denom = fun_k(x,x) + (1/n^2)*sum(sum(matrice_K));
     s = 0;
     for i = 1:n
         s = s + fun_k(x,Xc(:,i));
     end
     denom =  denom - (2/n)*s;
     
     r2(tests,k) = 1 - (nom/denom);
     
      %
     if(tests==k)
         
         % Reconnaissance Noyaux Gaussien
         image_Kernel_ACP = zeros(m,1);
         xc=x-mean(x);
         for iter = 1:4
             nom = zeros(m,1);
             denom = 0;
             for i = 1:n
                 gammai = 0;
                for j = 1:K1
                   for l = 1:n
                       gammai = gammai + alpha(l,j)*alpha(i,j)*fun_k(xc,Xc(:,l));
                   end
                end
                nom = nom + gammai*fun_k(Xc(:,i),image_Kernel_ACP)*Db(:,i);
                denom = denom + gammai*fun_k(Xc(:,i),image_Kernel_ACP);
             end
             image_Kernel_ACP = nom/denom;
         end
     
       figure(100+k)
       subplot(1,3,3);
       imshow(reshape(image_Kernel_ACP,[16,16]));
       title('Kernel ACP');
     end 
      %
    %%%%%%%%%%%%%%%%%%%%%%%%% FIN TO DO %%%%%%%%%%%%%%%%%%    
 end
 
end


% Affichage du résultat de l'analyse par PCA
couleur = hsv(6);

figure(11)
for tests=1:6
     hold on
     plot(1:5, r(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r(tests,i):(r(tests,i+1)-r(tests,i))/10:r(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r(tests,5),num2str(testa));
     hold off
end

 
% Affichage du résultat de l'analyse par kernel PCA
figure(12)
for tests=1:6
     hold on
     plot(1:5, r2(tests,:),  '+', 'Color', couleur(tests,:));
     hold off
 
     for i = 1:4
        hold on
         plot(i:0.1:(i+1),r2(tests,i):(r2(tests,i+1)-r2(tests,i))/10:r2(tests,i+1), 'Color', couleur(tests,:),'LineWidth',2)
         hold off
     end
     hold on
     if(tests==6)
       testa=9;
     else
       testa=tests;  
     end
     text(5,r2(tests,5),num2str(testa));
     hold off
end

function k = fun_k(x,y)
    % Noyau linéaire
    %k = x'*y;  
    
    % Noyau polynomial avec c = 3 q = 2
    c = 3;
    q = 2;
    %k = (c + x'*y)^q;  
    
    % Noyau Gaussien avec sigma = 6
    sigma = 6;
    k = exp((-(norm(x-y))^2)/(2*sigma^2));     
end



