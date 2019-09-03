% calculate the weight of each edges depending on distance
D=[];
for i=1:(size(SAt1,1)-1)
    for j=(i+1):size(SAt1,1)
        
        D(i,j)=1./deg2km(sqrt((SAt1(i,1:2)-SAt1(j,1:2))*(SAt1(i,1:2)-SAt1(j,1:2))'));
        D(j,i)=D(i,j);
    end
end

%%
C=Ctrain;
C=C+eye(size(C));
in={};
for i=1:size(C,1)
    in{i}=['p',int2str(i)];
end

G=digraph(C,in);
[s,t]=findedge(G);
D=[];
for i=1:(size(SAt1,1)-1)
    for j=(i+1):size(SAt1,1)
        
        D(i,j)=1./(1+deg2km(sqrt((SAt1(i,1:2)-SAt1(j,1:2))*(SAt1(i,1:2)-SAt1(j,1:2))')));
        D(j,i)=D(i,j);
    end
end

GEdgesWeight=[];
for i=1:size(s,1)
    GEdgesWeight=[GEdgesWeight D(s(i,1),t(i,1))];
end
G1=digraph(s,t,GEdgesWeight);

Out_fact=[];

In_deg = centrality(G1,'indegree','Importance',G.Edges.Weight);
Out_deg = centrality(G1,'indegree','Importance',G.Edges.Weight);
In_clos= centrality(G1,'incloseness','Cost',G.Edges.Weight);
Out_clos= centrality(G1,'outcloseness','Cost',G.Edges.Weight);
betweness= centrality(G1,'betweenness','Cost',G.Edges.Weight);
page_rk=centrality(G1,'pagerank','Importance',G.Edges.Weight);
hub=centrality(G1,'hubs','Importance',G.Edges.Weight);

Out_fact=[In_deg Out_deg In_clos Out_clos betweness page_rk hub];

%%

p=plot(G1);

p = plot(G,'Layout','force','EdgeAlpha',0.005,'NodeColor','r');
%%
deg_ranks = centrality(G,'outdegree','Importance',G.Edges.Weight);
edges = linspace(min(deg_ranks),max(deg_ranks),7);
bins = discretize(deg_ranks,edges);
p = plot(G,'Layout','force','EdgeAlpha',0.005,'NodeColor','r');
p.MarkerSize = bins;

[s,t]=findegde(G);
GEdgesWeight=[];
for i=1:size(s,1)
    GEdgesWeight=[GEdgesWeight D(s(i,1),t(i,1))];
end
G1=digraph(s,t,GEdgesWeight);

p = plot(G1,'MarkerSize',5);

ucc = centrality(G1,'betweenness');
p.NodeCData = ucc;
colormap jet
colorbar
%%
C1=C+eye(size(C));
% adjacency matrix
A=C1;
% setup degree vector
D1=sum(A);
% graph Laplacian
L=diag(D1)-A;
% normalized adjacency matrix
An=diag(1./sqrt(D1))*A*diag(1./sqrt(D1));
% normalized graph Laplacian
Ln=eye(length(An))-An;
%% Graph spectrum
[eV,eD]=eig(Ln);
 figure(1);
 plot(diag(eD));
 xlabel('index');
 ylabel('eigenvalue');
%% Get multiple clusters
 CONST_K=10; 
 V=eV(:,2:CONST_K+1);
 % normalize (according to Ng, Jordan, Weiss 2002)
 V=V./repmat(sqrt(sum(V.^2,2)),[1 CONST_K]); 
 % number of cluster
 CONST_CLUSTERS=7;
CONST_MRKS={'ro','bo','go','kp','co','mo','yo'};
[idx,centroids]=kmeans(V,CONST_CLUSTERS,'replicates',20);

%%
for i=1:size(SAt1,1)
    scatter(SAt1(i,1),SAt1(i,2),10)
    hold on
end
%%
latlimtrain =[-30.7 -29]; %[ -34  -27];
lonlimtrain =[-53 -50]; %[-58 -49];
cd gt30w060s10_dem
scalefactor = 1;
[Z,refvec] = gtopo30('W060S10',scalefactor,latlimtrain,lonlimtrain);
cd ..
geoshow(Z,refvec,'DisplayType','texturemap');
view(3)
axis normal
tightmap
%%
[lon,lat] = meshgrid(linspace(lonlim(1,1),lonlim(1,2),size(Z,2)),linspace(latlim(1,1),latlim(1,2),size(Z,1)));
figure
usamap(latlimtrain, lonlimtrain)
geoshow(lat,lon,Z-1,'DisplayType','surface')
hold on
%worldmap(latlimtrain,lonlimtrain)
scatterm(SAt1(:,2),SAt1(:,1),30,ucc,'filled')
scaleruler
set(gca,'Visible','off')
hold on 
demcmap(Z)
daspectm('m',1)
view(3)

