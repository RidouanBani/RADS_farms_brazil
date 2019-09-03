function S=locate_region(latlim,lonlim,SData)
S2=SData;
ind2=[]; 
for j=1:size(S2,1)
        if (max(S2(j).BoundingBox(:,1)) <=lonlim(1,1)) || (min(S2(j).BoundingBox(:,1)) >=lonlim(1,2)) || (min(S2(j).BoundingBox(:,2)) >=latlim(1,1)) || (max(S2(j).BoundingBox(:,2)) <=latlim(1,2))  
            ind2=[ind2 j];
        end
end
S2(ind2)=[];
S=S2;
end