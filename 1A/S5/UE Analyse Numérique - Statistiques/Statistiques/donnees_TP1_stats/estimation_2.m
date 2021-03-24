function [C_estime R_estime] = estimation_2(x_donnees_bruitees,y_donnees_bruitees,C_tests,R_tests)
for i = 1:length(C_tests)
    d(i) = sum((sqrt((x_donnees_bruitees - C_tests(i,1)).^2 + (y_donnees_bruitees - C_tests(i,2)).^2) - R_tests(i)).^2);
  
end
[m Ind] = min(d);
C_estime = C_tests(Ind,:);
R_estime = R_tests(Ind,:);
