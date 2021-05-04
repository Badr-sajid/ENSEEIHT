function [A, b] = assemblage_triangle(nbTriangles, n, x, y, elements3)

A = zeros(n,n);
b = zeros(n,1);
M_TA = zeros(3,3);
for k = 1:nbTriangles
   alpha = det([x(elements3(k,2))-x(elements3(k,1)) x(elements3(k,3))-x(elements3(k,1));
       y(elements3(k,2))-y(elements3(k,1)) y(elements3(k,3))-y(elements3(k,1))]);
   for i = 1:3
       for j = 1:3
           if i+1 == 3 
               grad_i = (1/alpha)*[y(elements3(k,3))-y(elements3(k,mod(i+2,3)));
                               x(elements3(k,mod(i+2,3)))-x(elements3(k,3))];
           elseif i+2 == 3
               grad_i = (1/alpha)*[y(elements3(k,mod(i+1,3)))-y(elements3(k,3));
                                x(elements3(k,3))-x(elements3(k,mod(i+1,3)))];
           else
           grad_i = (1/alpha)*[y(elements3(k,mod(i+1,3)))-y(elements3(k,mod(i+2,3)));
                               x(elements3(k,mod(i+2,3)))-x(elements3(k,mod(i+1,3)))];
           end
  
           if j+1 == 3 
               grad_j = (1/alpha)*[y(elements3(k,3))-y(elements3(k,mod(j+2,3)));
                               x(elements3(k,mod(j+2,3)))-x(elements3(k,3))];
           elseif j+2 == 3
               grad_j = (1/alpha)*[y(elements3(k,mod(j+1,3)))-y(elements3(k,3));
                                x(elements3(k,3))-x(elements3(k,mod(j+1,3)))];
           else
           grad_j = (1/alpha)*[y(elements3(k,mod(j+1,3)))-y(elements3(k,mod(j+2,3)));
                               x(elements3(k,mod(j+2,3)))-x(elements3(k,mod(j+1,3)))];
           end

       M_TA(i,j) = (alpha/2)*transpose(grad_i)*grad_j;
       end
   end
   A(elements3(k,1), elements3(k,2)) = A(elements3(k,1), elements3(k,2)) + M_TA(1,2);
   A(elements3(k,1), elements3(k,3)) = A(elements3(k,1), elements3(k,3)) + M_TA(1,3);
   A(elements3(k,2), elements3(k,3)) = A(elements3(k,2), elements3(k,3)) + M_TA(2,3);
   
   A(elements3(k,1), elements3(k,1)) = A(elements3(k,1), elements3(k,1)) + M_TA(1,1);
   A(elements3(k,2), elements3(k,2)) = A(elements3(k,2), elements3(k,2)) + M_TA(2,2);
   A(elements3(k,3), elements3(k,3)) = A(elements3(k,3), elements3(k,3)) + M_TA(3,3);
   
   A(elements3(k,2), elements3(k,1)) = A(elements3(k,1), elements3(k,2));
   A(elements3(k,3), elements3(k,1)) = A(elements3(k,1), elements3(k,3));
   A(elements3(k,3), elements3(k,2)) = A(elements3(k,2), elements3(k,3));
   
   x_G = (x(elements3(k,1)) + x(elements3(k,2)) + x(elements3(k,3)))/3;
   y_G = (y(elements3(k,1)) + y(elements3(k,2)) + y(elements3(k,3)))/3;
   
   for i = 1:3
       b(elements3(k,i)) = b(elements3(k,i)) + (alpha/6)*f([x_G y_G]);
   end 
end

end