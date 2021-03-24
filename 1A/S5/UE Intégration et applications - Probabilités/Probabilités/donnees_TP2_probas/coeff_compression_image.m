function coeff_compression = coeff_compression_image(histogramme,dico)
somme = 0;
for i=1:length(dico)
    somme = somme + histogramme(i)*length(dico{i,2});
end
coeff_compression = sum(histogramme)*8/somme;
    