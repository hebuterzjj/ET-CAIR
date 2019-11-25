function [ G ] = errupdate( G,xpath )

[h,w,c]=size(G);

    de=0; 
    for i=1:h
       
       de=de+G(i,xpath(i));
    end

    
    deleft1=zeros(h,1);
    for i=1:h
        if(xpath(i)==1)
           deleft1(i)=0; 
        else
            deleft1(i)=G(i,xpath(i)-1);
        end
    end
   deleft=sum(deleft1);
    
   deright1=zeros(h,1);
   for i=1:h
       if(xpath(i)==w)
           deright1(i)=0;
       else
           deright1(i)=G(i,xpath(i)+1);
   
       end
   end
   deright=sum(deright1);
   
   ratioleft=deleft/de;
   ratioright=deright/de;
   h1=zeros(h,1); h2=zeros(h,1);
   
   for i=1:h
       if(xpath(i)==1)
           h1(i)=0; 
%            G(i,xpath(i))=0;
       else
           h1(i)= G(i,xpath(i)-1) + ratioleft*G(i,xpath(i));
           G(i,xpath(i)-1)=h1(i);
       end
       
   end
      
       
       
  for i=1:h
      if(xpath(i)==w)
          h2(i)=0;
      else
          h2(i)=  G(i,xpath(i)+1) + ratioright*G(i,xpath(i));
           G(i,xpath(i)+1)=h2(i);
       end
  end
   
   G = seamRemove(G,xpath);
end

