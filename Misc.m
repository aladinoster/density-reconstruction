close all
TextProp={'Interpreter','FontSize'};
TextVal1={'latex',20};
TextVal2={'latex',18};
Figure=figure(1);
Figure.Position=[280   370   800   380];
Figure.Units='inches';
Figure.PaperUnits='inches';
Figure.PaperPosition=Figure.Position;

% Video=VideoWriter('Video.avi');
% Video.FrameRate=5;
% open(Video)
for time=size(Rho,2)
    A1=subplot(2,1,1);
    Plot=bar(1000*[Rho(:,time) eRho(:,time)]);
    xlim([0,41])
    Plot(1).FaceColor=[216 179 101]/255;
    Plot(2).FaceColor=[90 180 172]/255;
    set(gca,'TickLabelInterpreter','latex','FontSize',14)
%     xlabel('Road ID',TextProp,TextVal2);
    ylabel('Density (veh/km)',TextProp,TextVal2)
    title('\textbf{Estimation Results - Density}',TextProp,TextVal1)
    L1=legend({'Simulated Data','Estimated Results'});%,TextProp,TextVal2)
    set(L1,'Location','eastoutside','FontSize',14,'Interpreter','latex')
    L1.Position(1)=0.8;
    A1.Position([1,3])=[0.07 0.7];
    A1.YLim=[0 125];
    
    
    A2=subplot(2,1,2);
    Plot2=bar(3600*[F_Out(:,time) eFlow(:,time)]);
    xlim([0,41])
    Plot2(1).FaceColor=[239 138 98]/255;
    Plot2(2).FaceColor=[153 153 153]/255;
    set(gca,'TickLabelInterpreter','latex','FontSize',14)
    xlabel('Road ID',TextProp,TextVal2);
    ylabel('Flow (veh/h)',TextProp,TextVal2)
    title('\textbf{Estimation Results - Flow}',TextProp,TextVal1)
    L2=legend({'Simulated Data','Estimated Results'});%,TextProp,TextVal2)
    set(L2,'Location','eastoutside','FontSize',14,'Interpreter','latex')
    L2.Position(1)=0.8;
    A2.Position([1,3])=[0.07 0.7];
    A2.YLim=[0 1980];
    pause(0.1)
    
%     print('Figure','-dpng','-r300')
%     frame=imread('Figure.png');
%     writeVideo(Video,frame);
end
%print('/Users/andresladino/Dropbox/PhD/Thesis/LaTeX Source/gfx/Chapter06/DensityFlowEquilibria','-dpng','-r300')
%print('/Users/andresladino/Dropbox/PhD/Publications/ECC18/figures/DensityFlowEquilibria','-dpng','-r300')

% close(Video)

%
p = figure(2);
%p.Position=[280   370   800   380];
p.Position=[280   370   800   580];
p.Units='inches';
p.PaperUnits='inches';
p.PaperPosition=p.Position;
TextProp = {'interpreter','FontSize'};
TextVal1 = {'latex',20};
TextVal2 = {'latex',18};
N = 150;
subplot(2,2,1)
set(gca,'TickLabelInterpreter','latex','FontSize',14);
imagesc((0:N)*Parameters.Sampling_Time/60,1:40,60*eFlow(:,1:N))
colormap(retrieve_color_heatmap)
xlabel('Time [min]',TextProp,TextVal2)
ylabel('RoadID',TextProp,TextVal2)
title('Estimated Flow',TextProp,TextVal1)
colorbar
subplot(2,2,2)
set(gca,'TickLabelInterpreter','latex','FontSize',14);
imagesc((0:N)*Parameters.Sampling_Time/60,1:40,60*F_Out(:,1:N))
xlabel('Time [min] ',TextProp,TextVal2)
ylabel('RoadID',TextProp,TextVal2)
title('Flow',TextProp,TextVal1)
colormap(retrieve_color_heatmap)
colorbar
subplot(2,2,[3 4])
set(gca,'TickLabelInterpreter','latex','FontSize',14);
plot((0:(N-1))*Parameters.Sampling_Time/60,mean(abs(3600*err_F(:,1:N))),'.','LineWidth',2);
% %[hAx,H1,H2] = plotyy((0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(3600*err_F(:,1:N))),(0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(3600*err_F(:,1:N))./abs(3600*F_Out(:,1:N))));
% %[hAx,H1,H2] = plotyy((0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(3600*err_F(:,1:N))),(0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(3600*err_F(:,1:N)))./mean(abs(3600*F_Out(:,1:N))));
% %set(hAx(1),'YLabel','[Veh/Km]')
% %set(hAx(1),TextProp,TextVal2)
% %ylabel(hAx(1),'[Veh/Km]',TextProp,TextVal2)
% %ylabel(hAx(2),'[\%]',TextProp,TextVal2)
xlabel('Time [min]',TextProp,TextVal2)
ylabel('[veh/h]',TextProp,TextVal2)
title('$AE_{\varphi^{{out}}}$',TextProp,TextVal1)
grid on
print('/Users/andresladino/Dropbox/PhD/Thesis/LaTeX Source/gfx/Chapter06/DynamicFlow','-dpng','-r300')
%print('/Users/andresladino/Dropbox/PhD/Publications/ECC18/figures/DynamicFlow','-dpng','-r300')

