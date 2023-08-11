%% TEST PINS Dubinoid
clc;
clear all;
close all;
setup();
%%
tikz_flag = false;
%%

% bounds
data_DUBOIDS.kmax   = 0.2;
data_DUBOIDS.jmax   = 0.2;
data_DUBOIDS.v      = 1.0;
% initial values
data_DUBOIDS.x0     = 0;
data_DUBOIDS.y0     = 0;
data_DUBOIDS.theta0 = 0;
data_DUBOIDS.kappa0 = 0;
% final values
data_DUBOIDS.xT     = 20;
data_DUBOIDS.yT     = 10;
data_DUBOIDS.thetaT = 0;
data_DUBOIDS.kappaT = 0;

[sol,ocp] = compute_Duboids_PINS(data_DUBOIDS);

ocp.solution('theta');
%%
figure()
fh = gca;

fh = plot_traj_pins(ocp,fh,'-','Color',[30,144,255]./255,'LineWidth',2);
grid on
grid minor
hold on
LStmp = ocp.solution('zeta').*ocp.solution('T');
L = LStmp(end);
title(fh,['PINS Traj.: $L_{tot}$ = ', num2str(L) , ', $k_{max}$ = ',num2str(data_DUBOIDS.kmax),', $J_{max}$ = ',num2str(data_DUBOIDS.jmax)])
plot(fh,data_DUBOIDS.x0, data_DUBOIDS.y0, 'bo','LineWidth',2','MarkerSize',5,'MarkerFaceColor','b');
% plot final point
plot(fh,data_DUBOIDS.xT, data_DUBOIDS.yT, 'bo','LineWidth',2','MarkerSize',5,'MarkerFaceColor','b');
xlabel('$x(m)$');
ylabel('$y(m)$');
if tikz_flag
  matlab2tikz('figurehandle',fh,'filename','PINS_Traj.tex' ,...
    'height', '\linewidth', 'width', '\linewidth')
end

figure()
fh = gca;
plot(fh,ocp.solution('zeta').*ocp.solution('T'),ocp.solution('kappa'),'-','Color',[30,144,255]./255,'LineWidth',2');
grid on
grid minor
hold on
title(fh,'Curvature - PINS')
xlabel('Time(s)');
ylabel('$\kappa(m^{-1})$');
if tikz_flag
  matlab2tikz('figurehandle',fh,'filename','PINS_Kappa.tex' ,...
    'height', '\linewidth', 'width', '\linewidth')
end

figure()
fh = gca;
plot(fh,ocp.solution('zeta').*ocp.solution('T'),ocp.solution('J'),'-','Color',[30,144,255]./255,'LineWidth',2');
grid on
grid minor
hold on
title(fh,'Jerk - PINS')
xlabel('Time(s)');
ylabel('$J(m^{-1}s^{-1})$');
if tikz_flag
  matlab2tikz('figurehandle',fh,'filename','PINS_Jerk.tex' ,...
    'height', '\linewidth', 'width', '\linewidth')
end


