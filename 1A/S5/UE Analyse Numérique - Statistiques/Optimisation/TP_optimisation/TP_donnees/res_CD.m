%-------------------------------------------------------------------------%
% 1SN - TP Optimisation                                                   %
% INP Toulouse - ENSEEIHT                                                 %
%                                                                         %
% Fonction de calcul du residu de la fonction de Cobb-Douglas             %
%-------------------------------------------------------------------------%

function r = res_CD(beta)

    global Ki Li Yi
    A = beta(1);
    alpha = beta(2);
    r = Yi - A*(Ki.^(alpha)).*(Li.^(1-alpha));

end
