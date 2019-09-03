function C=Adj_El_M(latlim,lonlim,AData,Z,year)

A=AData;

At1=A(A.year==year,[3 4 8 25 26 27]);

[Lo,La] = meshgrid(linspace(lonlim(1,1),lonlim(1,2),size(Z,2)),linspace(latlim(1,1),latlim(1,2),size(Z,1)));

SAt1=At1;

SAt1=table2array(SAt1);

SAt1=SAt1((SAt1(:,1)>=lonlim(1,1)) & (SAt1(:,1)<=lonlim(1,2)),:);
SAt1=SAt1((SAt1(:,2)>=latlim(1,1)) & (SAt1(:,2)<=latlim(1,2)),:);

% construct the connectivity matrix based on elevation
SEl=[];
for i=1:size(SAt1,1)
    D= (Lo-SAt1(i,1)).^2+ (La-SAt1(i,2)).^2;
    [indi,indj]=find(D==min(min(D)));
    SEl(i,1:6)=[i indi indj Z(indi,indj)-1 SAt1(i,1) SAt1(i,2)];
end
D=SEl;C=zeros(size(SEl,1),size(SEl,1));
while size(D,1)>=1
    glind=D(1,1);
    D(1,:)=[];
    indi=return_indi(glind,D,SEl);
    [C,Indice_all]=local_adj(indi,D,glind,C,SEl,Z);
%     Cnew=C(Indice_all,Indice_all);
%     Dnew=D;
%     while (sum(sum(Cnew))==0)&&(size(Dnew,1)>1)
%        
%        for ii=1:(size(Indice_all,2)-1)
%             Dnew(Dnew(:,1)==Indice_all(1,ii),:)=[];
%        end
%         indi=return_indi(glind,Dnew,SEl);
%         [C,Indice_all]=local_adj(indi,D,glind,C,SEl,Z);
%     end
   
    
end
end