`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/12 09:38:27
// Design Name: 
// Module Name: PCU
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


module PCU(
    input wire        clk,
    input wire        rst,
    input wire [11:0] rgb,   //画笔颜色
    input wire [3:0]  dir,   //移动画笔  上下左右
    input wire        draw,  //绘画状态  1-是  0-否
    
    output reg [15:0] paddr, //write address
    output reg [11:0] pdata, //write data
    output reg        we,    //write enable
    output     [7:0]  x,     //画笔位置
    output     [7:0]  y,
    output     [3:0]  direction1//调试用
    );
    localparam  MAX_LENGTH =  256,
                MAX_WIDTH  =  256;
    localparam  up         =  4'b0001,
                down       =  4'b0010,
                left       =  4'b0100,
                right      =  4'b1000,
                left_up    =  4'b0101,
                left_down  =  4'b0110,
                right_up   =  4'b1001,
                right_down =  4'b1010;
    parameter  T_1S       =  100*1000*1000; //100MHz
    parameter  speed      =  5;
    reg [7:0]  temp_x,temp_y;
    reg [31:0] count,count1;  //记录按键长按时间
    //reg [1:0]  flag;   //连续移动标志 2'b10  单击2'b01
    reg        speed_flag;//1S移动5次
    wire[3:0]  move;
    wire[3:0]  direction;
    wire       push_all;

    button  button0(.clk(clk), .rst(rst), .dir(dir[0]), .move(move[0]));
    button  button1(.clk(clk), .rst(rst), .dir(dir[1]), .move(move[1]));
    button  button2(.clk(clk), .rst(rst), .dir(dir[2]), .move(move[2]));
    button  button3(.clk(clk), .rst(rst), .dir(dir[3]), .move(move[3]));
    //检测按键单击还是连按   //最好用状态机实现
    move    i_move(
        .clk(clk),
        .rst(rst),
        .move(move),
        .push_all(push_all),
        .direction(direction)
    );
    assign direction1 = direction;
    always @ (posedge clk or posedge rst) begin
        if(rst == 1'b1) begin
            count1 <= 32'b0;
            speed_flag <= 1'b0;
        end
        else begin
            if(count1 == (T_1S / speed) ) begin
                count1 <= 32'b0;
                speed_flag <= 1'b1;
            end
            else begin
                count1 <= count1 + 1;
                speed_flag <= 1'b0;
            end
        end
    end
    //通过按键检测后 开始移动   将画的颜色写入RAM
    always @ (posedge clk or posedge rst) begin
        if(rst == 1'b1) begin
            temp_x <= 8'd128;
            temp_y <= 8'd128;
            paddr <= 16'b0;
            pdata <= 12'b0;
            we    <= 1'b0;
        end
        else begin
            if(push_all == 1'b1 ) begin  //连续移动
                if(speed_flag == 1'b1) begin
                    case (direction) 
                        up         :  temp_y <= temp_y + 1;
                        down       :  temp_y <= temp_y - 1;
                        left       :  temp_x <= temp_x - 1;
                        right      :  temp_x <= temp_x + 1;
                        left_up    :  begin
                            temp_x <= temp_x - 1;
                            temp_y <= temp_y + 1;
                            end
                        left_down  : begin
                            temp_x <= temp_x - 1;
                            temp_y <= temp_y - 1;
                            end
                        right_up   : begin
                            temp_x <= temp_x + 1;
                            temp_y <= temp_y + 1;
                            end
                        right_down : begin
                            temp_x <= temp_x + 1;
                            temp_y <= temp_y - 1;
                            end
                        default    : begin
                            temp_x <= temp_x;
                            temp_y <= temp_y;
                            end
                    endcase
                end
                else begin
                    temp_x <= temp_x;
                    temp_y <= temp_y;
                end
            end
            else begin
                case (direction) 
                    up         :  temp_y <= temp_y + 1;
                    down       :  temp_y <= temp_y - 1;
                    left       :  temp_x <= temp_x - 1;
                    right      :  temp_x <= temp_x + 1;
                    left_up    :  begin
                        temp_x <= temp_x - 1;
                        temp_y <= temp_y + 1;
                        end
                    left_down  : begin
                        temp_x <= temp_x - 1;
                        temp_y <= temp_y - 1;
                        end
                    right_up   : begin
                        temp_x <= temp_x + 1;
                        temp_y <= temp_y + 1;
                        end
                    right_down : begin
                        temp_x <= temp_x + 1;
                        temp_y <= temp_y - 1;
                        end
                    default    : begin
                        temp_x <= temp_x;
                        temp_y <= temp_y;
                        end
                endcase
           end
           if(draw == 1'b1) begin
              we    <= 1'b1;
              paddr <= {y,x};
              pdata <= rgb;
          end
          else begin
              we    <= 1'b0;
              paddr <= 16'b0;
              pdata <= 12'b0;
          end
       end
    end
    
    //将画的颜色写入RAM
//    always @ (posedge clk or posedge rst) begin
//        if(rst == 1'b1) begin
//            paddr <= 16'b0;
//            pdata <= 12'b0;
//            we    <= 1'b0;
//        end
//        else if(draw == 1'b1) begin
//            we    <= 1'b1;
//            paddr <= {y,x};
//            pdata <= rgb;
//        end
//        else begin
//            we    <= 1'b0;
//            paddr <= 16'b0;
//            pdata <= 12'b0;
//        end
//    end
    
    //限制画笔位置不能超界限
    assign x = (temp_x <= 0) ? 0 : (temp_x >= MAX_LENGTH) ? MAX_LENGTH - 1 : temp_x;
    assign y = (temp_y <= 0) ? 0 : (temp_y >=  MAX_WIDTH) ? MAX_WIDTH - 1  : temp_y;
    
endmodule
