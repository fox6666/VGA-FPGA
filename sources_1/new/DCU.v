`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/12 09:45:15
// Design Name: 
// Module Name: DCU
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


module DCU(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  x,     //画笔位置
    input  wire [7:0]  y,
    input  wire [11:0] vdata,
    output reg  [15:0] vaddr,
                              //显示器接口信号
    output reg  [11:0] vrgb, //像素点颜色信号
    output              hs,   //行同步信号
    output              vs    //场同步信号
    );
    wire        clk_75M;
    reg  [10:0] h_count;
    reg  [9:0]  v_count;
    wire        active_flag;
    wire [10:0] addr_low;
    wire [9:0]  addr_high;
    
    //1024*768 @70Hz, 75MHz像素时钟(pclk) 
    //行时序 参数
    parameter   H_SYNC_PULSE    =  136 ,  //行同步
                 H_BACK_PORCH    =  144  ,  //行消隐
                 H_ACTIVE_TIME   =  1024 ,  //行视频有效
                 H_FRONT_PORCH   =  24  ,  //行前肩
                 H_LINE_PERIOD   =  1328;  //行周期
    //场时序 参数
    parameter   V_SYNC_PULSE    =  6   ,  //场同步
                 V_BACK_PORCH    =  29  ,  //场消隐
                 V_ACTIVE_TIME   =  768 ,  //场视频有效
                 V_FRONT_PORCH   =  3   ,  //场前肩
                 V_FRAME_PERIOD  =  806 ;  //场/帧周期
    //中间256*256区域
    parameter   X_SIZE  = 256,
                 Y_SIZE  = 256,
                 UP      = (V_ACTIVE_TIME - Y_SIZE) / 2 - 1 + V_SYNC_PULSE + V_BACK_PORCH,
                 DOWN    = (V_ACTIVE_TIME + Y_SIZE) / 2 - 2 + V_SYNC_PULSE + V_BACK_PORCH,
                 LEFT    = (H_ACTIVE_TIME - X_SIZE) / 2 - 1 + H_SYNC_PULSE + H_BACK_PORCH,
                 RIGHT   = (H_ACTIVE_TIME + X_SIZE) / 2 - 2 + H_SYNC_PULSE + H_BACK_PORCH;
    parameter   LENGTH  = 3,
                 WIDTH   = 1;
    //产生75MHz像素时钟
    clk_wiz_1   i_clk_wiz_1_clk_wiz(
        .clk_in1(clk),
        .reset(rst),
        .clk_75M(clk_75M)
    );
   
    //产生行时序
    always @ (posedge clk_75M or posedge rst) begin
        if(rst) 
            h_count <= 11'b0;
        else begin
            if(h_count == H_LINE_PERIOD - 1)
                h_count <= 11'b0;
            else 
                h_count <= h_count + 1;
        end
    end
    assign hs   = (h_count < H_SYNC_PULSE) ? 1'b0 : 1'b1;
    assign addr_low = h_count - LEFT;
   
    //产生列时序
    always @ (posedge clk_75M or posedge rst) begin
       if(rst) 
           v_count <= 10'b0;
       else begin
           if(h_count == H_LINE_PERIOD - 1) begin//扫描一行
                if(v_count == V_FRAME_PERIOD - 1)
                    v_count <= 10'b0;
                else 
                    v_count <= v_count + 1;
           end
           else
                v_count <= v_count;
        end
    end
//    if(v_count == V_FRAME_PERIOD - 1)
//       v_count <= 10'b0;
//    else if(h_count == H_LINE_PERIOD - 1) //扫描一行
//       v_count <= v_count + 1'b1;
//    else 
//       v_count <= v_count;
    assign vs = (v_count < V_SYNC_PULSE) ? 1'b0 : 1'b1;
    assign addr_high = v_count - UP;
    
    //产生有效区域标志，为高时才把RGB数据发送到显示屏幕上   
    //assign active_flag = ( h_count >= (H_SYNC_PULSE + H_BACK_PORCH) ) && ( h_count <= (H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_TIME) ) &&
    //                     ( v_count >= (V_SYNC_PULSE + V_BACK_PORCH) ) && ( v_count <= (V_SYNC_PULSE + V_BACK_PORCH + V_ACTIVE_TIME) );
    assign active_flag = ( v_count >= UP ) && ( v_count <= DOWN ) && ( h_count >= LEFT ) && ( h_count <= RIGHT );
    
    //从RAM中获取RGB数据 并发送给屏幕显示
    always @ (posedge clk_75M or posedge rst) begin
        if(rst == 1'b1) begin
            vaddr <= 16'b0;
            vrgb  <= 12'b0;
        end
        else begin
            if(active_flag == 1'b1) begin
                if((v_count - UP >= y - LENGTH + 1) && (v_count - UP <= y + LENGTH - 1) && (h_count - LEFT >= x - WIDTH + 1) && (h_count - LEFT <= x + WIDTH - 1) ||
                   (h_count - LEFT >= x - LENGTH + 1) && (h_count - LEFT <= x + LENGTH - 1) && (v_count - UP >= y - WIDTH + 1) && (v_count - UP <= y + WIDTH - 1)  )begin
                    vrgb  <= 12'hFFF;  //十字光标
                    vaddr <= {addr_high[7:0],addr_low[7:0]};
                end
                else begin
                    vrgb  <= vdata;
                    vaddr <= {addr_high[7:0],addr_low[7:0]};
                end
            end 
            else  begin
                vrgb <= 12'b0;
                vaddr <= 16'b0;
            end
        end
    end
    
    //
endmodule
