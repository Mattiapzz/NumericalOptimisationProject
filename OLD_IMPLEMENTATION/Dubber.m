classdef Dubber < handle
  properties
    P0;
    PT;
    TYPE;
    J_max;
    K_max;
    V;
    L; 
    Pm1 = [0,0,0,0];
    Pm2 = [0,0,0,0];
    Pm3 = [0,0,0,0];
    Pm4 = [0,0,0,0];
    Pm5 = [0,0,0,0];
    Pm6 = [0,0,0,0];
    Pm7 = [0,0,0,0];
    L1=1;
    L2=1;
    L3=1;
    L4=1;
    L5=1;
    L6=1;
    L7=1;
    EPS = 10e-8;
    last_cost = 0;
  end
  methods
    function this = Dubber(P0,PT,TYPE,J_max,K_max,V)
      this.TYPE  = TYPE;
      this.P0    = P0;
      this.PT    = PT;
      this.J_max = J_max;      
      this.K_max = K_max;
      this.V     = V;
      this.compute_L(1.0,1.0,1.0);
    end
    %
    function compute_L(this,La,Lb,Lc)
      this.compute_L1();
      this.compute_L2(La); %% random value
      this.compute_L3();
      this.compute_L4(Lb);
      this.compute_L5();
      this.compute_L6(Lc);
      this.compute_L7();
      this.L = this.L1 + this.L2 + this.L3 + this.L4 + this.L5 + this.L6 + this.L7;
    end
    %
    function optimize_L2L4L6(this,La,Lb,Lc)
      fun = @(x)this.cost(x(1),x(2),x(3)); %% + 0.001 * (x(1) + x(2) + x(3))^2 + (x(1)-x(3))^2;
      z0 = [La,Lb,Lc];
      VEC = (this.PT(1:2) - this.P0(1:2));
      L_lim = 100 * sqrt(VEC*VEC');
      lb = [0,0,0];
      ub = [1,1,1]*L_lim;
      A = [];
      b = [];
      Aeq = [];
      beq = [];
      options = optimoptions('fmincon');
      options.OptimalityTolerance = 1e-10;
      options.StepTolerance       = 1e-10;
      options.Display             = 'off';
      z = fmincon(fun,z0,A,b,Aeq,beq,lb,ub,[],options);
      this.compute_L(z(1),z(2),z(3));
    end
    %
    function C = cost(this,La,Lb,Lc)
      this.compute_L(La,Lb,Lc);
      VEC = [1.0,1.0,1.0].*(this.PT(1:3) - this.Pm7(1:3));
      C = VEC*VEC';
      this.last_cost = C;
    end
    %
    function [c,ceq] = constraint(this,La,Lb,Lc)
      this.compute_L(La,Lb,Lc);
      ceq = (this.PT(1:3) - this.Pm7(1:3));
      c = [];
    end
    %
    function L1 = compute_L1(this)
      switch this.TYPE(1)
        case 'R'
          if abs(this.P0(4) -  this.K_max) < this.EPS
            this.L1  = 0;
            this.Pm1 = this.P0;
          else
            T = abs(this.K_max - this.P0(4))/this.J_max;
            PL = this.integrate_sys(this.P0,this.J_max,T);
            this.Pm1(1) =  PL(1);
            this.Pm1(2) =  PL(2);
            this.Pm1(3) =  PL(3);
            this.Pm1(4) =  PL(4);
            this.L1     =  PL(5);
          end
        case 'L'
          if abs(this.P0(4) +  this.K_max) < this.EPS
            this.L1  = 0;
            this.Pm1 = this.P0;
          else
            T = abs(-this.K_max - this.P0(4))/this.J_max;
            PL = this.integrate_sys(this.P0,-this.J_max,T);
            this.Pm1(1) =  PL(1);
            this.Pm1(2) =  PL(2);
            this.Pm1(3) =  PL(3);
            this.Pm1(4) =  PL(4);
            this.L1     =  PL(5);
          end
        case 'S'
          if abs(this.P0(4)) < this.EPS
            this.L1  = 0;
            this.Pm1 = this.P0;
          else
            T = abs(this.P0(4))/this.J_max;
            sig_K = sign(this.Pm2(4));
            PL = this.integrate_sys(this.P0,-sig_K*this.J_max,T);
            this.Pm1(1) =  PL(1);
            this.Pm1(2) =  PL(2);
            this.Pm1(3) =  PL(3);
            this.Pm1(4) =  PL(4);
            this.L1     =  PL(5);
          end
      end
      L1 = this.L1;
    end
    %
    function compute_L2(this,L2)
      T = L2/this.V;
      PL = this.integrate_sys(this.Pm1,0,T);
      this.Pm2(1) =  PL(1);
      this.Pm2(2) =  PL(2);
      this.Pm2(3) =  PL(3);
      this.Pm2(4) =  PL(4);
      this.L2     =  PL(5);
    end
    %
    function L3 = compute_L3(this)
      switch this.TYPE(2)
        case 'R'
          if abs(this.Pm2(4) -  this.K_max) < this.EPS
            this.L3  = 0;
            this.Pm3 = this.Pm2;
          else
            T = abs(this.K_max - this.Pm2(4))/this.J_max;
            PL = this.integrate_sys(this.Pm2,this.J_max,T);
            this.Pm3(1) =  PL(1);
            this.Pm3(2) =  PL(2);
            this.Pm3(3) =  PL(3);
            this.Pm3(4) =  PL(4);
            this.L3     =  PL(5);
          end
        case 'L'
          if abs(this.Pm2(4) +  this.K_max) < this.EPS
            this.L1  = 0;
            this.Pm3 = this.Pm2;
          else
            T = abs(-this.K_max - this.Pm2(4))/this.J_max;
            PL = this.integrate_sys(this.Pm2,-this.J_max,T);
            this.Pm3(1) =  PL(1);
            this.Pm3(2) =  PL(2);
            this.Pm3(3) =  PL(3);
            this.Pm3(4) =  PL(4);
            this.L3     =  PL(5);
          end
        case 'S'
          if abs(this.Pm2(4)) < this.EPS
            this.L1  = 0;
            this.Pm3 = this.Pm2;
          else
            T = abs( this.Pm2(4))/this.J_max;
            sig_K = sign(this.Pm2(4));
            PL = this.integrate_sys(this.Pm2,-sig_K*this.J_max,T);
            this.Pm3(1) =  PL(1);
            this.Pm3(2) =  PL(2);
            this.Pm3(3) =  PL(3);
            this.Pm3(4) =  PL(4);
            this.L3     =  PL(5);
          end
      end
      L3 = this.L3;
    end
    %
    function compute_L4(this,L4)
      T = L4/this.V;
      PL = this.integrate_sys(this.Pm3,0,T);
      this.Pm4(1) =  PL(1);
      this.Pm4(2) =  PL(2);
      this.Pm4(3) =  PL(3);
      this.Pm4(4) =  PL(4);
      this.L4     =  PL(5);
    end
    %
    function L5 = compute_L5(this)
      switch this.TYPE(3)
        case 'R'
          if abs(this.Pm4(4) -  this.K_max) < this.EPS
            this.L5  = 0;
            this.Pm5 = this.Pm4;
          else
            T = abs(this.K_max - this.Pm4(4))/this.J_max;
            PL = this.integrate_sys(this.Pm4,this.J_max,T);
            this.Pm5(1) =  PL(1);
            this.Pm5(2) =  PL(2);
            this.Pm5(3) =  PL(3);
            this.Pm5(4) =  PL(4);
            this.L5     =  PL(5);
          end
        case 'L'
          if abs(this.Pm4(4) +  this.K_max) < this.EPS
            this.L1  = 0;
            this.Pm5 = this.Pm4;
          else
            T = abs(-this.K_max - this.Pm4(4))/this.J_max;
            PL = this.integrate_sys(this.Pm4,-this.J_max,T);
            this.Pm5(1) =  PL(1);
            this.Pm5(2) =  PL(2);
            this.Pm5(3) =  PL(3);
            this.Pm5(4) =  PL(4);
            this.L5     =  PL(5);
          end
        case 'S'
          if abs(this.Pm4(4)) < this.EPS
            this.L1  = 0;
            this.Pm5 = this.Pm4;
          else
            T = abs( this.Pm4(4))/this.J_max;
            sig_K = sign(this.Pm4(4));
            PL = this.integrate_sys(this.Pm4,-sig_K*this.J_max,T);
            this.Pm5(1) =  PL(1);
            this.Pm5(2) =  PL(2);
            this.Pm5(3) =  PL(3);
            this.Pm5(4) =  PL(4);
            this.L5     =  PL(5);
          end
      end
      L5 = this.L5;
    end
    %
    function compute_L6(this,L6)
      T = L6/this.V;
      PL = this.integrate_sys(this.Pm5,0,T);
      this.Pm6(1) =  PL(1);
      this.Pm6(2) =  PL(2);
      this.Pm6(3) =  PL(3);
      this.Pm6(4) =  PL(4);
      this.L6     =  PL(5);
    end
    %
    function L7 = compute_L7(this)
      T = abs(this.PT(4) - this.Pm6(4))/this.J_max;
      sig_K = sign(this.PT(4) - this.Pm6(4));
      PL = this.integrate_sys(this.Pm6,sig_K*this.J_max,T);
      this.Pm7(1) =  PL(1);
      this.Pm7(2) =  PL(2);
      this.Pm7(3) =  PL(3);
      this.Pm7(4) =  PL(4);
      this.L7     =  PL(5);
      L7 = this.L7;
    end

    function PL = integrate_sys(this,Ps,J,T)
      % integrate from (x0,y0,theta0) = (this.P0(1),this.P0(2),this.P0(3)) to (x1,y1,theta1) = (this.PT(1),this.PT(2),this.PT(3)) with system
      % x' = v*cos(theta)
      % y' = v*sin(theta)
      % theta' = v*kappa
      % kappa' = J
      dt = 0.01*T;
      Ts = (0:0.01:1)*T;
      kappas = Ps(4) + J*Ts;
      thetas = zeros(1,length(kappas));
      xs = zeros(1,length(kappas));
      ys = zeros(1,length(kappas));
      ss = zeros(1,length(kappas));
      thetas(1) = Ps(3);
      xs(1) = Ps(1);
      ys(1) = Ps(2);
      for i = 2:length(kappas)
        thetas(i) = thetas(i-1) + this.V*kappas(i-1)*dt;
        xs(i) = xs(i-1) + this.V*cos(thetas(i-1))*dt;
        ys(i) = ys(i-1) + this.V*sin(thetas(i-1))*dt;
        ss(i) = ss(i-1) + this.V*dt;
      end
      PL = [xs(end);ys(end);thetas(end);kappas(end);ss(end)];
    end
    %
    function [XX,YY] = integrate_plot(this,Ps,Pe,L)
      T = L/this.V;
      J = (Pe(4)-Ps(4))/T;
      dt = 0.01*T;
      Ts = (0:0.01:1)*T;
      kappas = Ps(4) + J*Ts;
      thetas = zeros(1,length(kappas));
      xs = zeros(1,length(kappas));
      ys = zeros(1,length(kappas));
      thetas(1) = Ps(3);
      xs(1) = Ps(1);
      ys(1) = Ps(2);
      for i = 2:length(kappas)
        thetas(i) = thetas(i-1) + this.V*kappas(i-1)*dt;
        xs(i) = xs(i-1) + this.V*cos(thetas(i-1))*dt;
        ys(i) = ys(i-1) + this.V*sin(thetas(i-1))*dt;
      end
      XX = xs;
      YY = ys;
    end
    %
    function plot(this)
      figure()
      plot(this.P0(1),this.P0(2),'bo','LineWidth',2','MarkerSize',5);
      hold on;
      axis equal;
      % plot final point
      plot(this.PT(1),this.PT(2),'bo','LineWidth',2','MarkerSize',5);
      % plot middle points
      plot(this.Pm1(1),this.Pm1(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.P0,this.Pm1,this.L1);
      plot(XTMP,YTMP,'r-','LineWidth',2');
      plot(this.Pm2(1),this.Pm2(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.Pm1,this.Pm2,this.L2);
      plot(XTMP,YTMP,'g-','LineWidth',2');
      plot(this.Pm3(1),this.Pm3(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.Pm2,this.Pm3,this.L3);
      plot(XTMP,YTMP,'r-','LineWidth',2');
      plot(this.Pm4(1),this.Pm4(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.Pm3,this.Pm4,this.L4);
      plot(XTMP,YTMP,'g-','LineWidth',2');
      plot(this.Pm5(1),this.Pm5(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.Pm4,this.Pm5,this.L5);
      plot(XTMP,YTMP,'r-','LineWidth',2');
      plot(this.Pm6(1),this.Pm6(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.Pm5,this.Pm6,this.L6);
      plot(XTMP,YTMP,'g-','LineWidth',2');
      plot(this.Pm7(1),this.Pm7(2),'ro','LineWidth',2','MarkerSize',5);
      [XTMP,YTMP] = this.integrate_plot(this.Pm6,this.Pm7,this.L7);
      plot(XTMP,YTMP,'r-','LineWidth',2');
    end
  end

end

