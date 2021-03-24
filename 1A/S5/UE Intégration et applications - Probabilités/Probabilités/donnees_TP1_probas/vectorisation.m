function [X,Y] = vectorisation(I)
X = I(:, 1:end-1);
Y = I(: ,2:end);
X = X(:);
Y = Y(:);


