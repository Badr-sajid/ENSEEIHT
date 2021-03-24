%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Analyse de donnees
% Reconnaissance de chiffres manuscrits par k plus proches voisins
% fonction kppv.m
%--------------------------------------------------------------------------
function [Partition,d,indice_proche,Conv] = kppv(DataA,DataT,labelA,K,ListeClass,labelT)

[Na,~] = size(DataA);
[Nt,~] = size(DataT);

Nt_test = 10; % A changer, pouvant aller de 1 jusqu'à Nt

% Initialisation du vecteur d'étiquetage des images tests
Partition = zeros(Nt_test,1);

disp(['Classification des images test dans ' num2str(length(ListeClass)) ' classes'])
disp(['par la methode des ' num2str(K) ' plus proches voisins:'])

% Boucle sur les vecteurs test de l'ensemble de l'évaluation
for i = 1:Nt_test
    
    disp(['image test n°' num2str(i)])

    % Calcul des distances entre les vecteurs de test 
    % et les vecteurs d'apprentissage (voisins)
    d = sqrt(sum((repmat(DataT, Na, 1) - DataA) .^ 2,2));
    
    % On ne garde que les indices des K + proches voisins
    [~,ind] = sort(d);
    indice_proche = ind(1:K);
    
    test_label = labelA(indice_proche);
    
    % Comptage du nombre de voisins appartenant à chaque classe
    nb_voisin = histc(test_label, ListeClass);
    
    % Recherche de la classe contenant le maximum de voisins
    [classe_max_voisin, max_indice] = max(nb_voisin);

    % Si l'image test a le plus grand nombre de voisins dans plusieurs  
    % classes différentes, alors on lui assigne celle du voisin le + proche,
    % sinon on lui assigne l'unique classe contenant le plus de voisins 
    
   if (length(find(nb_voisin == classe_max_voisin)) > 1)
        individu_trouve = labelA(indice_proche(1));
    else
        individu_trouve = ListeClass(max_indice);
    end
        
    % Assignation de l'étiquette correspondant à la classe trouvée au point 
    % correspondant à la i-ème image test dans le vecteur "Partition" 
    Partition(i,1) = individu_trouve;
end
    
Conv = zeros(Na, Na);

  elt= 0;
   for i=1:Na
       for j=1:Na
           for k=1:Nt
               if (labelT(k) == i) && (Partition(k) == j)
                   elt = elt+1;
               end
           end
          Conv(i,j) = elt;
          elt = 0;
       end
   end

end

