 tic;
ratio=0.6;

addpath(genpath('rbd'));
addpath(genpath('detectFacePart'));

p.piecewiseThresh = 9e9; % threshold for piecewise-connected seams (see seamConstructPathPiecewise). Set to very large value to ignore
p.method = 'backward'; % 'backward' or 'forward'
p.seamFunc = @seamPath_dp; % @seamPath_dp for dynamic programming, @seamPath_gcut for graph-cut
p.s = 1; % permissible seam step (used by seamPath_dp)
p.errFunc.name = @errL1; % error function (used by backward energy)
p.errFunc.weightNorm = @errWeightAdd; % function for incorporating additional weight map (used by backward energy)

file_path='.\images\';  
outputpath = '.\result\';
img_path_list=dir(strcat(file_path,'*.jpg'));
img_num=length(img_path_list);

%im_file_path='F:\data\move\str\'; 
% im_img_path_list=dir(strcat(im_file_path,'*.png'));

if img_num >0 
    for j=1:img_num  
        image_name=img_path_list(j).name;
        %im_image_name=['im_',image_name];

%         image=imread(strcat(file_path,image_name));
        fprintf('%d %s\n',j,strcat(file_path,image_name));

        Img = imread(strcat(file_path,image_name));
        I = im2double(Img);
        %W=im2double(imread(strcat(im_file_path,im_image_name)));
        
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
        
        W=0.6*ourface+0.9*G+0.4*rbd;
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
% %         new_width = width;
% %         new_height =floor(ratio*height);
        % J is the retargeted image, S is the seams map
        [J,S] = imretarget(I,[new_height,new_width],W,p);
        
        Seam=seamOverlay(I,S);
%         figure; imshow(Seam); title('Input');
%         imwrite(Seam,strcat('F:\data\move\str\','seam.png'));
        %figure; imshow(I); title('Input');
        %figure; imshow(J); title('Retarget');;
%         figure; imshow(seamOverlay(W,S)); title('Seamsg');
%         imwrite(seamOverlay(W,S),strcat('F:\data\move\str\','UpdateG.png'));
        
        
        [h1,w1,c1]=size(J);
        r1=1-(abs(w1-width*ratio)/w1);
% %         r1=1-((h1-height*ratio)/h1);
        
        tar=imresize(J,[h1,w1*r1]);
% %         tar=imresize(J,[h1*r1,w1]);
        S=image_name;
        S(end-3:end)=[];
        imwrite(tar,strcat(outputpath,S,'_0.60_ET-CAIR.png'));


    end
end
toc;