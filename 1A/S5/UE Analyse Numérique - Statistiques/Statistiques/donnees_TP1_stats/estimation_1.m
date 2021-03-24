function C_estime = estimation_1(x_donnees_bruitees,y_donnees_bruitees,C_tests,R_0)
for i = 1:length(C_tests)
    d(i) = sum((sqrt((x_donnees_bruitees - C_tests(i,1)).^2 + (y_donnees_bruitees - C_tests(i,2)).^2) - R_0).^2);
end
[m Ind] = min(d);
C_estime = C_tests(Ind,:);

