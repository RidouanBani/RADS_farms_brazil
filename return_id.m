function A=return_id(I1,I2)
a=(I2(1,2)-I1(1,2))/(I2(1,1)-I1(1,1));
b=I1(1,2)-a*I1(1,1);
mii=min(I1(1,1),I2(1,1));
mai=max(I1(1,1),I2(1,1));
A=[];
if mii<mai
for i=mii:mai
    A=[A;[i round(a*i+b)]];
end
else
    A=I1;
end