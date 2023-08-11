%% TEST 0 Dubinoid
clc;
clear all;
close all;
addpath('utils');
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
DubCol = DuboidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
DubCol.plot_best();

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
DubCol = DuboidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
DubCol.plot_best();

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
xT     = -5.2;
yT     = -1.333;
thetaT = -0*pi+0.02;
kappaT = 0-0.03;
% initialise the collector
DubCol = DuboidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
DubCol.plot_best();

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
xT     = -5.2;
yT     = -1.333;
thetaT = -2*pi+0.02;
kappaT = 0-0.03;
% initialise the collector
DubCol = DuboidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
DubCol.plot_best();



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
xT     = 5;
yT     = 5;
thetaT = 0;
kappaT = 0;
% initialise the collector
DubCol = DuboidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,v);
% find the optimal junctions
DubCol.optimize()
% plot the optimal path
DubCol.plot_best();

