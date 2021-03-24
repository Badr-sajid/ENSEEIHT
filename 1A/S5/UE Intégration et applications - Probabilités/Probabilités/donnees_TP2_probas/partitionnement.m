function bornes = partitionnement(selection_frequences)
longueur = length(selection_frequences);
bornes   = zeros(2,longueur);
bornes(1,1) = 0;
bornes(2,1) = selection_frequences(1);
for i = 2 : longueur
    bornes(1,i) = bornes(2,i-1);
    bornes(2,i) = selection_frequences(i) + bornes(2,i-1);
end 