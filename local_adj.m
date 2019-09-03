function [C,Indice_all]=local_adj(indi,D,glind,C,SEl,Z)
Indice_all=[];
 for k=1:size(indi,1)
        
        Ainb=return_id(SEl(SEl(:,1)==glind,2:3),SEl(SEl(:,1)==D(indi(k,1),1),2:3));
        L=[];
        for j=1:size(Ainb,1)
            L=[L,Z(Ainb(j,1),Ainb(j,2))];
            
        end
%         X=1:size(L,2);
%         Y=L;
%         P=polyfit(X,Y,2);
%         Y1 = polyval(P,X);
        if ((max(L)-min(L))<=200) 
            C(min([glind SEl(SEl(:,1)==D(indi(k,1),1))]),max([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=1;
            C(max([glind SEl(SEl(:,1)==D(indi(k,1),1))]),min([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=1;  
        elseif ((max(L)-min(L))>200) && ((max(L)-L(1))<=100)&& ((min(L)-L(size(L,2)))<=100)
            C(min([glind SEl(SEl(:,1)==D(indi(k,1),1))]),max([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=1;
            C(max([glind SEl(SEl(:,1)==D(indi(k,1),1))]),min([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=0; 
        elseif ((max(L)-min(L))>200) && ((max(L)-L(size(L,2)))<=100)&& ((min(L)-L(1))<=100)  
            C(min([glind SEl(SEl(:,1)==D(indi(k,1),1))]),max([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=0;
            C(max([glind SEl(SEl(:,1)==D(indi(k,1),1))]),min([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=1; 
        else
            C(min([glind SEl(SEl(:,1)==D(indi(k,1),1))]),max([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=0;
            C(max([glind SEl(SEl(:,1)==D(indi(k,1),1))]),min([glind SEl(SEl(:,1)==D(indi(k,1),1))]))=0; 
        end
        
        Indice_all=[Indice_all D(indi(k,1),1)];

        
 end
 Indice_all=[Indice_all glind];
end