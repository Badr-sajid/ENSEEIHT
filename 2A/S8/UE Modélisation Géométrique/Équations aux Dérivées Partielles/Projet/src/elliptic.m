function [Ah,u,b] = elliptic(choix, nb) 

if (choix == 2)
    coordinates = load('coordinates.dat');
    elements3 = load('elements3.dat');
    dirichlet = load('dirichlet.dat');
    neumann = load('neumann.dat');
    elements4 = load('elements4.dat');
    
else
    [coordinates, elements3, elements4, dirichlet, neumann] = maillage_carre(nb);
end

[n,~] = size(coordinates);

[nbTriangles,~] = size(elements3);
[nbQuadrangles,~] = size(elements4);
x = coordinates(:,1);
y = coordinates(:,2);

%Assemblage triangle

%calcul de la matrice A et du second membre b
[A, b] = assemblage_triangle(nbTriangles, n, x, y, elements3);
disp(b);

%Assemblage quadrangle
for k = 1:nbQuadrangles
     q_indices = elements4(k,:);
     % On calcule la matrice de raideur du quadrangle q
     [Mq,alpha] = matriceRaideur_quadrangle(q_indices,x,y);
      for i=1:4
         for j=1:4
             A(q_indices(i),q_indices(j))=A(q_indices(i),q_indices(j))+Mq(i,j);
         end
      end
     % Calcul du second membre
     xG = (x(q_indices(1)) + x(q_indices(2)) + x(q_indices(3)) + x(q_indices(4)))/4;
     yG = (y(q_indices(1)) + y(q_indices(2)) + y(q_indices(3)) + y(q_indices(4)))/4;
     for i = 1:4
         b(q_indices(i)) = b(q_indices(i))+(alpha/4)*f([xG yG]);
     end
end

% Assemblage du second membre : Contribution des conditions de Dirichlet
Ud = zeros(n,1);
for i=1:size(dirichlet,1)
    Ud(dirichlet(i)) = u_d([x(dirichlet(i)) y(dirichlet(i))]);
end
b = b - A*Ud;


%Condition de Neumann
for i=1:size(neumann,1)
    front_elt = neumann(i,:);
    x1 = x(front_elt(1));
    y1 = y(front_elt(1));
    x2 = x(front_elt(2));
    y2 = y(front_elt(2));
    p1 = [x1 y1];
    p2 = [x2 y2];
    b(neumann(i,:)) = b(neumann(i,:)) + 0.5*norm(p2-p1)*g(0.5*(p1+p2)); 
end

    

% Imposition de la solution liée aux conditions de Dirichlet
u = Ud;
% Les noeuds de calcul
noeud = setdiff(1:n,dirichlet);
% Resolution : 
Ah = A(noeud,noeud);
u(noeud) = Ah\b(noeud);
show(elements3,elements4,coordinates,u);

end