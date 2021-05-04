function [M, alpha] = matriceRaideur_quadrangle(q_indices, x, y) 

M = zeros(4,4);

J_phi =  [x(q_indices(2))-x(q_indices(1)),x(q_indices(4))-x(q_indices(1));
          y(q_indices(2))-y(q_indices(1)),y(q_indices(4))-y(q_indices(1))];

det_Jphi = det(J_phi);
matrice = inv(transpose(J_phi)*J_phi);
a = matrice(1,1);
b = matrice(1,2);
c = matrice(2,2);

M = [2*a+3*b+2*c -2*a+c -a-3*b-c a-2*c;
     -2*a+c 2*a-3*b+2*c a-2*c -a+3*b-c;
     -a-3*b-c a-2*c 2*a+3*b+2*c -2*a+c;
     a-2*c -a+3*b-c -2*a+c 2*a-3*b+2*c];
 
M = (det_Jphi/6)*M;
alpha = det([x(q_indices(2))-x(q_indices(1)),x(q_indices(3))-x(q_indices(1));
             y(q_indices(2))-y(q_indices(1)),y(q_indices(3))-y(q_indices(1))]);
             

end