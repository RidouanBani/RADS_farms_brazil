
clear
%Model and spatial performance
latlimtrain =[-30.7 -29]; %[ -34  -27];
 lonlimtrain =[-53 -50]; %[-58 -49];
latlimtest =[ -29.5  -28];
lonlimtest =[-56.2 -54.5];
year1=2015;
year2=2016; 
% year2=2007;

AData=readtable('aie_utm4.csv');

% % read the elevation
cd gt30w060s10_dem
scalefactor = 1;
[Ztrain,~] = gtopo30('W060S10',scalefactor,latlimtrain,lonlimtrain);
cd ..

% Extract the adjacency matrix between farm depending on elevation
Ctrain=Adj_El_M(latlimtrain,lonlimtrain,AData,Ztrain,year1);

% Calculate important attrebutes of Adjacency Matrix
[DaTtrain, ~]=Attr_C(latlimtrain,lonlimtrain,Ctrain,AData,year1);



case_test='spatial';
%case_test='temporal';


[Yfit, Yreal]=read_ma(latlimtrain,lonlimtrain,latlimtest,lonlimtest,year1,year2,case_test);


% Model and temporal performance we use the 

% 
%  latlim =[-30.7 -29]; %[ -34  -27]; year=2015;
%   lonlim =[-53 -50];
%   Z=Ztrain;
%   C=Ctrain; A=AData;