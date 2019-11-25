function [ xx_org, yy_org ] = newregistration( J,allpath)
%UNTITLED2 
%   
%   xx=zeros(size(J,1),size(J,2)-i);xx=zeros(size(J,1),size(J,2)-i);
  
[yy_org,xx_org] = meshgrid(1:size(J,2), 1:size(J,1));
for ii=1:size(J,1)
    for jj=1:size(J,2)
        if(allpath(ii,jj)==-1)
%          xx_org(ii,jj)=-1;
         yy_org(ii,jj)=0;
       
        end
    end
end

%   A=find(yy_org>0);
%   a=1;
end

