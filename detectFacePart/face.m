function [ ourface] = face( imagename )

reqToolboxes = {'Computer Vision System Toolbox', 'Image Processing Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 error('detectFaceParts requires: Computer Vision System Toolbox and Image Processing Toolbox. Please install these toolboxes.');
end

img = imread(imagename);

detector = buildDetector();
[bbox bbimg faces bbfaces,ourface] = detectFaceParts(detector,img,2);

% figure;imshow(bbimg);
% for i=1:size(bbfaces,1)
%     face=bbfaces{i};
%   
% %  figure;imshow(bbfaces{i});
% end

%  figure;imshow(ourface);




end

