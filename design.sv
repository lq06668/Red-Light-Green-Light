// Code your design here

module TopLevelModule(clk, ps2_clk, ps2_data, red, green, blue, h_sync, v_sync);
input clk;
input ps2_clk;
input ps2_data;
output [3:0]red;
output [3:0]green;
output [3:0]blue;
output h_sync;
output v_sync;
 
wire M1,M3,M7;
wire [9:0] M2, M4,M8,M9;
 
clk_div a1(clk,M1);
h_counter a2(M1,M2,M3);
v_counter a3(M1,M3, M4);
vga_sync a4(M2, M4, h_sync, v_sync, M7,M8,M9);
pixel_gen a5(M1, M8, M9, M7, ps2_clk, ps2_data, red, green, blue);
endmodule
 

module vga_sync(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
input [9:0] h_count;
input [9:0] v_count;
output h_sync;
output v_sync;
output video_on;
output [9:0] x_loc;
output [9:0] y_loc;
 
//horizontal
localparam HD = 640;
localparam HF = 48;
localparam HB = 16;
localparam HR = 96;
 
//vertical
localparam VD = 480;
localparam VF = 10;
localparam VB = 33;
localparam VR = 2;
 

  assign h_sync = ((h_count < (HD+HF)) || (h_count >= (HD+HF+HR)));

  
  assign v_sync = ((v_count < (VD+VF)) || (v_count >= (VD+VF+VR)));

  
  assign video_on = ((h_count < HD) && (v_count < VD));

  
  
  assign x_loc = h_count; 
  assign y_loc = v_count; 
  
endmodule


module h_counter(clk,h_count,trig_v);
input clk;
output [9:0] h_count;
reg [9:0] h_count;
output trig_v;
reg trig_v;
initial h_count = 0;
initial trig_v = 0;
 
always @ (posedge clk)
begin
if (h_count <= 798)
begin
h_count <= h_count +1;
trig_v <= 0;
end
else
begin
h_count <= 0;
trig_v <= 1;
end
end
endmodule
 

module v_counter(clk,enable_v, v_count);
input clk;
input enable_v;
output [9:0] v_count;
reg [9:0] v_count;
initial v_count = 0;
 
always @ (posedge clk)
begin
if (enable_v ==1)
begin
if (v_count <= 523)
begin
v_count <= v_count + 1;
end
else
begin
v_count <= 0;
end
end
end
endmodule
 

module clk_div (clk, clk_d);
parameter div_value = 1;
input clk;
output clk_d;
 
reg clk_d;
reg count;
 
initial
begin
clk_d = 0;
count = 0;
end
always @(posedge clk)
begin
if (count == div_value)
count <= 0; // reset count
else
count <= count + 1; //count up
end
always @(posedge clk)
begin
if (count == div_value)
clk_d <= ~clk_d; //toggle
end
endmodule
