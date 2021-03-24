%--------------------------------------------------------------------------
% ENSEEIHT - 1SN - Calcul scientifique
% TP1 - Orthogonalisation de Gram-Schmidt
% cgs.m
%--------------------------------------------------------------------------

function Q = cgs(A)

    % Recuperation du nombre de colonnes de A
    [~, m] = size(A);
    
    % Initialisation de la matrice Q avec la matrice A
    Q = A;
    
    %------------------------------------------------
    for i = 1:m
        y = A(:,i);
        for j = 1:i-1
            y = y - sum(y.*Q(:,j))*Q(:,j);
        end
        y_normalisee = y/(sqrt(sum(y.*y)));
        Q(:,i) = y_normalisee;
    end
    %------------------------------------------------

end