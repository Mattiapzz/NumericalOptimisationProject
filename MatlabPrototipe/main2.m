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

xT = 20;
yT = 10;
thetaT=0.5;
kappaT=0.1;

Dub = Dubber(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  ['R','S','L'],jmax,kmax,1.0);

figure()

Dub.plot();

Dub.cost(1.0,1.0,1.0)

fun = @(x)Dub.cost(x(1),x(2),x(3));
z0 = [8.0,8.0,8.0];
z = fminsearch(fun,z0)

figure()

Dub.plot();

%%

DubCol = DubberCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,1.0);


figure()
hold on
DubCol.D1.plot();
DubCol.D2.plot();
DubCol.D3.plot();
DubCol.D4.plot();
DubCol.D5.plot();
DubCol.D6.plot();
DubCol.D7.plot();
DubCol.D8.plot();
DubCol.D9.plot();
DubCol.D10.plot();
DubCol.D11.plot();
DubCol.D12.plot();

DubCol.optimise();

figure()
hold on
DubCol.D1.plot();
DubCol.D2.plot();
DubCol.D3.plot();
DubCol.D4.plot();
DubCol.D5.plot();
DubCol.D6.plot();
DubCol.D7.plot();
DubCol.D8.plot();
DubCol.D9.plot();
DubCol.D10.plot();
DubCol.D11.plot();
DubCol.D12.plot();


