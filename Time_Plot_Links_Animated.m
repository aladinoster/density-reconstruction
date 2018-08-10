N=numnodes(Graph_Roads);
J=numnodes(Graph_Inter);


Max=Parameters.Max_Density*1000;


p = figure(1);
set(0,'defaultfigurecolor',[1 1 1])
p.Position = [440 378 560*2 420*1.8];
subplot(2,2,1);
L=plot(Graph_Inter,'XData',Graph_Inter.Nodes.XData,'YData',Graph_Inter.Nodes.YData);
L.NodeColor='k';
L.EdgeColor='k';
L.LineWidth=2;
L.EdgeAlpha=1;
L.MarkerSize=4;
L.ArrowSize=12;
L.NodeLabel={};
L.EdgeLabel=arrayfun(@num2str,1:N,'UniformOutput',0);
%L.Parent.Position(3)= L.Parent.Position(3)+0.1; 
%L.Parent.Position(4)= L.Parent.Position(4)+0.1; 
axis equal 
ax1 = gca; 
ax1.XTick = [];
ax1.YTick = [];
Color=flipud(retrieve_color_heatmap);
caxis([0,Max])
colormap((Color))
colorbar


subplot(2,2,2);
L2=plot(Graph_Inter,'XData',Graph_Inter.Nodes.XData,'YData',Graph_Inter.Nodes.YData);
L2.NodeColor='k';
L2.EdgeColor='k';
L2.LineWidth=2;
L2.EdgeAlpha=1;
L2.MarkerSize=4;
L2.ArrowSize=12;
L2.NodeLabel={};
L2.EdgeLabel=arrayfun(@num2str,1:N,'UniformOutput',0); 
axis equal 
ax2 = gca;
ax2.XTick = [];
ax2.YTick = [];

Iter = 1:150;
Variable=eRho*1000;
Variable2= Rho*1000;



Color=flipud(retrieve_color_heatmap);
caxis([0,Max])
colormap((Color))
colorbar


C=zeros(N,3);
C2=zeros(N,3);

Nit = 200;

nFrames = Nit;
vidObj = VideoWriter('myPeaks3.avi');
vidObj.Quality = 100;
vidObj.FrameRate = 15;
open(vidObj);


for t=1:Nit
    for cont=1:N        
        aux=round(63*Variable(cont,t)/Max)+1;
        C(cont,:)=Color(aux,:);
        aux2=round(63*Variable2(cont,t)/Max)+1;   
        C2(cont,:)=Color(aux2,:);        
    end
    subplot(2,2,1)
    title('Estimated Density','interpreter','latex','FontSize',16)
    xlabel(['Time [minutes]: ', num2str(double(t)*Parameters.Sampling_Time/60,'%.2f')],'interpreter','latex','FontSize',16)
    axf1 = gca;
%     axf1.Position(3) = axf1.Position(3)+0.05;
%     axf1.Position(4) = axf1.Position(4)+0.05;
    subplot(2,2,2)
    title('Real Density','interpreter','latex','FontSize',16)    
    xlabel(['Time [minutes]: ', num2str(double(t)*Parameters.Sampling_Time/60,'%.2f')],'interpreter','latex','FontSize',16)
    L.EdgeColor=C;
    L2.EdgeColor=C2;
    axf2 = gca;
%     axf2.Position(3) = axf2.Position(3)+0.05;
%     axf2.Position(4) = axf2.Position(4)+0.05;    
    subplot(2,2,[3 4])
    L3 = plot((1:Nit)*Parameters.Sampling_Time/60,mean(abs(err_Rho(:,1:Nit))*1000,1),'b','LineWidth',2);
    xlabel('Time [minutes]','interpreter','latex','FontSize',16)
    ylabel('$AE_\rho$ [veh/km]','interpreter','latex','FontSize',16)
    ax3 = gca;
    ax3.XLim = [0,Nit*Parameters.Sampling_Time/60];
    grid    
    line(t*ones(2,1)*Parameters.Sampling_Time/60,[get(gca,'YLim')]','Color',[0 0 0])
    %pause(0.01)
    %keyboard
    writeVideo(vidObj, getframe(gcf));
end
close(vidObj);




