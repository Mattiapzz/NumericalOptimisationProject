%% TEST 0 Dubinoid
clc;
clear all;
close all;
setup();
%%

fprintf("TEST - 0\n")
%%

kmax   = 0.15;
jmax   = 0.1;
v      = 1.0;
% initial values
x0     = 0;
y0     = 0;
theta0 = 0;
kappa0 = 0;
% final values
xT     = 40;
yT     = 20;
thetaT = 0;
kappaT = 0;
% initialise the collector
DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
fh = DubCol.plot_best();

matlab2tikz('figurehandle',fh,'filename','Duboids0.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')

%%

kmax   = 0.15;
jmax   = 0.08;
v      = 1.0;
% initial values
x0     = 0;
y0     = 0;
theta0 = 0;
kappa0 = 0;
% final values
xT     = 40;
yT     = 0;
thetaT = 0;
kappaT = 0;
% initialise the collector
DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
fh = DubCol.plot_best();

matlab2tikz('figurehandle',fh,'filename','Duboids1.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')

%%

kmax   = 0.2;
jmax   = 0.2;
v      = 1.0;
% initial values
x0     = 0;
y0     = 0;
theta0 = 0;
kappa0 = 0;
% final values
xT     = -1.0;
yT     = 0;
thetaT = 0;
kappaT = 0;
% initialise the collector
DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
fh = DubCol.plot_best();

matlab2tikz('figurehandle',fh,'filename','Duboids2.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')

%%

kmax   = 0.2;
jmax   = 0.5;
v      = 1.0;
% initial values
x0     = 0;
y0     = 0;
theta0 = 0;
kappa0 = 0;
% final values
xT     = 0;
yT     = 0;
thetaT = -pi;
kappaT = 0;
% initialise the collector
DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
fh = DubCol.plot_best();

matlab2tikz('figurehandle',fh,'filename','Duboids3.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')


%%

kmax   = 0.5;
jmax   = 0.5;
v      = 1.0;
% initial values
x0     = 0;
y0     = 0;
theta0 = 0;
kappa0 = 0;
% final values
xT     = 0.0;
yT     = 0.0;
thetaT = 3*pi/2;
kappaT = 0;
% initialise the collector
DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
fh = DubCol.plot_best();

matlab2tikz('figurehandle',fh,'filename','Duboids4.tex' ,...
  'height', '\linewidth', 'width', '\linewidth')
