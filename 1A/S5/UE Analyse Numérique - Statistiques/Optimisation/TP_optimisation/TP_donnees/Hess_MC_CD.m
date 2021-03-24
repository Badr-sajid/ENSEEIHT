%-------------------------------------------------------------------------%
% 1SN - TP Optimisation                                                   %
% INP Toulouse - ENSEEIHT                                                 %
%                                                                         %
% Fonction de calcul de la Hessienne des moindres carres                  %
% de la fonction de Cobb-Douglas                                          %
%-------------------------------------------------------------------------%

function H = Hess_MC_CD(beta)

    global Ki Li 
    alpha = beta(2);
    A = beta(1);
    r = res_CD(beta);
    Jres = Jac_res_CD(beta);
    H(1,1) = sum(Ki.^(2*alpha)*Li.^(2-2*alpha));
    H(1,2) = -sum(A*Jres(:,1).*(Ki.^(alpha)).*(Li.^(1-alpha)).*(log(Ki)-log(Li)) + r.*(log(Ki)-log(Li)).*(Ki.^(alpha)).*(Li.^(1-alpha)));
    H(2,1) = H(1,2);
    H(2,2) = sum(Jres(:,2).^2 -A*r.*(Ki.^(alpha)).*(Li.^(1-alpha)).*(log(Ki)-log(Li)).^2);
end
