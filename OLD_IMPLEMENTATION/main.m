clc;
clear all;
close all

figsize=[0,0,400,800];

kmax = 1.0;
jmax = 1.0;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;

xT = 10;
yT = 0;
thetaT=0;
kappaT=0;

Dub = Dubber(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  ['R','S','L'],jmax,kmax,1.0);

Dub2 = Dubber(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  ['L','S','R'],jmax,kmax,1.0);

Dub3 = Dubber(...
  [x0,y0,theta0,kappa0+0.05],...
  [xT,yT,thetaT,kappaT],...
  ['S','R','S'],jmax,kmax,1.0);

figure()

Dub.plot();
Dub2.plot();
Dub3.plot()