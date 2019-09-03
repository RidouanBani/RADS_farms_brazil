D=DaTtrain;


c = cvpartition(size(D,1),'KFold',10);

opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,...
    'AcquisitionFunctionName','expected-improvement-plus');
svmmod = fitcsvm(D(:,4:5),D(:,9),'KernelFunction','rbf',...
    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts)

cl = fitcsvm(D(:,4:5),D(:,9),'KernelFunction','mysigmoid2',...
    'BoxConstraint',Inf,'ClassNames',[0,1]);

% Predict scores over the grid
d = 0.2;
[x1Grid,x2Grid] = meshgrid(min(D.outcloseness):0.00001:max(D.outcloseness),...
    min(D.betweenness):100:max(D.betweenness));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(cl,xGrid);

h = nan(3,1); % Preallocation
figure(3)
h(1:2) = gscatter(D.outcloseness,D.betweenness,D.cases,'rg','+*');
hold on
h(3) = plot(D.outcloseness(svmmod.IsSupportVector,1),...
    D.betweenness(svmmod.IsSupportVector,1),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'-1','+1','Support Vectors'},'Location','Southeast');
axis equal
hold off


% Plot the data and the decision boundary
figure(4);
h(1:2) = gscatter(D.outcloseness,D.betweenness,D.cases,'rb','.');
hold on
ezpolar(@(x)1);
h(3) = plot(D.outcloseness(cl.IsSupportVector,1),D.betweenness(cl.IsSupportVector,1),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'0','+1','Support Vectors'});
%axis equal
hold off