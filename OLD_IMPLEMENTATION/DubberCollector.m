classdef DubberCollector < handle
  properties
    D1;
    D2;
    D3;
    D4;
    D5;
    D6;
    D7;
    D8;
    D9;
    D10;
    D11;
    D12;
    P0;
    PT;
    J_max;
    K_max;
    V;
  end
  methods
    function this = DubberCollector(P0,PT,J_max,K_max,V)
      this.P0    = P0;
      this.PT    = PT;
      this.J_max = J_max;      
      this.K_max = K_max;
      this.V     = V;
      this.D1 = Dubber(P0,PT,['R','S','R'],J_max,K_max,V);
      this.D2 = Dubber(P0,PT,['R','S','L'],J_max,K_max,V);
      this.D3 = Dubber(P0,PT,['R','L','R'],J_max,K_max,V);
      this.D4 = Dubber(P0,PT,['R','L','S'],J_max,K_max,V);
      %
      this.D5 = Dubber(P0,PT,['S','R','S'],J_max,K_max,V);
      this.D6 = Dubber(P0,PT,['S','R','L'],J_max,K_max,V);
      this.D7 = Dubber(P0,PT,['S','L','R'],J_max,K_max,V);
      this.D8 = Dubber(P0,PT,['S','L','S'],J_max,K_max,V);
      %
      this.D9  = Dubber(P0,PT,['L','R','S'],J_max,K_max,V);
      this.D10 = Dubber(P0,PT,['L','R','L'],J_max,K_max,V);
      this.D11 = Dubber(P0,PT,['L','S','R'],J_max,K_max,V);
      this.D12 = Dubber(P0,PT,['L','S','L'],J_max,K_max,V);
    end
    %
    function optimise(this)
      this.D1.optimize_L2L4L6(5.0,5.0,5.0);
      this.D2.optimize_L2L4L6(5.0,5.0,5.0);
      this.D3.optimize_L2L4L6(5.0,5.0,5.0);
      this.D4.optimize_L2L4L6(5.0,5.0,5.0);
      %
      this.D5.optimize_L2L4L6(5.0,5.0,5.0);
      this.D6.optimize_L2L4L6(5.0,5.0,5.0);
      this.D7.optimize_L2L4L6(5.0,5.0,5.0);
      this.D8.optimize_L2L4L6(5.0,5.0,5.0);
      %
      this.D9.optimize_L2L4L6(5.0,5.0,5.0);
      this.D10.optimize_L2L4L6(5.0,5.0,5.0);
      this.D11.optimize_L2L4L6(5.0,5.0,5.0);
      this.D12.optimize_L2L4L6(5.0,5.0,5.0);
    end
  end

end

