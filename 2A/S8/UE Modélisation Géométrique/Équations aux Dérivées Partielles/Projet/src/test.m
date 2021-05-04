%le nombre maximale des éléments du maillage
n = 20;

%Les solutions dans le premier et le deuxième cas.
figure(2);
elliptic(2,0)
figure(1);
elliptic(1,n)

%des vecteurs pour l'affichage 
x = zeros(n,1);
y = zeros(n,1);
a = zeros(n,1);
b = zeros(n,1);

for i = 5:n
   [coordinates, ~] = maillage_carre(i);
   [Ah,Uh,~] = elliptic(1,i);
   h = 1/(length(Uh));
   x(i) = h;
   y(i) = h*norm(u_ex(coordinates)-Uh,2);
   R = chol(Ah);
   p = length(find(R~=0));
   a(i) = p;
   b(i) = size(Ah,1);
end

x1 = x(5:size(x,1));
y1 = y(5:size(y,1));

figure(3);
plot(log10(x(5:length(x))), log10(y(5:length(y))));
title('évolution de l erreur en fonction de h');
xlabel('h');
ylabel('erreur');
figure(4);
plot(a(5:length(a)),b(5:length(b)));
title('évolution du nombre des éléments non nuls de R en fonction de la taille de A');
xlabel('taille de A');
ylabel('Nombre des éléments non nuls de R');

