classdef Dubinoid < handle
  % Dubinoid class to compute a ax extended dubins with clothoids
  properties
    Clist;                    % clothoidlist to append all the 7 or less segments
    P0;                       % starting point
    PT;                       % ending point
    TYPE;                     % type of combined manouvre(i.e. ['R','S','L'], ['L','S','R'], etc.)
    J_max;                    % maximum jerk ( maximum "curvature rate")
    K_max;                    % maximum curvature
    V;                        % velocity
    L         = 0;            % total length of the combined manouvre
    Pm1       = [0,0,0,0];    % intermediate point
    Pm2       = [0,0,0,0];    % intermediate point
    Pm3       = [0,0,0,0];    % intermediate point
    Pm4       = [0,0,0,0];    % intermediate point
    Pm5       = [0,0,0,0];    % intermediate point
    Pm6       = [0,0,0,0];    % intermediate point
    Pm7       = [0,0,0,0];    % intermediate point (to be equal to PT)
    L1        = 0;            % segment length
    L2        = 0;            % segment length
    L3        = 0;            % segment length
    L4        = 0;            % segment length
    L5        = 0;            % segment length
    L6        = 0;            % segment length
    L7        = 0;            % segment length
    EPS       = 10e-6;        % tolerance to accept a solution
    last_cost = inf;          % last computed cost (for debug purpose)
    ok_flag   = false;        % flag to indicate if the solution is ok
  end
  methods
    % Constructor
    function this = Dubinoid(P0,PT,TYPE,J_max,K_max,V)
    % Dubinoid constructor to compute a ax extended dubins with clothoids
    %  P0   = starting point
    %  PT   = ending point
    %  TYPE = type of combined manouvre(i.e. ['R','S','L'], ['L','S','R'], etc.)
    %  J_max = maximum jerk ( maximum "curvature rate")
    %  K_max = maximum curvature
    %  V     = velocity
      this.TYPE  = TYPE;
      this.P0    = P0;
      this.PT    = PT;
      this.J_max = J_max;      
      this.K_max = K_max;
      this.V     = V;
      this.Clist = ClothoidList();
      this.compute_L(2.0,5.0,2.0);
    end
    %
    function compute_L(this,La,Lb,Lc)
      % compute_L compute the length of the combined manouvre given the 3 lengths La Lb Lc of the 3 segments with constant curvature (straigth or arcs)
      %  La = length of the first segment (L2)
      %  Lb = length of the second segment (L4)
      %  Lc = length of the third segment (L6)
      this.Clist = ClothoidList();
      this.compute_L1();
      this.compute_L2(La); 
      this.compute_L3();
      this.compute_L4(Lb);
      this.compute_L5();
      this.compute_L6(Lc);
      this.compute_L7();
      this.L = abs(this.L1) + abs(this.L2) + abs(this.L3) + abs(this.L4) + abs(this.L5) + abs(this.L6) + abs(this.L7);
    end
    %
    function [L2,L4,L6] = optimize(this)
      % optimize compute the optimal length of the 3 segments with constant curvature (straigth or arcs)
      PTP0 = this.PT(1:3)-this.P0(1:3);
      z0   = this.get_guess();
      % this.compute_L(z0(1),z0(2),z0(3));
      fun     = @(x)this.cost(x(1),x(2),x(3));
      lb      = [0,0,0];
      ub      = this.get_upper_bound();
      A       = [];
      b       = [];
      Aeq     = [];
      beq     = [];
      options = optimoptions('fmincon');
      options.OptimalityTolerance = 1e-10;
      options.StepTolerance       = 1e-10;
      options.MaxIterations       = 10000;
      options.Display             = 'off'; % 'iter-detailed';
      z = fmincon(fun,z0,A,b,Aeq,beq,lb,ub,[],options);
      [L2,L4,L6] = deal(z);
      % z    = this.optimize_L2L4L6(z0(1),z0(2),z0(3));
      if this.last_cost < this.EPS
        this.ok_flag = true;
      end
    end
    %
    % function [L2,L4,L6] = optimize_L2L4L6(this,La,Lb,Lc)
    %   % optimize_L2L4L6 compute the optimal length of the 3 segments with constant curvature (straigth or arcs)
    %   z0      = [La,Lb,Lc];
    %   fun     = @(x)this.cost(x(1),x(2),x(3));
    %   lb      = [0,0,0];
    %   ub      = this.get_upper_bound();
    %   A       = [];
    %   b       = [];
    %   Aeq     = [];
    %   beq     = [];
    %   options = optimoptions('fmincon');
    %   options.OptimalityTolerance = 1e-10;
    %   options.StepTolerance       = 1e-10;
    %   options.MaxIterations       = 10000;
    %   options.Display             = 'off'; % 'iter-detailed';
    %   z = fmincon(fun,z0,A,b,Aeq,beq,lb,ub,[],options);
    %   [L2,L4,L6] = deal(z);
    % end
    %
    function UB = get_upper_bound(this)
      UB = [1,1,1];
      for i=1:3
        switch this.TYPE(i)
          case 'L'
            UB(i) = 2*pi/this.K_max;
          case 'R'
            UB(i) = 2*pi/this.K_max;
          case 'S'
            UB(i) = 100*norm(this.PT(1:2)-this.P0(1:2)); %% at least 100 times the distance
        end
      end
    end
    %
    function IG = get_guess(this)
      IG = [1,1,1];
      for i=1:3
        switch this.TYPE(i)
          case 'L'
            IG(i) = (2*pi/this.K_max)/2;
          case 'R'
            IG(i) = (2*pi/this.K_max)/2;
          case 'S'
            IG(i) = norm(this.PT(1:2)-this.P0(1:2)); %% at least 100 times the distance
        end
      end
    end
    %
    function [c,ceq] = constraint(this,La,Lb,Lc)
      this.compute_L(La,Lb,Lc);
      ceq = (this.PT(1:3) - this.Pm7(1:3));
      c = [];
    end
    %
    function C = cost(this,La,Lb,Lc)
      this.compute_L(La,Lb,Lc);
      VEC = (this.PT(1:3) - this.Pm7(1:3));;
      C = dot(VEC,VEC);
      this.last_cost = C;
    end
    %
    function L1 = compute_L1(this)
      switch this.TYPE(1)
        case 'L'
          if abs(this.P0(4) -  this.K_max) < this.EPS
            this.L1  = 0;
            this.Pm1 = this.P0;
          else
            deltaK = this.K_max - this.P0(4);
            K0     = this.P0(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L1 = S;
            this.Clist.push_back(this.P0(1),this.P0(2),this.P0(3),K0,deltaK/this.L1,this.L1);
            this.L1 = this.Clist.length();
            this.Pm1(1) =  this.Clist.xEnd;
            this.Pm1(2) =  this.Clist.yEnd;
            this.Pm1(3) =  this.Clist.thetaEnd;
            this.Pm1(4) =  this.Clist.kappaEnd;
          end
        case 'R'
          if abs(this.P0(4) +  this.K_max) < this.EPS
            this.L1  = 0;
            this.Pm1 = this.P0;
          else
            deltaK = -this.K_max - this.P0(4);
            K0     = this.P0(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L1 = S;
            this.Clist.push_back(this.P0(1),this.P0(2),this.P0(3),K0,deltaK/this.L1,this.L1);
            this.L1 = this.Clist.length();
            this.Pm1(1) =  this.Clist.xEnd;
            this.Pm1(2) =  this.Clist.yEnd;
            this.Pm1(3) =  this.Clist.thetaEnd;
            this.Pm1(4) =  this.Clist.kappaEnd;
          end
        case 'S'
          if abs(this.P0(4)) < this.EPS
            this.L1  = 0;
            this.Pm1 = this.P0;
          else
            deltaK = -this.P0(4);
            K0     = this.P0(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L1 = S;
            this.Clist.push_back(this.P0(1),this.P0(2),this.P0(3),K0,deltaK/this.L1,this.L1);
            this.L1 = this.Clist.length();
            this.Pm1(1) =  this.Clist.xEnd;
            this.Pm1(2) =  this.Clist.yEnd;
            this.Pm1(3) =  this.Clist.thetaEnd;
            this.Pm1(4) =  this.Clist.kappaEnd;
          end
      end
      L1 = this.L1;
    end
    %
    function compute_L2(this,L2)
      if L2 < this.EPS
        this.L2  = 0;
        this.Pm2 = this.Pm1;
        return;
      end
      this.Clist.push_back(this.Pm1(1),this.Pm1(2),this.Pm1(3),this.Pm1(4),0.0,L2);
      this.L2 = this.Clist.length()-this.L1;
      this.Pm2(1) =  this.Clist.xEnd;
      this.Pm2(2) =  this.Clist.yEnd;
      this.Pm2(3) =  this.Clist.thetaEnd;
      this.Pm2(4) =  this.Clist.kappaEnd;
    end
    %
    function L3 = compute_L3(this)
      switch this.TYPE(2)
        case '0'
          this.L3  = 0;
          this.Pm3 = this.Pm2;
        case 'L'
          if abs(this.Pm2(4) -  this.K_max) < this.EPS
            this.L3  = 0;
            this.Pm3 = this.Pm2;
          else
            deltaK = this.K_max - this.Pm2(4);
            K0 = this.Pm2(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L3 = S;
            this.Clist.push_back(this.Pm2(1),this.Pm2(2),this.Pm2(3),K0,deltaK/this.L3,this.L3);
            this.L3     =  this.Clist.length()-this.L1-this.L2;
            this.Pm3(1) =  this.Clist.xEnd;    
            this.Pm3(2) =  this.Clist.yEnd;    
            this.Pm3(3) =  this.Clist.thetaEnd;
            this.Pm3(4) =  this.Clist.kappaEnd;
          end
        case 'R'
          if abs(this.Pm2(4) +  this.K_max) < this.EPS
            this.L3  = 0;
            this.Pm3 = this.Pm2;
          else
            deltaK = (-this.K_max - this.Pm2(4));
            K0 = this.Pm2(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L3 = S;
            this.Clist.push_back(this.Pm2(1),this.Pm2(2),this.Pm2(3),K0,deltaK/this.L3,this.L3);
            this.L3 = this.Clist.length()-this.L1-this.L2;
            this.Pm3(1) =  this.Clist.xEnd;
            this.Pm3(2) =  this.Clist.yEnd;
            this.Pm3(3) =  this.Clist.thetaEnd;
            this.Pm3(4) =  this.Clist.kappaEnd;
          end
        case 'S'
          if abs(this.Pm2(4)) < this.EPS
            this.L3  = 0;
            this.Pm3 = this.Pm2;
          else
            deltaK = (0-this.Pm2(4));
            K0 = this.Pm2(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L3 = S;
            this.Clist.push_back(this.Pm2(1),this.Pm2(2),this.Pm2(3),K0,deltaK/this.L3,this.L3);
            this.L3 = this.Clist.length()-this.L1-this.L2;
            this.Pm3(1) =  this.Clist.xEnd;
            this.Pm3(2) =  this.Clist.yEnd;
            this.Pm3(3) =  this.Clist.thetaEnd;
            this.Pm3(4) =  this.Clist.kappaEnd;
          end
      end
      L3 = this.L3;
    end
    %
    function compute_L4(this,L4)
      if this.TYPE(2) == '0'
        this.L4  = 0;
        this.Pm4 = this.Pm3;
        return;
      end
      %
      if L4 < this.EPS
        this.L4  = 0;
        this.Pm4 = this.Pm3;
        return;
      end
      this.Clist.push_back(this.Pm3(1),this.Pm3(2),this.Pm3(3),this.Pm3(4),0.0,L4);
      this.L4 = this.Clist.length()-this.L1-this.L2-this.L3;
      this.Pm4(1) =  this.Clist.xEnd;
      this.Pm4(2) =  this.Clist.yEnd;
      this.Pm4(3) =  this.Clist.thetaEnd;
      this.Pm4(4) =  this.Clist.kappaEnd;
    end
    %
    function L5 = compute_L5(this)
      switch this.TYPE(3)
        case '0'
          this.L5  = 0;
          this.Pm5 = this.Pm4;
        case 'L'
          if abs(this.Pm4(4) -  this.K_max) < this.EPS
            this.L5  = 0;
            this.Pm5 = this.Pm4;
          else
            deltaK = this.K_max - this.Pm4(4);
            K0 = this.Pm4(4);
            T = abs(deltaK)/this.J_max;
            this.L5 = T*this.V;
            this.Clist.push_back(this.Pm4(1),this.Pm4(2),this.Pm4(3),K0,deltaK/this.L5,this.L5);
            this.L5     =  this.Clist.length()-this.L1-this.L2-this.L3-this.L4;
            this.Pm5(1) =  this.Clist.xEnd;
            this.Pm5(2) =  this.Clist.yEnd;
            this.Pm5(3) =  this.Clist.thetaEnd;
            this.Pm5(4) =  this.Clist.kappaEnd;
          end
        case 'R'
          if abs(this.Pm4(4) +  this.K_max) < this.EPS
            this.L5  = 0;
            this.Pm5 = this.Pm4;
          else
            deltaK = (-this.K_max - this.Pm4(4));
            K0 = this.Pm4(4);
            T = abs(deltaK)/this.J_max;
            this.L5 = T*this.V;
            this.Clist.push_back(this.Pm4(1),this.Pm4(2),this.Pm4(3),K0,deltaK/this.L5,this.L5);
            this.L5     =  this.Clist.length()-this.L1-this.L2-this.L3-this.L4;
            this.Pm5(1) =  this.Clist.xEnd;
            this.Pm5(2) =  this.Clist.yEnd;
            this.Pm5(3) =  this.Clist.thetaEnd;
            this.Pm5(4) =  this.Clist.kappaEnd;
          end          
        case 'S'
          if abs(this.Pm4(4)) < this.EPS
            this.L5  = 0;
            this.Pm5 = this.Pm4;
          else
            deltaK = (0-this.Pm4(4));
            K0 = this.Pm4(4);
            T = abs(deltaK)/this.J_max;
            S = T*this.V;
            this.L5 = S;
            this.Clist.push_back(this.Pm4(1),this.Pm4(2),this.Pm4(3),K0,deltaK/this.L5,this.L5);
            this.L5     =  this.Clist.length()-this.L1-this.L2-this.L3-this.L4;
            this.Pm5(1) =  this.Clist.xEnd;
            this.Pm5(2) =  this.Clist.yEnd;
            this.Pm5(3) =  this.Clist.thetaEnd;
            this.Pm5(4) =  this.Clist.kappaEnd;
          end
      end
      L5 = this.L5;
    end
    %
    function compute_L6(this,L6)
      if this.TYPE(3) == '0'
        this.L6  = 0;
        this.Pm6 = this.Pm5;
        return;
      end
      if L6 < this.EPS
        this.L6  = 0;
        this.Pm6 = this.Pm5;
        return;
      end
      this.Clist.push_back(this.Pm5(1),this.Pm5(2),this.Pm5(3),this.Pm5(4),0.0,L6);
      this.L6 = this.Clist.length()-this.L1-this.L2-this.L3-this.L4-this.L5;
      this.Pm6(1) =  this.Clist.xEnd;
      this.Pm6(2) =  this.Clist.yEnd;
      this.Pm6(3) =  this.Clist.thetaEnd;
      this.Pm6(4) =  this.Clist.kappaEnd;
    end
    %
    function L7 = compute_L7(this)
      deltaK = (this.PT(4) - this.Pm6(4));
      if abs(deltaK) < this.EPS
        this.L7  = 0;
        this.Pm7 = this.Pm6;
        L7 = this.L7;
        return;
      end
      K0 = this.Pm6(4);
      T = abs(deltaK)/this.J_max;
      S = T*this.V;
      this.L7 = S;
      this.Clist.push_back(this.Pm6(1),this.Pm6(2),this.Pm6(3),K0,deltaK/this.L7,this.L7);
      this.L7     =  this.Clist.length()-this.L1-this.L2-this.L3-this.L4-this.L5-this.L6;
      this.Pm7(1) =  this.Clist.xEnd;
      this.Pm7(2) =  this.Clist.yEnd;
      this.Pm7(3) =  this.Clist.thetaEnd;
      this.Pm7(4) =  this.Clist.kappaEnd;
      L7 = this.L7;
    end
    %
    function plot(this,varargin)
      fighandle = [];
      if nargin > 1
        fighandle = varargin{1};
      else
        figure();
        fighandle = gca;
      end
      hold on;
      axis equal;
      %
      SS0 = 0;
      SS1 = this.L1;
      SS2 = SS1+this.L2;
      SS3 = SS2+this.L3;
      SS4 = SS3+this.L4;
      SS5 = SS4+this.L5;
      SS6 = SS5+this.L6;
      SS7 = SS6+this.L7;
      %
      this.plot_interval(fighandle, SS0, SS1,'r-','LineWidth',2);
      this.plot_interval(fighandle, SS1, SS2,'g-','LineWidth',2);
      this.plot_interval(fighandle, SS2, SS3,'r-','LineWidth',2);
      this.plot_interval(fighandle, SS3, SS4,'g-','LineWidth',2);
      this.plot_interval(fighandle, SS4, SS5,'r-','LineWidth',2);
      this.plot_interval(fighandle, SS5, SS6,'g-','LineWidth',2);
      this.plot_interval(fighandle, SS6, SS7,'r-','LineWidth',2);
      % plot middle points
      plot(fighandle,this.Pm1(1),this.Pm1(2),'ro','LineWidth',2','MarkerSize',5);
      plot(fighandle,this.Pm2(1),this.Pm2(2),'ro','LineWidth',2','MarkerSize',5);
      plot(fighandle,this.Pm3(1),this.Pm3(2),'ro','LineWidth',2','MarkerSize',5);
      plot(fighandle,this.Pm4(1),this.Pm4(2),'ro','LineWidth',2','MarkerSize',5);
      plot(fighandle,this.Pm5(1),this.Pm5(2),'ro','LineWidth',2','MarkerSize',5);
      plot(fighandle,this.Pm6(1),this.Pm6(2),'ro','LineWidth',2','MarkerSize',5);
      plot(fighandle,this.Pm7(1),this.Pm7(2),'ro','LineWidth',2','MarkerSize',5);
      % plot start point
      plot(fighandle,this.P0(1), this.P0(2), 'bo','LineWidth',2','MarkerSize',5);
      % plot final point
      plot(fighandle,this.PT(1), this.PT(2), 'bo','LineWidth',2','MarkerSize',5);
      %
    end
    %
    function plot_interval(this,fighandle,SI,SF,varargin)
      SS = (0:0.01:1) * (SF-SI)+SI;
      [XTMP,YTMP] = this.Clist.eval(SS);
      plot(fighandle,XTMP,YTMP,varargin{:});
    end
  end
  %
end

