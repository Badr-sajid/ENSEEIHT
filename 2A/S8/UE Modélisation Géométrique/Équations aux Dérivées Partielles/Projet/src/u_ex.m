function sol_ex = u_ex(coordinates)

n = size(coordinates,1);
sol_ex = zeros(n,1);
for i = 1:n
   sol_ex(i) = sin(pi*coordinates(i,1))*sin(pi*coordinates(i,2));
end
end
