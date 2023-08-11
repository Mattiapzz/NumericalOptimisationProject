%% TEST PINS Dubinoid
clc;
clear all;
close all;
setup();
%%
tikz_flag = false;
%%

% bounds
data_DUBOIDS.kmax   = 0.15;
data_DUBOIDS.jmax   = 0.1;
data_DUBOIDS.v      = 1.0;
% initial values
data_DUBOIDS.x0     = 0;
data_DUBOIDS.y0     = 0;
data_DUBOIDS.theta0 = 0;
data_DUBOIDS.kappa0 = 0;
% final values
data_DUBOIDS.xT     = 40;
data_DUBOIDS.yT     = 20;
data_DUBOIDS.thetaT = 0;
data_DUBOIDS.kappaT = 0;

[sol,ocp] = compute_Duboids_PINS(data_DUBOIDS);

% initialise the collector
DubCol = DuboidCollector(...
  [data_DUBOIDS.x0,data_DUBOIDS.y0,data_DUBOIDS.theta0,data_DUBOIDS.kappa0],...
  [data_DUBOIDS.xT,data_DUBOIDS.yT,data_DUBOIDS.thetaT,data_DUBOIDS.kappaT],...
  data_DUBOIDS.jmax,data_DUBOIDS.kmax,data_DUBOIDS.v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path

%%
figure();
fh = gca;

fh = DubCol.plot_best_std(fh,'-.','Color','green','LineWidth',2);

plot_traj_pins(ocp,fh,':','Color',[30,144,255]./255,'LineWidth',2);


grid minor
hold on
LStmp = ocp.solution('zeta').*ocp.solution('T');
L = LStmp(end);
title(fh,['$L_{PINS}$ = ', num2str(L) , ' $L_{DUB}$ = ', num2str(DubCol.L_best) , ', $k_{max}$ = ',num2str(data_DUBOIDS.kmax),', $J_{max}$ = ',num2str(data_DUBOIDS.jmax)])
plot(fh,data_DUBOIDS.x0, data_DUBOIDS.y0, 'bo','LineWidth',2','MarkerSize',5,'MarkerFaceColor','b');
% plot final point
plot(fh,data_DUBOIDS.xT, data_DUBOIDS.yT, 'bo','LineWidth',2','MarkerSize',5,'MarkerFaceColor','b');
xlabel('$x(m)$');
ylabel('$y(m)$');
legend(["Duboids","PINS"],'Location','northwest')
if tikz_flag
matlab2tikz('figurehandle',fh,'filename','COMPARE_Traj_1.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
end


SS = (0:0.01:1)*DubCol.L_best;
figure()
fh = gca;
grid on
grid minor
hold on
plot(SS,DubCol.eval_kappa_best(SS),'-.','Color','green','LineWidth',2');
plot(fh,ocp.solution('zeta').*ocp.solution('T'),ocp.solution('kappa'),':','Color',[30,144,255]./255,'LineWidth',2');
title(fh,'Curvature - PINS')
xlabel('Time(s)');
ylabel('$\kappa(m^{-1})$');
legend(["Duboids","PINS"])
if tikz_flag
matlab2tikz('figurehandle',fh,'filename','COMPARE_Kappa_1.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
end

figure()
fh = gca;
grid on
grid minor
hold on
plot(SS,DubCol.eval_J_best(SS),'-.','Color','green','LineWidth',2');
plot(fh,ocp.solution('zeta').*ocp.solution('T'),ocp.solution('J'),':','Color',[30,144,255]./255,'LineWidth',2');
title(fh,'Curvature - PINS')
xlabel('Time(s)');
ylabel('$\kappa(m^{-1})$');
legend(["Duboids","PINS"])
if tikz_flag
matlab2tikz('figurehandle',fh,'filename','COMPARE_J_1.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
end





%%

data_DUBOIDS.kmax   = 0.4;
data_DUBOIDS.jmax   = 0.5;
data_DUBOIDS.v      = 1.0;
% initial values
data_DUBOIDS.x0     = 0;
data_DUBOIDS.y0     = 0;
data_DUBOIDS.theta0 = 0;
data_DUBOIDS.kappa0 = 0;
% final values
data_DUBOIDS.xT     = -1;
data_DUBOIDS.yT     = 0;
data_DUBOIDS.thetaT = 2*pi;
data_DUBOIDS.kappaT = 0;

[sol,ocp] = compute_Duboids_PINS(data_DUBOIDS);

% initialise the collector
DubCol = DuboidCollector(...
  [data_DUBOIDS.x0,data_DUBOIDS.y0,data_DUBOIDS.theta0,data_DUBOIDS.kappa0],...
  [data_DUBOIDS.xT,data_DUBOIDS.yT,data_DUBOIDS.thetaT,data_DUBOIDS.kappaT],...
  data_DUBOIDS.jmax,data_DUBOIDS.kmax,data_DUBOIDS.v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path


%%
figure();
fh = gca;

fh = DubCol.plot_best_std(fh,'-.','Color','green','LineWidth',2);

plot_traj_pins(ocp,fh,':','Color',[30,144,255]./255,'LineWidth',2);


grid minor
hold on
LStmp = ocp.solution('zeta').*ocp.solution('T');
L = LStmp(end);
title(fh,['$L_{PINS}$ = ', num2str(L) , ' $L_{DUB}$ = ', num2str(DubCol.L_best) , ', $k_{max}$ = ',num2str(data_DUBOIDS.kmax),', $J_{max}$ = ',num2str(data_DUBOIDS.jmax)])
plot(fh,data_DUBOIDS.x0, data_DUBOIDS.y0, 'bo','LineWidth',2','MarkerSize',5,'MarkerFaceColor','b');
% plot final point
plot(fh,data_DUBOIDS.xT, data_DUBOIDS.yT, 'bo','LineWidth',2','MarkerSize',5,'MarkerFaceColor','b');
xlabel('$x(m)$');
ylabel('$y(m)$');
legend(["Duboids","PINS"],'Location','northwest')
if tikz_flag
matlab2tikz('figurehandle',fh,'filename','COMPARE_Traj_2.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
end


SS = (0:0.01:1)*DubCol.L_best;
figure()
fh = gca;
grid on
grid minor
hold on
plot(SS,DubCol.eval_kappa_best(SS),'-.','Color','green','LineWidth',2');
plot(fh,ocp.solution('zeta').*ocp.solution('T'),ocp.solution('kappa'),':','Color',[30,144,255]./255,'LineWidth',2');
title(fh,'Curvature - PINS')
xlabel('Time(s)');
ylabel('$\kappa(m^{-1})$');
legend(["Duboids","PINS"])
if tikz_flag
matlab2tikz('figurehandle',fh,'filename','COMPARE_Kappa_2.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
end

figure()
fh = gca;
grid on
grid minor
hold on
plot(SS,DubCol.eval_J_best(SS),'-.','Color','green','LineWidth',2');
plot(fh,ocp.solution('zeta').*ocp.solution('T'),ocp.solution('J'),':','Color',[30,144,255]./255,'LineWidth',2');
title(fh,'Curvature - PINS')
xlabel('Time(s)');
ylabel('$\kappa(m^{-1})$');
legend(["Duboids","PINS"])
if tikz_flag
matlab2tikz('figurehandle',fh,'filename','COMPARE_J_2.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
end


