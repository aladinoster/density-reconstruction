Road_X=Graph_Roads.Nodes.XData;
Road_Y=Graph_Roads.Nodes.YData;

Inter_X=Graph_Inter.Nodes.XData;
Inter_Y=Graph_Inter.Nodes.YData;

N=numnodes(Graph_Roads);
J=numnodes(Graph_Inter);

x=sort(unique(Road_X));
y=sort(unique(Road_Y));
[X,Y]=meshgrid(x,y);
A=zeros(size(X));
S=A;


C=imagesc(x,y,zeros(size(A)));
hold on
% C.FaceColor='texturemap';
L=plot(Graph_Inter,'XData',Graph_Inter.Nodes.XData,'YData',Graph_Inter.Nodes.YData);
L.NodeColor='w';
L.EdgeColor='k';
L.LineWidth=1.5;
L.EdgeAlpha=1;
L.MarkerSize=3;
L.ArrowSize=6;
view(0,90)
shading interp
axis equal
colormap(flipud(retrieve_color_heatmap))
hold off

caxis([0 Parameters.Max_Density])
Variable=Rho;

for t=1:size(Variable,2)
    hold off
for cont=1:N
    
    A(((Road_X(cont)==X)&(Road_Y(cont)==Y)))=Variable(cont,t);
    S(((Road_X(cont)==X)&(Road_Y(cont)==Y)))=1;
end

for cont=1:J
    aux=findedge(Graph_Inter,cont,successors(Graph_Inter,cont));
    aux=[aux;findedge(Graph_Inter,predecessors(Graph_Inter,cont),cont)];
    aux=mean(Variable(aux,t));
    A(((Inter_X(cont)==X)&(Inter_Y(cont)==Y)))=aux;
    S(((Inter_X(cont)==X)&(Inter_Y(cont)==Y)))=1;
end

for cont=(find(S==0))'
    [i,j]=ind2sub(size(A),cont);
    
    i2=[repmat(i-1,3,1);i;i;repmat(i+1,3,1)];
    j2=[j-1:j+1,j-1,j+1,j-1:j+1]';
    
    j2=j2(i2>0);
    i2=i2(i2>0);
    j2=j2(i2<size(A,1)+1);
    i2=i2(i2<size(A,1)+1);
    
    i2=i2(j2>0);
    j2=j2(j2>0);
    i2=i2(j2<size(A,2)+1);
    j2=j2(j2<size(A,2)+1);
    
    aux=sub2ind(size(A),i2,j2);
    A(i,j)=mean(A(aux));
    
end

C.CData=A;

pause(0.1)
end