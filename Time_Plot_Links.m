N=numnodes(Graph_Roads);
J=numnodes(Graph_Inter);

L=plot(Graph_Inter,'XData',Graph_Inter.Nodes.XData,'YData',Graph_Inter.Nodes.YData);
L.NodeColor='k';
L.EdgeColor='k';
L.LineWidth=2;
L.EdgeAlpha=1;
L.MarkerSize=4;
L.ArrowSize=12;
L.NodeLabel={};
L.EdgeLabel=arrayfun(@num2str,1:N,'UniformOutput',0);
axis equal

Variable=Rho;
Max=Parameters.Max_Density;

Color=flipud(retrieve_color_heatmap);
caxis([0,Max])
colormap((Color))
colorbar


C=zeros(N,3);
for t=1:size(Variable,2)
    for cont=1:N
        
        aux=round(63*Variable(cont,t)/Max)+1;
        C(cont,:)=Color(aux,:);
    end
    
    L.EdgeColor=C;
    pause(0.1)
end


