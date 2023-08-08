clc;
clear all;
close all;
set(     0, 'DefaultFigureWindowStyle'        ,'docked');
set(     0, 'defaultAxesFontSize'             ,20);
set(     0, 'DefaultLegendFontSize'           ,20);
set(     0, 'defaulttextinterpreter'          ,'latex');
set( groot, 'defaultAxesTickLabelInterpreter' ,'latex');
set( groot, 'defaultLegendInterpreter'        ,'latex');

figsize=[0,0,400,800];
%%

kmax = 0.125;
jmax = 0.2;
v = 1.0;
x0 = 0;
y0 = 0;
theta0=0;
kappa0=0;

xT = 20;
yT = 2;
thetaT=0.0;
kappaT=0.0;

% Dub = Dubber(...
%   [x0,y0,theta0,kappa0],...
%   [xT,yT,thetaT,kappaT],...
%   ['R','S','L'],jmax,kmax,1.0);
% 
% 
% Dub.plot();
% 
% Dub.cost(1.0,1.0,1.0)
% 
% fun = @(x)Dub.cost(x(1),x(2),x(3)); %% + 0.001 * (x(1) + x(2) + x(3))^2 + (x(1)-x(3))^2;
% %fun = @(x) (x(1) + x(2) + x(3))^2; 
% z0 = [8.0,8.0,8.0];
% % z = fminsearch(fun,z0)
% 
% lb = [0,0,0];
% ub = [1000,1000,1000];
% 
% A = [];
% b = [];
% Aeq = [];
% beq = [];
% 
% options = optimoptions('fmincon');
% options.OptimalityTolerance = 1e-10;
% options.StepTolerance = 1e-10;
% 
% z = fmincon(fun,z0,A,b,Aeq,beq,lb,ub)
% 
% 
% 
% Dub.plot();




%%

DubCol = DubberCollector(...
  [x0,y0,theta0,kappa0],...
  [xT,yT,thetaT,kappaT],...
  jmax,kmax,1.0);



% DubCol.D1.plot();
DubCol.D1.optimize_L2L4L6(10,10,10)
DubCol.D1.plot();
%
% DubCol.D2.plot();
DubCol.D2.optimize_L2L4L6(10,10,10)
DubCol.D2.plot();
%
% DubCol.D3.plot();
DubCol.D3.optimize_L2L4L6(10,10,10)
DubCol.D3.plot();
%
% DubCol.D4.plot();
DubCol.D4.optimize_L2L4L6(10,10,10)
DubCol.D4.plot();
%
% DubCol.D5.plot();
DubCol.D5.optimize_L2L4L6(10,10,10)
DubCol.D5.plot();
%
% DubCol.D6.plot();
DubCol.D6.optimize_L2L4L6(10,10,10)
DubCol.D6.plot();
%
% DubCol.D7.plot();
DubCol.D7.optimize_L2L4L6(10,10,10)
DubCol.D7.plot();
%
% DubCol.D8.plot();
DubCol.D8.optimize_L2L4L6(10,10,10)
DubCol.D8.plot();
%
% DubCol.D9.plot();
DubCol.D9.optimize_L2L4L6(10,10,10)
DubCol.D9.plot();
%
% DubCol.D10.plot();
DubCol.D10.optimize_L2L4L6(10,10,10)
DubCol.D10.plot();
%
% DubCol.D11.plot();
DubCol.D11.optimize_L2L4L6(10,10,10)
DubCol.D11.plot();
%
% DubCol.D12.plot();
DubCol.D12.optimize_L2L4L6(10,10,10)
DubCol.D12.plot();
%


