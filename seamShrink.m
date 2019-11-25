function [J,S,allpath] = seamShrink(J,wnew,W,p)

imageorg=J;
salorg=W;
M = rgb2gray(J);
  %figure(),imshow(M); title("M")

S = zeros(size(J,1),size(J,2));
allpath = zeros(size(J,1),size(J,2));
n = size(J,2)-wnew;
if nargout==3
    xp = zeros(size(J,1),n);
%   energy = zeros(1,n);

end

 G = errImage(M,W,p.errFunc);

 Gorg=G;
% figure();imshow(G);
% total=sum(sum(G));
% total1=total;

%  the=threshold(G);

for i=1:n
    fprintf(1,'Seam %d (%d)\n',i,n);
 
    [xpath,cost,E] = p.seamFunc(M,W,[],p);
       
%     de=0; 
%     for j=1:size(J,1)
%        de=de+G(j,xpath(j));
%     end
%     
%     total1=total1-de;
%     Se=total1/total;
%     if(Se<0.9)
%         break;
%     end
%     
    normEnergy = cost;%E(end,xpath(end))/length(xpath);
    if nargout==3
        xp(:,i) = xpath;
%       energy(i) = normEnergy;
    end
    
       G = errupdate(G,xpath);
%       figure; imshow(G); title('updataG');
%      imwrite(G,strcat('F:\data\move\str\','updataG.bmp'));
%      figure; imshow(seamOverlay(Gorg,G)); title('Seams_G')

%     total=sum(sum(G));

    % update
    
    J = seamRemove(J,xpath); % remove seam from original image
    
     allpath=updatepath(allpath,xpath);
%      [xx,yy]=newregistration(imageorg,allpath);
%      
     

    score=newARS(imageorg,Gorg,allpath);
    if(score<0.99)
        break
    end
    


%   G = seamRemove(G,xpath); % remove seam from work image
    M = seamRemove(M,xpath); % remove seam from work image
%     W = seamRemove(W,xpath); % remove seam from weights
    W = G;
    S = updateSurvivalImage(S,xpath,normEnergy);
%     figure(),imshow(S);
%      a=1;
end;

