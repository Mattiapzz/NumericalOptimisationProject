function [solution,ocp] = compute_Duboids_PINS(data_struct)

  mex_dir  = '../OCP_Problems/DubinsJerk/generated_code/ocp-interfaces/Matlab/';
  data_dir = '../OCP_Problems/DubinsJerk/generated_code/data/';
  
  addpath(mex_dir);

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
  ocp.set_info_level(1);
  
  ocp_data_struct = ocp.get_ocp_data;


  ocp_data_struct.Parameters.x__0       = data_struct.x0;
  ocp_data_struct.Parameters.y__0       = data_struct.y0;
  ocp_data_struct.Parameters.theta__0   = data_struct.theta0;
  ocp_data_struct.Parameters.kappa__0   = data_struct.kappa0;
  ocp_data_struct.Parameters.x__T       = data_struct.xT;
  ocp_data_struct.Parameters.y__T       = data_struct.yT;
  ocp_data_struct.Parameters.theta__T   = data_struct.thetaT;
  ocp_data_struct.Parameters.kappa__T   = data_struct.kappaT;
  ocp_data_struct.Parameters.kappa__max = data_struct.kmax;
  ocp_data_struct.Parameters.J__max     = data_struct.jmax;
  ocp_data_struct.Parameters.V          = data_struct.v;

  ocp_data_struct.Mesh.segments{1}.length = 1.0;
  ocp_data_struct.Mesh.segments{1}.n      = 1000;
  
  ocp.setup(ocp_data_struct);
  
  ocp.set_guess(); % use default guess generated in MAPLE
  %
  
  names = ocp.names();


  % -------------------------------------------------------------------------
  % COMPUTE SOLUTION
  % -------------------------------------------------------------------------
  timeout_ms = 0; % if > 0 set a timeout in ms
  ok = ocp.solve( timeout_ms );
  % ok = false if computation failed
  % ok = true if computation is succesfull

  % -------------------------------------------------------------------------
  % GET SOLUTION
  % -------------------------------------------------------------------------
  solution = ocp.solution(); % whole solution in a structure

end