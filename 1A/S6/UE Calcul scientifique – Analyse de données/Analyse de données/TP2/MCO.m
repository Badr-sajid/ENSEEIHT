function Beta_chapeau = MCO(x, y)
    n = length(x); 
    
    A = [x.^2 x.*y y.^2 x y ones(n,1); 1 0 1 0 0 0];
    b = [zeros(n,1); 1];
    Beta_chapeau = pinv(A)*b;

end
