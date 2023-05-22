`timescale 1ns / 1ps

//For fluctuating Red and Green light on the screen

module dff(D,clk,Q);
input D; // Data input 
input clk; // clock input 
output Q; // output Q 
reg Q;


always @(posedge clk) 
begin
 Q <= D; 
end 
endmodule

module clk_div_new(clk,clk_d);
  parameter div_value = 49999999;
  input clk;
  output clk_d;
  reg clk_d;
  reg [25:0]count;
  initial
    begin
      clk_d = 0;
      count = 0;
    end
  always @(posedge clk)
    begin
      if(count == div_value)
        count <=0;
      else
        count <=count + 1;
    end
  
  always @(posedge clk)
    begin
      if (count == div_value)
        clk_d = ~clk_d;
    end
endmodule

  module light_FSM(clk,red,green);
  input clk;
  wire state;
  reg next_state;
  wire clk_d;
  output red;
  output green;
  reg green;
  reg red;
  
    
    initial begin
      next_state <= 1;
      red <= 1;
      green <= 0;
  end
  
  clk_div_new c(clk,clk_d);
  dff(next_state,clk_d,state);
  
  
  always @(posedge clk_d)
    begin
      next_state <= ~state;
      
      if (state)
        begin
          green = ~green;
          red = ~red;
        end
        else begin
        green = ~green;
        red = ~red;
        end
      
    
    end
    
    endmodule
