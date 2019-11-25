function [the ] = threshold( G )

total=sum(sum(G));
figure();imshow(G)

level = graythresh(G);
BW = im2bw(G,level);
figure,imshow(BW)
a=0;

for i=1:size(G,1)
 for j=1:size(G,2)
    if(BW(i,j)==1)
        a=a+G(i,j);
    end
 end
end
the=a/total;


end

