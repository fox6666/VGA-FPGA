`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/14 17:00:19
// Design Name: 
// Module Name: button
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

//检测按键  消抖
module button(
    input wire       clk,
    input wire       rst,
    input wire       dir,
    output reg       move
    );
    
    parameter cnt = 18'd25_0000;
    reg [17:0] count ;    
    always @ (posedge clk or posedge rst or negedge dir) begin
        if(rst == 1'b1 || dir == 1'b0 ) begin
            count <= 18'b0;
        end
        else begin
            if(count == cnt) 
                count <= 18'd0;
            else begin
                if(dir == 1'b1)
                   count <= count + 18'd1;
                else 
                   count <= 18'd0;
            end   
        end
    end
    always @ (posedge clk or posedge rst or negedge dir) begin
        if(rst == 1'b1 || dir == 1'b0)  //只有松开后 move变为0 or negedge dir
            move <= 1'b0;
        else begin
            if(count == cnt)
                move <= 1'b1;
            else 
                move <= move;
        end
    end   
endmodule
