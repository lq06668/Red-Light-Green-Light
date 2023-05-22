
module pixel_gen( 
  input clk_d, // pixel clock 
  input [9:0] pixel_x, 
  input [9:0] pixel_y, 
  input video_on, 
  input ps2_clk,
  input ps2_data,
  output reg [3:0] red=0, 
  output reg [3:0] green=0, 
  output reg [3:0] blue=0
);
  parameter start = 2'b00;
  parameter game = 2'b01;
  parameter gamewon = 2'b10;
  parameter gameover = 2'b11;
  reg animate;
  wire [1:0] hearts;
  reg move;
  reg displayone;
  reg displaytwo;
  reg displaythree;
  reg[1:0] state = start;
  
  
  // Calling all the modules in this pixelgen that are supposed to be displayed
  
  wire s1_pix;
  startup s1(pixel_x, pixel_y, s1_pix);
  
  wire maze_pix;
  maze m1(pixel_x, pixel_y, maze_pix);
  
  wire player_pix, gameend;
  player p1(clk_d, ps2_clk, ps2_data, pixel_x, pixel_y, player_pix, maze_pix, gameend);
  
  wire finish_pix;
  finish f1(pixel_x, pixel_y, finish_pix);
  
  wire red_pix;
  red_light(pixel_x, pixel_y, red_pix);
  wire green_pix;
  green_light(pixel_x, pixel_y, green_pix);
  
  wire display_red, display_green;
  light_FSM(clk_d,display_red, display_green);
  
  wire up, down, left, right, space;
  Keyboard(clk_d, ps2_clk, ps2_data, up, down, left, right, space); 
  
  wire wonpix;
  wonscreen(pixel_x, pixel_y, wonpix);
  
  wire losspix;
  lossscreen(pixel_x, pixel_y, losspix);
  
  wire oneheart_pix;
  oneheart(pixel_x, pixel_y, oneheart_pix);
  
  wire twoheart_pix;
  twoheart(pixel_x, pixel_y, twoheart_pix);
  
  wire threeheart_pix;
  threeheart(pixel_x, pixel_y, threeheart_pix);
  
  
  always @(posedge clk_d) begin
  if (up == 1 || right == 1 || left == 1 || down == 1) begin //ctrl button not pressed
     move = 1;
  end
  else begin
  move = 0;
  end
  end
  
  wire resett;
  top(display_red,move,clk_d,resett,hearts);
  
  
  always @(posedge clk_d) begin
    if (hearts == 2'b11) begin  // condition for three lives
  displaythree = 1;
  displaytwo = 0;
  displayone = 0;
  end
    else if (hearts == 2'b10) begin  // condition for one life
  displaytwo=0;
  displaythree = 0;
  displayone = 1;
  end 
    else if (hearts == 2'b01) begin  // condition for two lives
  displaythree = 0;
  displaytwo = 1;
  displayone = 0;
  end 
  else if (hearts == 2'b00) begin
  displaythree = 0;
  displaytwo = 0;
  displayone = 0;
  end
  end
  
 
  
  always @(posedge clk_d)
    begin
      //state switches from start to game
      if(space == 1 && state == start)  
    begin
    state = game;
    end
      //state switches from game to gameover
    else if(displayone == 0 && displaytwo == 0 && displaythree == 0 && state == game) begin
    state = gameover;
    end
      //state switches from game to gamewon
    else if(gameend == 1 && state == game)begin
    state = gamewon;
    end
    end
    
    
    
  //For displaying objects on screen through bitmaps and defining colors to them
  
  always @(posedge clk_d)
    begin
      if ((pixel_x <80) || (pixel_x >=560)) begin 
        red <= 4'h0; 
        green <= 4'h0; 
        blue <= 4'h0; 
      end
//      else if (pixel_x == 0) begin
//        red <= 4'h1; 
//        green <= 4'h1; 
//        blue <= 4'h1; 
//      end
      else begin
          if (state == start) begin
            if (s1_pix) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'hF;
            end
            else begin
                red <= 4'hd;
                green <=4'hd;
                blue <= 4'he;
            end
          end  
          else if (state == game) begin     
              if (maze_pix == 1) begin 
                red <= 4'hd;
                green <= 4'hd; 
                blue <= 4'he; 
              end     
              else if (player_pix == 1) begin 
                red <= 4'h0;
                green <= 4'hf; 
                blue <= 4'hf; 
              end 
              else if (finish_pix == 1) begin
                red <= 4'he; 
                green <= 4'hc; 
                blue <= 4'h0;
              end
               else if (red_pix == 1 && display_red) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'h0;
              end
              
              else if (green_pix == 1 && display_green) begin
                red <= 4'h0; 
                green <= 4'hF; 
                blue <= 4'h0;
              end
              
              else if(threeheart_pix==1 && displaythree) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'h0;
              end
              
              else if(twoheart_pix==1 && displaytwo) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'h0;
              end
              
             else if(oneheart_pix==1 && displayone) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'h0;
              end
              else
                begin
                red <= 4'h0;
                green <=4'h3;
                blue <= 4'h5;
              end
          end
           else if (state == gameover) begin
            if (losspix==1) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'hF;
            end
            else begin
                red <= 4'hd;
                green <=4'hd;
                blue <= 4'he;
            end
          end
          else if (state == gamewon) begin
            if (wonpix==1) begin
                red <= 4'hF; 
                green <= 4'h0; 
                blue <= 4'hF;
            end
            else begin
                red <= 4'hd;
                green <=4'hd;
                blue <= 4'he;
            end
          end
      end
     end 
endmodule

 