p = figure(3);
%p.Position=[280   370   800   380];
p.Position=[280   370   800   580];
p.Units='inches';
p.PaperUnits='inches';
p.PaperPosition=p.Position;
TextProp = {'interpreter','FontSize'};
TextVal1 = {'latex',20};
TextVal2 = {'latex',18};
N = 200;
subplot(2,2,1)
set(gca,'TickLabelInterpreter','latex','FontSize',14);
imagesc((0:N)*Parameters.Sampling_Time/60,1:40,1000*eRho(:,1:N))
xlabel('Time [min]',TextProp,TextVal2)
ylabel('RoadID',TextProp,TextVal2)
title('Estimated Density',TextProp,TextVal1)
colormap(flipud(retrieve_color_heatmap))
colorbar
subplot(2,2,2)
set(gca,'TickLabelInterpreter','latex','FontSize',14);
imagesc((0:N)*Parameters.Sampling_Time/60,1:40,1000*Rho(:,1:N))
xlabel('Time [min]',TextProp,TextVal2)
ylabel('RoadID',TextProp,TextVal2)
title('Density',TextProp,TextVal1)
colormap(flipud(retrieve_color_heatmap))
colorbar
subplot(2,2,[3 4])
set(gca,'TickLabelInterpreter','latex','FontSize',14);
plot((0:(N-1))*Parameters.Sampling_Time/60,mean(abs(1000*err_Rho(:,1:N))),'.','LineWidth',2);
% %[hAx,H1,H2] = plotyy((0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(1000*err_Rho(:,1:N))),(0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(1000*err_Rho(:,1:N))./abs(1000*Rho(:,1:N))));
% %[hAx,H1,H2] = plotyy((0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(1000*err_Rho(:,1:N))),(0:(N-1))*Parameters.Sampling_Time/3600,100*mean(abs(1000*err_Rho(:,1:N)))./mean(abs(1000*Rho(:,1:N))));
% %set(hAx(1),'YLabel','[Veh/Km]')
% %set(hAx(1),TextProp,TextVal2)
% %ylabel(hAx(1),'[Veh/Km]',TextProp,TextVal2)
% %ylabel(hAx(2),'[\%]',TextProp,TextVal2)
xlabel('Time [min]',TextProp,TextVal2)
ylabel('[veh/Km]',TextProp,TextVal2)
title('$AE_\rho$',TextProp,TextVal1)
grid on
print('/Users/andresladino/Dropbox/PhD/Thesis/LaTeX Source/gfx/Chapter06/DynamicDensity','-dpng','-r300')
% print('/Users/andresladino/Dropbox/PhD/Publications/ECC18/figures/DynamicDensity','-dpng','-r300')


p = figure(4);
p.Position = [280   370   800   580];
set(gca,'TickLabelInterpreter','latex','FontSize',14);
plot((0:(N-1))*Parameters.Sampling_Time/60,1000*[mean(abs(err_Rho(:,1:N)),1)' mean(abs(err_Rho2(:,1:N)),1)' mean(abs(err_Rho3(:,1:N)),1)' mean(abs(err_Rho4(:,1:N)),1)'],'-','LineWidth',2)
xlabel('Time [min]',TextProp,TextVal2)
ylabel('[veh/Km]',TextProp,TextVal2)
title('$AE_\rho$',TextProp,TextVal1)
L1=legend({'$\Delta R = 0$','$\Delta R = 0.03$','$\eta = 0.1$','$\Delta R = 0.03,\eta = 0.001$'});%,TextProp,TextVal2)
set(L1,'Location','northeast','FontSize',14,'Interpreter','latex')
grid on
print('/Users/andresladino/Dropbox/PhD/Thesis/LaTeX Source/gfx/Chapter06/NoisyDensity','-dpng','-r300')

p = figure(5);
p.Position = [280   370   800   580];
set(gca,'TickLabelInterpreter','latex','FontSize',14);
plot((0:(N-1))*Parameters.Sampling_Time/60,3600*[mean(abs(err_F(:,1:N)),1)' mean(abs(err_F2(:,1:N)),1)' mean(abs(err_F3(:,1:N)),1)' mean(abs(err_F4(:,1:N)),1)'],'-','LineWidth',2)
xlabel('Time [min]',TextProp,TextVal2)
ylabel('[veh/h]',TextProp,TextVal2)
title('$AE_{\varphi^{{out}}}$',TextProp,TextVal1)
L1=legend({'$\Delta R = 0$','$\Delta R = 0.03$','$\eta = 0.1$','$\Delta R = 0.03,\eta = 0.001$'});%,TextProp,TextVal2)
set(L1,'Location','northeast','FontSize',14,'Interpreter','latex')
grid on
print('/Users/andresladino/Dropbox/PhD/Thesis/LaTeX Source/gfx/Chapter06/NoisyFlow','-dpng','-r300')

err_Rhos = mean(1000*[mean(abs(err_Rho(:,N-20:N)),1)' mean(abs(err_Rho2(:,N-20:N)),1)' mean(abs(err_Rho3(:,N-20:N)),1)' mean(abs(err_Rho4(:,N-20:N)),1)'],1);

err_Flows = mean(3600*[mean(abs(err_F(:,N-20:N)),1)' mean(abs(err_F2(:,N-20:N)),1)' mean(abs(err_F3(:,N-20:N)),1)' mean(abs(err_F4(:,N-20:N)),1)'],1);



