function [ S ] = updatepath( S,xpath )



v = -1;

for i=1:length(xpath),
    idx = find(S(i,:)==0);
    S(i,idx(xpath(i))) = v;
end;

end

