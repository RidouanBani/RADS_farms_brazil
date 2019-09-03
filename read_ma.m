function [Yfit, Yreal]=read_ma(latlimtrain,lonlimtrain,latlimtest,lonlimtest,year1,year2,case_test)
% This function execute all the function available here
% it reads the data including the farm location and elevation
% as well as zoom to specified box with long and lat provided

% read the farms locations
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
        
% The KNN using the att
[trainedClassifier, validationAccuracy] = trainClassifier(DaTtrain);
        
        
switch case_test
    case 'spatial'
        cd gt30w060s10_dem
        
        scalefactor = 1;
        [Ztest,~] = gtopo30('W060S10',scalefactor,latlimtest,lonlimtest);
        cd ..
        Ctest=Adj_El_M(latlimtest,lonlimtest,AData,Ztest,year1);
        [DaTtest, Yreal]=Attr_C(latlimtest,lonlimtest,Ctest,AData,year1);
        
        Yfit = trainedClassifier.predictFcn(DaTtest(:,1:(size(DaTtest,2)-1)));
        
    case 'temporal'
        cd gt30w060s10_dem
        
        scalefactor = 1;
        [Ztest,~] = gtopo30('W060S10',scalefactor,latlimtrain,lonlimtrain);
        cd ..
        
        Ctest=Adj_El_M(latlimtrain,lonlimtrain,AData,Ztest,year2);
        [DaTtest, Yreal]=Attr_C(latlimtrain,lonlimtrain,Ctest,AData,year2);
        
        Yfit = trainedClassifier.predictFcn(DaTtest(:,1:(size(DaTtest,2)-1)));
end

end