function [DaT,Y]=Attr_C(latlim,lonlim,C,AData,year)
A=AData;
At1=A(A.year==year,[3 4 8 25 26 27]);
SAt1=At1;
SAt1=table2array(SAt1);
SAt1=SAt1((SAt1(:,1)>=lonlim(1,1)) & (SAt1(:,1)<=lonlim(1,2)),:);
SAt1=SAt1((SAt1(:,2)>=latlim(1,1)) & (SAt1(:,2)<=latlim(1,2)),:);


C=C+eye(size(C));
in={};ind_nod=[];
for i=1:size(C,1)
    in{i}=['p',int2str(i)];
    ind_nod=[ind_nod;i];
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

In_deg = centrality(G1,'indegree','Importance',G1.Edges.Weight);
Out_deg = centrality(G1,'outdegree','Importance',G1.Edges.Weight);
In_clos= centrality(G1,'incloseness');%,'Cost',G1.Edges.Weight);
Out_clos= centrality(G1,'outcloseness');%,'Cost',G1.Edges.Weight);
betweness= centrality(G1,'betweenness');%,'Cost',G1.Edges.Weight);
page_rk=centrality(G1,'pagerank','Importance',G1.Edges.Weight);
hub=centrality(G1,'hubs','Importance',G1.Edges.Weight);

Out_fact=[In_deg Out_deg In_clos Out_clos betweness page_rk hub];
DaT=[Out_fact SAt1(:,3)];
Y=SAt1(:,3);
Y1=Y;
[i1,~]=find(Y1==1);
%Y1(i1(randi(size(i1,1),round(size(i1,1)/2),1)))=0;
Y1(i1(randi(size(i1,1),round(0.9*size(i1,1)),1)))=0;
DaT=[Out_fact Y1 Y];
DaT = array2table(DaT,...
     'VariableNames',{'indegree','outdegree','incloseness','outcloseness','betweenness','pagerank','hubs','start_cases','cases'});
 end
