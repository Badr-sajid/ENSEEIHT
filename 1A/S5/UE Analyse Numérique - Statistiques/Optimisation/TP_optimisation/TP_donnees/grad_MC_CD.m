%-------------------------------------------------------------------------%
% 1SN - TP Optimisation                                                   %
% INP Toulouse - ENSEEIHT                                                 %
%                                                                         %
% Fonction de calcul du gradient des moindres carres                      %
% de la fonction de Cobb-Douglas                                          %
%-------------------------------------------------------------------------%

function g = grad_MC_CD(beta)

    Jres = Jac_res_CD(beta);
    r = res_CD(beta);
    g(1) = sum(Jres(:,1).*r); 
    g(2) = sum(Jres(:,2).*r); 

end
