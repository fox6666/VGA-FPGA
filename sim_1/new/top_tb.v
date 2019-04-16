`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/13 14:11:44
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb(

    );
    reg        clk,rst;
    reg [11:0] rgb;
    reg [3:0]  dir;
    reg        draw;
    wire[11:0] vrgb;
    wire       hs,vs;
    
    initial  begin
        clk  = 1;
        rst  = 1;
        draw = 0;
        rgb  = 12'h0;
        dir  = 4'h0;
        #5 ;
        rst = 0;
        #2 ;
        rgb  = 12'h111;
        dir  = 4'b0001;
        draw = 0;
        #30 ;
        rgb  = 12'h152;
        dir  = 4'b0010;
        draw = 1;
        #70 ;
        rgb  = 12'h143;
        dir  = 4'b0000;
        draw = 0;
        #100 ;
        rgb  = 12'h743;
        dir  = 4'b1010;
        draw = 1;
        #600 ;
        dir  = 4'b1001;
        rgb  = 12'h768;
        #900;
        dir = 4'b0001;
    end
    always #(1) clk = ~clk;
    
    top   i_top(
        .clk(clk),
        .rst(rst),
        .rgb(rgb),
        .dir(dir),
        .draw(draw),
        .vrgb(vrgb),
        .hs(hs),
        .vs(vs)
    );
endmodule
