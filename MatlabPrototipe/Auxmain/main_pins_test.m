%% TEST PINS Dubinoid
clc;
clear all;
close all;
setup();
%%

fprintf("TEST - PINS Dubinoids \n")

mex_dir  = '../Problems/DubinsJerk/generated_code/ocp-interfaces/Matlab/';
data_dir = '../Problems/DubinsJerk/generated_code/data/';
src_dir  = '../Problems/DubinsJerk/generated_code/';

addpath(mex_dir),

% create object
ocp = Dubins( 'Dubins' );

%ocp.help(); % print usage

% -----------------------------------------------------------------------------
% SET UP OF OPTIMAL CONTROL PROBLEM
% -----------------------------------------------------------------------------
% READ PROBLEM DATA-------------------------------------------------------------
% model data from 'model' structure defined in the following m.file
%ocp.setup(Dubins_data);
ocp.setup([data_dir , 'Dubins_Data']);  % automatically try extension .rb and .lua
ocp.set_info_level(4);

ocp_data_struct = ocp.get_ocp_data;


% bounds
data_DUBINOIDS.kmax   = 0.15;
data_DUBINOIDS.jmax   = 0.1;
data_DUBINOIDS.v      = 1.0;
% initial values
data_DUBINOIDS.x0     = 0;
data_DUBINOIDS.y0     = 0;
data_DUBINOIDS.theta0 = 0;
data_DUBINOIDS.kappa0 = 0;
% final values
data_DUBINOIDS.xT     = 40;
data_DUBINOIDS.yT     = 20;
data_DUBINOIDS.thetaT = 0;
data_DUBINOIDS.kappaT = 0;

ocp_data_struct.Parameters.x__0     = data_DUBINOIDS.x0;
ocp_data_struct.Parameters.y__0     = data_DUBINOIDS.y0;
ocp_data_struct.Parameters.theta__0 = data_DUBINOIDS.theta0;
ocp_data_struct.Parameters.kappa__0 = data_DUBINOIDS.kappa0;
ocp_data_struct.Parameters.x__T     = data_DUBINOIDS.xT;
ocp_data_struct.Parameters.y__T     = data_DUBINOIDS.yT;
ocp_data_struct.Parameters.theta__T = data_DUBINOIDS.thetaT;
ocp_data_struct.Parameters.kappa__T = data_DUBINOIDS.kappaT;
ocp_data_struct.Parameters.kmax     = data_DUBINOIDS.kmax;
ocp_data_struct.Parameters.jmax     = data_DUBINOIDS.jmax;
ocp_data_struct.Parameters.v        = data_DUBINOIDS.v;

ocp.setup(ocp_data_struct);

ocp.set_guess(); % use default guess generated in MAPLE
%
% in alternative
% ocp.set_guess( struct );
%
% initialize the guess using the following criteria
%
% struct.initialize
% 'zero'           % fill the guess with all zero
% 'none' or 'warm' % do not fill the guess, use existing guess in memory
%
% after initialization fill the guess
% struct.guess_type
% 'none'      % in this case none is done
% 'default'   % fill the guess with the guess generated in MAPLE
% 'spline'    % use spline to initialize states/multiplers
%             expected extra fields
%             struct.spline_set             = structure with the spline table to
%                                             initialize states/multipliers/controls
%             struct.spline_set.spline_type = cell array of strings with the type of
%                                             splines ('pchip','cubic','quintic')
%             struct.spline_set.xdata       = vector of 'x' samples of the splines
%             struct.spline_set.ydata       = matrix npts x data of 'y' of the splines
%             struct.spline_set.headers     = cell array of strings with name of
%                                             the splines (name of states/multipliers/controls)
%
%             the data of the guess are updated ONLY in the 'x' range of the spline
%
% 'table'     % use sampled values to initialize states/multiplers
%             struct.states      =  structure of vectors, each field is the name of the state
%             struct.multipliers =  structure of vectors, each field is the name of the multiplier
%             struct.controls    =  structure of vectors, each field is the name of the control
%
%             the length of the vector must be compatible with the mesh
%

check_jacobian = false; % set true if you want to check jacobian matrix
if check_jacobian
  % check the jacobian of initial guess
  epsi = 1e-5;
  [ Z, MU, U ] = ocp.get_raw_solution();
  ocp.check_jacobian( Z, MU, U, epsi );
end

names = ocp.names();

% SET TRACKED VARIABLE ---------------------------------------------------------
% Specify the problem variable that you want to track during solver iteration
% by filling in the following cell array:
%tracked = {<'xx1'>,<'xx2'>,...}
%tracked = {};
%Dubins_Mex('set_tracked',obj,tracked);

% -------------------------------------------------------------------------
% COMPUTE SOLUTION
% -------------------------------------------------------------------------
timeout_ms = 0; % if > 0 set a timeout in ms
ok = ocp.solve( timeout_ms );
% ok = false if computation failed
% ok = true if computation is succesfull
if check_jacobian
  % check the jacobian of the computed solution
  epsi = 1e-5;
  [ Z, MU, U ] = ocp.get_raw_solution();
  ocp.check_jacobian( Z, MU, U, epsi );
end

% -------------------------------------------------------------------------
% GET SOLUTION
% -------------------------------------------------------------------------
solution = ocp.solution(); % whole solution in a structure
zeta = ocp.solution('zeta');

% -------------------------------------------------------------------------
% PLOT SOLUTION
% -------------------------------------------------------------------------

subplot(3,1,1);
ocp.plot_states();

subplot(3,1,2);
ocp.plot_multipliers();

subplot(3,1,3);
ocp.plot_controls();