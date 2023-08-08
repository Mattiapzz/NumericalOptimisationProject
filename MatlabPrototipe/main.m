%% TEST 0 Dubinoid
clc;
clear all;
close all;
setup();
%%

fprintf("TEST - 0\n")
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
yT     = 10;
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
DubCol.plot_best();