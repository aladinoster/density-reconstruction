%% Plot results
Main
%%
close all
f = figure(1)
f.Position(4) = f.Position(4) + 150;
n       = 150;
ts      = Parameters.Sampling_Time;
tvec    = linspace(1,n*ts/3600,n);
r       = 1:size(err_Rho,1);
ax(1)   = subplot(2,1,1);
imagesc(abs(err_Rho(:,1:n)));
%colormap(retrieve_color_heatmap);
xlabel('Samples (k)','interpreter','latex','fontsize',16)
ylabel('Road ID','interpreter','latex','fontsize',16)
title('Error Density - $|\hat{\rho}_i(k)-\rho_i(k)|$','interpreter','latex','fontsize',16)
colormap(flipud(retrieve_color_heatmap))
colorbar
ax(2)   = subplot(2,1,2);
imagesc(abs(err_F(:,1:n)));
xlabel('Samples(k)','interpreter','latex','fontsize',16)
ylabel('Road ID','interpreter','latex','fontsize',16)
title('Error Outflow -  $|\hat{\varphi}^{out}_i(k)-\varphi^{out}_i(k)|$','interpreter','latex','fontsize',16)
colormap(flipud(retrieve_color_heatmap))
colorbar;
matlab2tikz('errorDensity_&_Flow.tex','standalone',true)
