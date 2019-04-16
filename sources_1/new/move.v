`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/14 22:43:57
// Design Name: 
// Module Name: move
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


module move(
    input wire       clk,
    input wire       rst,
    input wire [3:0] move,
    output reg       push_all,//长按标志
    output reg [3:0] direction
    );
    
    parameter  T_1S       =  100*1000*1000; //100MHz
    parameter  T          =  2;
    localparam  up         =  4'b0001,
                down       =  4'b0010,
                left       =  4'b0100,
                right      =  4'b1000,
                left_up    =  4'b0101,
                left_down  =  4'b0110,
                right_up   =  4'b1001,
                right_down =  4'b1010;
    localparam  INIT       =  2'b00,
                STOP       =  2'b01,
                MOVE       =  2'b10,
                MOVE_ALL   =  2'b11;
    reg [1:0]  state_curr,state_next;
    reg [31:0] count;
    reg [3:0]  move_reg;
    reg        flag;
    reg        move_flag;
    
    always @ (posedge clk or posedge rst) begin
        if(rst == 1'b1) begin
            state_curr <= INIT;
        end
        else begin
            state_curr <= state_next;
        end
    end
    
    always @ (*) begin
        case (state_curr) 
            INIT   : begin
                state_next <= STOP;
                end
            STOP   : begin
                if(move > 4'b0000) begin
                    state_next <= MOVE;
                end
                else begin
                    state_next <= STOP;
                end
                end
            MOVE   : begin
                if(move == 4'b0) begin
                    state_next <= STOP;
                end
                else begin
                    if(flag == 1'b1) begin //连续按
                        state_next <= MOVE_ALL;
                    end
                    else begin
                        state_next <= MOVE;  //
                    end
                end
                end
            MOVE_ALL : begin
                if(move == 4'b0) begin
                    state_next <= STOP;
                end
                else begin  //保持连续按
                    state_next <= state_curr;
                end
                end
            default : begin
                state_next = STOP;
                end
        endcase
    end
    
    always @ (posedge clk) begin
        case (state_curr)
            INIT   : begin
                direction <= 4'b0;
                count     <= 32'b0;
                flag      <= 1'b0;
                move_reg  <= 4'b0;
                push_all  <= 1'b0;
                move_flag <= 1'b0;
                end
            STOP   : begin
                direction <= 4'b0;
                count     <= 32'b0;
                flag      <= 1'b0;
                move_reg  <= 4'b0;
                push_all  <= 1'b0;
                move_flag <= 1'b0;
                end
            MOVE   : begin
                push_all <= 1'b0;
                if(move_flag == 1'b1) begin  //if( (move_reg != move) && (move != 4'b0000) ) begin
                    if( (move_reg != move) && (move != 4'b0000) ) begin
                        move_flag <= 1'b0;
                        //direction <= move;
                        move_reg  <= move;
                    end
                    else begin
                        direction <= 4'b0;
                        move_flag <= 1'b1;
                        move_reg  <= move_reg;
                    end
                end
                else begin
                    move_flag <= 1'b1;
                    case(move)
                        up    : begin
                            direction <= up;
                            move_reg  <= up;
                            end
                        down  : begin
                            direction <= down;
                            move_reg  <= down;
                            end
                        left  : begin
                            direction <= left;
                            move_reg  <= left;
                            end
                        right : begin
                            direction <= right;
                            move_reg  <= right;
                            end
                        left_up : begin
                            direction <= left_up;
                            move_reg  <= left_up;
                            end
                        left_down: begin
                            direction <= left_down;
                            move_reg  <= left_down;
                            end
                        right_up: begin
                            direction <= right_up;
                            move_reg  <= right_up;
                            end
                        right_down: begin
                            direction <= right_down;
                            move_reg  <= right_down;
                            end
                        default   : begin
                            direction <= 4'b0;
                            move_reg  <= 4'b0;
                            move_reg  <= 4'b0;
                            end
                    endcase
      
                end
                if(count >= T * T_1S) begin  //超过2S  长按
                    count <= count;
                    flag  <= 1'b1;
                end
                else begin
                    count <= count + 1;
                    flag  <= 1'b0;
                end
                end
            MOVE_ALL : begin
                direction <= move;
                count     <= 32'b0;
                flag      <= 1'b0;
                push_all  <= 1'b1;
                move_flag <= 1'b1;
                end
            default : begin
                direction <= 4'b0;
                count     <= 32'b0;
                flag      <= 1'b0;
                move_reg  <= 4'b0;
                push_all  <= 1'b0;
                move_flag <= 1'b0;
                end
        endcase 
    end
    
endmodule
