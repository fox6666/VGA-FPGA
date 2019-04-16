`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/12 17:14:59
// Design Name: 
// Module Name: top
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


module top(
    input wire        clk,
    input wire        rst,
    input wire [11:0] rgb,  //画笔颜色
    input wire [3:0]  dir,  //移动画笔  上下左右
    input wire        draw, //绘画状态  1-是  0-否
    
    output     [11:0] vrgb, //像素点颜色信号
    output            hs,   //行同步信号
    output            vs,   //场同步信号
    output     [3:0]  direction//调试用
    );
    
    wire [15:0] paddr; //write address
    wire [11:0] pdata; //write data
    wire        we;    //write enable
    wire [7:0]  x,y;   //画笔位置 
    wire [11:0] vdata;
    wire [15:0] vaddr;
    
    
    PCU  i_PCU(
        .clk(clk),
        .rst(rst),
        .rgb(rgb),
        .dir(dir),
        .draw(draw),
        
        .paddr(paddr),
        .pdata(pdata),
        .we(we),
        .x(x),
        .y(y),
        .direction1(direction)
    );
    
    VRAM  i_VRAM(
        .a(paddr),
        .d(pdata),
        .dpra(vaddr),
        .clk(clk),
        .we(we),
        .dpo(vdata)
    );
    
    DCU  i_DCU(
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .vdata(vdata),
        .vaddr(vaddr),
        .vrgb(vrgb),
        .hs(hs),
        .vs(vs)
    );
    
endmodule
