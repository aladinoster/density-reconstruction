function [Graph_Inter,Graph_Roads,R_Split]=ManhattanGridConstruction(...
    X_Intersections,Y_Intersections)

Inter_X=1:X_Intersections+2;
Inter_Y=1:Y_Intersections+2;

[Inter_X,Inter_Y]=meshgrid(Inter_X,Inter_Y);
Inter_Adjacency=zeros(numel(Inter_X));
N=size(Inter_Adjacency,1);

Tail=[];
Head=[];

% Going Down

[row_Tail,col_Tail]=meshgrid(1:Y_Intersections+1,2:2:X_Intersections+1);
[row_Head,col_Head]=meshgrid(2:Y_Intersections+2,2:2:X_Intersections+1);
Tail= [Tail arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Tail(:),col_Tail(:))'];
Head= [Head arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Head(:),col_Head(:))'];

% Going Up
[row_Head,col_Head]=meshgrid(1:Y_Intersections+1,3:2:X_Intersections+1);
[row_Tail,col_Tail]=meshgrid(2:Y_Intersections+2,3:2:X_Intersections+1);
Tail= [Tail arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Tail(:),col_Tail(:))'];
Head= [Head arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Head(:),col_Head(:))'];

% Going Right
[row_Head,col_Head]=meshgrid(2:2:Y_Intersections+1,2:X_Intersections+2);
[row_Tail,col_Tail]=meshgrid(2:2:Y_Intersections+1,1:X_Intersections+1);
Tail= [Tail arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Tail(:),col_Tail(:))'];
Head= [Head arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Head(:),col_Head(:))'];

% Going Left
[row_Head,col_Head]=meshgrid(3:2:Y_Intersections+1,1:X_Intersections+1);
[row_Tail,col_Tail]=meshgrid(3:2:Y_Intersections+1,2:X_Intersections+2);
Tail= [Tail arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Tail(:),col_Tail(:))'];
Head= [Head arrayfun(@(x,y) sub2ind(size(Inter_X),x,y),row_Head(:),col_Head(:))'];

Inter_Adjacency(sub2ind(size(Inter_Adjacency),Tail(:),Head(:)))=1;

Inter_Table_Nodes=table((1:numel(Inter_X))',Inter_X(:),Inter_Y(:),...
    'VariableNames',{'InterID','XData','YData'});

% Inter_Table_Edges=table((1:height(G.Edges))','VariableNames',{'RoadID'});

Graph_Inter=digraph(logical(Inter_Adjacency));
Graph_Inter.Nodes=Inter_Table_Nodes;
% plot(Graph_Inter,'XData',Graph_Inter.Nodes.XData,'YData',Graph_Inter.Nodes.YData)
% axis ij
% axis equal

%%

Edge_X=zeros(1,numedges(Graph_Inter));
Edge_Y=Edge_X;

R_Split=zeros(numedges(Graph_Inter));

for ThisEdge=1:numedges(Graph_Inter)
    EndNodes=Graph_Inter.Edges.EndNodes(ThisEdge,:);
    Edge_X(ThisEdge)=mean(Graph_Inter.Nodes.XData(EndNodes));
    Edge_Y(ThisEdge)=mean(Graph_Inter.Nodes.YData(EndNodes));
    for NextNode=successors(Graph_Inter,EndNodes(2))'
        NextEdge=findedge(Graph_Inter,EndNodes(2),NextNode);
        auxx=mean(Graph_Inter.Nodes.XData([EndNodes(2),NextNode]));
        auxy=mean(Graph_Inter.Nodes.YData([EndNodes(2),NextNode]));
        
        if sum([auxx auxy]==[Edge_X(ThisEdge) Edge_Y(ThisEdge)])==1
            R_Split(ThisEdge,NextEdge)=0.7;
        else
            R_Split(ThisEdge,NextEdge)=0.3;
        end
    end
end

Graph_Roads=digraph(R_Split);
Graph_Roads.Nodes.RoadID=(1:numnodes(Graph_Roads))';
Graph_Roads.Nodes.XData=Edge_X';
Graph_Roads.Nodes.YData=Edge_Y';

Graph_Roads.Nodes=[Graph_Roads.Nodes table(Graph_Inter.Edges.EndNodes,'VariableNames',{'Intersections'})];

% hold on
% plot(Graph_Roads,'XData',Graph_Roads.Nodes.XData,'YData',Graph_Roads.Nodes.YData)
% hold off

end

