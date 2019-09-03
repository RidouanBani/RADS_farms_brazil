function indi=return_indi(glind,D,SEl)

    D1=(D(:,5:6)-SEl(SEl(:,1)==glind,5:6)).^2;
    D1=sqrt(D1(:,1)+D1(:,2));
    if deg2km(min(min(D1)))>=10
        [indi,~]=find(D1==min(min(D1)));
    else
        [indi,~]=find(D1<=km2deg(10));
    end
end