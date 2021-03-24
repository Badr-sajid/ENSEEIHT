%-------------------------------------------------------------------------%
% 1SN - TP Optimisation                                                   %
% INP Toulouse - ENSEEIHT                                                 %
%                                                                         %
% Fonction de calcul de la Jacobienne du residu                           %
% de la fonction de Cobb-Douglas                                          %
%-------------------------------------------------------------------------%

function Jres = Jac_res_CD(beta)

    global Ki Li
    
    A = beta(1);
    alpha = beta(2);
    Jres[:,1] = -(Ki.^(aplha)).*(Li.^(1-alpha));
    Jres[:,2] = -A*(log(Ki)-log(Li)).*(Ki.^(aplha)).*(Li.^(1-alpha));
    

end
