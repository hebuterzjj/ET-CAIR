function [ G ] = errL2( M )

[X,Y] = fastgradient(M);
% G = abs(X)+abs(Y);
G=sqrt( (X.^2+Y.^2));
end

