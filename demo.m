tic
 
addpath(genpath('rbd'));
addpath(genpath('detectFacePart'));
 
 reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end

ratio=0.6;
inputpath = '.\images\';
outputpath = '.\result\';
imagename = 'seam1';
srcSuffix = '.png';

%--- Parameters

p.piecewiseThresh = 9e9; % threshold for piecewise-connected seams (see seamConstructPathPiecewise). Set to very large value to ignore
p.method = 'backward'; % 'backward' or 'forward'
p.seamFunc = @seamPath_dp; % @seamPath_dp for dynamic programming, @seamPath_gcut for graph-cut
p.s = 1; % permissible seam step (used by seamPath_dp)
p.errFunc.name = @errL1; % error function (used by backward energy)
p.errFunc.weightNorm = @errWeightAdd; % function for incorporating additional weight map (used by backward energy)

%--- Run

Img = imread(strcat(inputpath,imagename,srcSuffix));
I = im2double(Img);

%% face
detector = buildDetector();
[bbox bbimg faces bbfaces,ourface] = detectFaceParts(detector,Img,2);
% figure(1);imshow(ourface);title('face');

%% SaliencyMap
rbd = rbdmap(Img);
% figure(2);imshow(rbd);title('saliency');

%% grad
M = rgb2gray(I);
[X,Y] = fastgradient(M);
G = abs(X)+abs(Y);
% figure(3);imshow(G);title('grad');

W=0.6*ourface+0.5*G+0.4*rbd;
% figure(4);imshow(W);title('important');

nChannels=size(I,3);
if (nChannels == 1)
    I = repmat(I,[1,1,3]);
end
[height,width,nChannels] = size(I);

% target size (change either width or height, but not both).
% maintain target size within bounds of the image, otherwise will cause 
% an index out of bounds error.
new_width = floor(ratio*width);        
new_height = height;
% new_width = width;        
% new_height = floor(ratio*height);
% J is the retargeted image, S is the seams map
[J,S] = imretarget(I,[new_height,new_width],W,p);

Seam=seamOverlay(I,S);
figure; imshow(Seam); title('Seams');
% imwrite(Seam,strcat(outputpath,imagename,'_Seam',srcSuffix));
% figure; imshow(I); title('Input');
figure; imshow(J); title('Retarget');
% figure; imshow(seamOverlay(I,S)); title('Seams');
% 
[h1,w1,c1]=size(J);
r1=1-((w1-width*ratio)/w1);

tar=imresize(J,[h1,w1*r1]);
% figure; imshow(tar); title('Retarget');
imwrite(tar,strcat(outputpath,imagename,'_ET-CAIR',srcSuffix));
toc;
