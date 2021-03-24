function frequences = calcul_frequences(texte,alphabet)
    frequences = zeros(length(alphabet));
    for i = 1 : length(alphabet)
        indices = find(texte == alphabet(i));
        frequences(i) = length(indices)/length(texte);
    end
end
