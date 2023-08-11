function fh = plot_traj_pins(ocp,varargin)
  if nargin > 1
    fh = varargin{1};
  else
    figure();
    fh = gca;
  end
  xplt = ocp.solution('x');
  yplt = ocp.solution('y');
  if nargin > 2
    plot(fh,xplt,yplt,varargin{2:end})
  else
    plot(fh,xplt,yplt,'k-.','LineWidth',2)
  end
  hold on
  axis equal
  grid on
  grid minor
end