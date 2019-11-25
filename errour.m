function G = errour(M)

% Compute L1 error norm
gausFilter = fspecial('gaussian',[5,5],4.5);                     
cannyIgs=imfilter(M,gausFilter,'replicate');         
G=edge(cannyIgs,'canny');
% figure(), imshow(G)

return;