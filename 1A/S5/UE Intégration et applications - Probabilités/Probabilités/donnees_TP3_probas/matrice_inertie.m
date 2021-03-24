function [C_x,C_y,M] = matrice_inertie(E_x,E_y,G_norme_E)
P = sum(G_norme_E);
C_x = (1/P) * sum(G_norme_E .* E_x);
C_y = (1/P) * sum(G_norme_E .* E_y);
M(1,1) = (1/P) * sum(G_norme_E .* ((E_x-C_x) .* (E_x-C_x)));
M(1,2) = (1/P) * sum(G_norme_E .* ((E_x-C_x) .* (E_y-C_y)));
M(2,1) = (1/P) * sum(G_norme_E .* ((E_y-C_y) .* (E_x-C_x)));
M(2,2) = (1/P) * sum(G_norme_E .* ((E_y-C_y) .* (E_y-C_y)));