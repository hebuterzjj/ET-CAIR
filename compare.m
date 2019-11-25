clc;
clear;


imagename='images/child.jpg';
M=rgb2gray(imread(imagename));
figure();imshow(M);
T = padarray(M,[1,1],'replicate','both');

X = .5*(T(2:end-1,3:end)-T(2:end-1,1:end-2));
 Y = .5*(T(3:end,2:end-1)-T(1:end-2,2:end-1));
G = abs(X)+abs(Y);
figure();imshow(G);

edge1=edge(M,'canny');
figure();imshow(edge1);


% imagename1='yyyy.png';
% W=imread(imagename1);

% cannyIg=rgb2gray(M);
gausFilter = fspecial('gaussian',[5,5],4.5);                      
cannyIgs=imfilter(M,gausFilter,'replicate');          
SE=edge(cannyIgs,'canny');
figure(), imshow(SE)