classdef DuboidCollector < handle
  properties
    DS =[];
    idx_best = -1;
    L_best = inf;
    D_best;
    D_best_candidates = [];
    P0;
    PT;
    J_max;
    K_max;
    V;
    comb = {['R','S','R'],...
            ['R','S','L'],...
            ['R','L','R'],...
            ['R','L','S'],...
            ['S','R','S'],...
            ['S','R','L'],...
            ['S','L','R'],...
            ['S','L','S'],...
            ['L','R','S'],...
            ['L','R','L'],...
            ['L','S','R'],...
            ['L','S','L'],...
            ['R','0','0'],...
            ['S','0','0'],...
            ['L','0','0'],...
            ['R','S','0'],...
            ['R','L','0'],...
            ['S','R','0'],...
            ['S','L','0'],...
            ['L','R','0'],...
            ['L','S','0']};
  end
  methods
    function this = DuboidCollector(P0,PT,J_max,K_max,V)
      this.P0    = P0;
      this.PT    = PT;
      this.J_max = J_max;      
      this.K_max = K_max;
      this.V     = V;
      %
      for i=1:length(this.comb)
        this.DS = [this.DS;Duboid(P0,PT,this.comb{i},J_max,K_max,V)];
      end
    end
    %
    function optimize(this)
      %
      for i=1:length(this.comb)
        this.DS(i).optimize();
        if (this.DS(i).L < this.L_best && this.DS(i).ok_flag == true)
          this.L_best = this.DS(i).L;
          this.idx_best = i;
          this.D_best = Duboid(this.P0,this.PT,this.comb{i},this.J_max,this.K_max,this.V); 
          this.D_best.compute_L(this.DS(i).L2,this.DS(i).L4,this.DS(i).L6);
          this.D_best_candidates = [this.D_best_candidates; Duboid(this.P0,this.PT,this.comb{i},this.J_max,this.K_max,this.V) ];
          this.D_best_candidates(end).compute_L(this.DS(i).L2,this.DS(i).L4,this.DS(i).L6);
        end
      end
      if this.idx_best < 0
        fprintf("WARNING: No suitable combination found to solve the problem within the tolerance\n");
      end
    end
    %
    function fighandle = plot(this,varargin)
      for i=1:length(this.comb)
        fighandle = this.DS(i).plot(varargin{:});
      end
    end
    %
    function fighandle = plot_best(this,varargin)
      if this.idx_best > 0
        fighandle = this.D_best.plot(varargin{:});
      else
        fighandle = [];
        fprintf("No suitable combination found to solve the problem within the tolerance\n");
      end
    end
    %
    function fighandle = plot_all_best(this,varargin)
      if this.idx_best > 0
        for i=1:length(this.D_best_candidates)
          fighandle = this.D_best_candidates(i).plot(varargin{:});
        end
      else
        fighandle = [];
        fprintf("No suitable combination found to solve the problem within the tolerance\n");
      end
    end
    %
    function fighandle = plot_best_std(this,varargin)
      if this.idx_best > 0
        fighandle = this.D_best.plot_std(varargin{:});
      else
        fighandle = [];
        fprintf("No suitable combination found to solve the problem within the tolerance\n");
      end
    end
    %
    function kappa = eval_kappa_best(this,SS)
      kappa = this.D_best.eval_kappa(SS);
    end
    %
    function J = eval_J_best(this,SS)
      J = this.D_best.eval_J(SS);
    end
    %
    function theta = eval_theta_best(this,SS)
      theta = this.D_best.eval_theta(SS);
    end
    %
    function x = eval_x_best(this,SS)
      x = this.D_best.eval_x(SS);
    end
    %
    function y = eval_y_best(this,SS)
      y = this.D_best.eval_y(SS);
    end
    %
  end

end

