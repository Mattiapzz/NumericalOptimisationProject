%% TEST 0 Dubinoid
clc;
clear all;
close all;
setup();
%%

fprintf("TEST - 0\n")
%%

kmax = 0.15;
jmax = 0.08;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;


for i = 0:5:40
  xT = 40;
  yT = i;
  thetaT=0;
  kappaT=0;

  DubCol = DubinoidCollector(...
    [x0,y0,theta0,kappa0],...
    [xT,yT,thetaT,kappaT],...
    jmax,kmax,1.0);


  DubCol.optimize()

  DubCol.plot_best();
end

fprintf("Final y span DONE\n")


%%

kmax = 0.15;
jmax = 0.08;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;


for i = 0:0.1:1
  xT = 40;
  yT = 20;
  thetaT=i*pi/2;
  kappaT=0;

  DubCol = DubinoidCollector(...
    [x0,y0,theta0,kappa0],...
    [xT,yT,thetaT,kappaT],...
    jmax,kmax,1.0);


  DubCol.optimize()

  DubCol.plot_best();
end

fprintf("Final heading span DONE\n")

%%

kmax = 0.2;
jmax = 0.2;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;


for i = 0:0.1:1
  xT = 40;
  yT = 20;
  thetaT=0;
  kappaT=i*kmax;

  DubCol = DubinoidCollector(...
    [x0,y0,theta0,kappa0],...
    [xT,yT,thetaT,kappaT],...
    jmax,kmax,1.0);


  DubCol.optimize()

  DubCol.plot_best();
end

fprintf("Final curvature span DONE\n")

%%

kmax = 0.4;
jmax = 0.1;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;

xT = 0;
yT = -10;
thetaT=pi;
kappaT=0;

DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,1.0);


DubCol.optimize()

DubCol.plot_best();

fprintf("Exotic example DONE\n")


%%

kmax = 0.15;
jmax = 0.5;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;

xT = -2;
yT = -10;
thetaT=pi+pi/18;
kappaT=0.01;

DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,1.0);


DubCol.optimize()

DubCol.plot_best();

fprintf("Exotic example 2 DONE\n")


%%

kmax = 0.16;
jmax = 0.5;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;

xT = 6.45;
yT = -6.45;
thetaT=-pi/2;
kappaT=0;

DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,1.0);


DubCol.optimize()

DubCol.plot_best();

fprintf("Exotic example 2 DONE\n")

%%
kmax = 0.2;
jmax = 0.5;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=-0.2;

xT = 5.0;
yT = -5.0;
thetaT=-pi/2;
kappaT=-0.2;

DubCol = DubinoidCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,1.0);


DubCol.optimize()

DubCol.plot_best();

fprintf("Exotic example 2 DONE\n")