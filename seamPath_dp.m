function [xpath,cost,E] = seamPath_dp(M,W,G,p)

% Run Dynamic Programming to find optimal seam
if (strcmpi(p.method,'backward')==1)
    E = constructErrImage_backward(M,W,G,p);
elseif (strcmpi(p.method,'forward')==1)
    E = constructErrImage_forward(M,W,G,p);
end

% E = constructErrImage_backward(M,W,p);
% 
% E1 = constructErrImage_forward(M,W,p);
% 
% E=max(E,E1);

% Reconstruct path
[xpath,cost] = seamConstructPathPiecewise(E,p.s,p.piecewiseThresh);

return;