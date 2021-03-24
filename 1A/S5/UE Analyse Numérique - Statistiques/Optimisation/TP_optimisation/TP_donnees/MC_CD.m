%-------------------------------------------------------------------------%
% 1SN - TP Optimisation                                                   %
% INP Toulouse - ENSEEIHT                                                 %
%                                                                         %
% Fonction de calcul des moindres carres de la fonction de Cobb-Douglas   %
%-------------------------------------------------------------------------%

function y = MC_CD(beta)

    r = res_CD(beta);
    y = (1/2)*sum(r.^2);
    
end
