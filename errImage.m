function G = errImage(I,W,errFunc)

if size(I,3)==3
    M = rgb2gray(I);
else
    M = I;
end;

G = errFunc.name(M);

% figure();imshow(G);

% edge=edge(M,'canny');

% G = errL2(M);  
% figure();imshow(G);

%calculate Canny map
% Icanny=edge(M,'canny');
% 
% %calculate Hough map
% Ihough=houghedge(I,Icanny);

% gausFilter = fspecial('gaussian',[5,5],4.5);                      
% cannyIgs=imfilter(M,gausFilter,'replicate');         
% G=edge(cannyIgs,'canny');
% % figure();imshow(G);

% Add weights
if ~isempty(errFunc.weightNorm)
    G = errFunc.weightNorm(G,W);   
end;

return;