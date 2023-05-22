`timescale 1ns / 1ps
//For keeping count of the lives that reduce when player moves on Red light

module clk_div_heart (clk, clk_d);
  parameter div_value = 12499999;
  input clk;
  output clk_d;
  reg clk_d;
  reg [25:0] count; 
  
  initial 
    begin
      clk_d = 0;
      count = 0;
    end
  
  always @(posedge clk)
    begin
      if (count == div_value)
        count <= 0;
      else
        count <= count + 1;
    end
  
  always @(posedge clk)
    begin
      if (count == div_value)
        clk_d <= ~clk_d;
    end 
endmodule 

module DFF(d, clk, reset, q, qnot);
input d; // Data input 
input clk, reset; // clock input 
output reg q, qnot; // output Q 
always @(posedge clk)
  begin 
    if (reset == 1)
      begin
        q <= 0;
        qnot <= 1; 
      end
    else
      begin 
        q <= d;
        qnot <= ~d;
      end 
  end
endmodule

module top(x,y,clk,reset,C);
  input x, y, clk, reset;
  output [1:0] C;
  wire clk_d;
  wire dA, dB, A, B;
  
  clk_div_heart g0(clk, clk_d);
  
  assign dA = (A) || (B&&x&&y);
  assign dB = (B&&~x) || (B&&~y) || (A&&B) || (~B&&x&&y);
  
  DFF g1(dA, clk_d, reset, A, ~A);
  DFF g2(dB, clk_d, reset, B, ~B);
  
  assign C[0] = (~A);
  assign C[1] = (~B);
  
  
  
endmodule
