// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Sun Apr 14 12:48:05 2019
// Host        : DESKTOP-EKSNGJP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top VRAM -prefix
//               VRAM_ VRAM_stub.v
// Design      : VRAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2017.4" *)
module VRAM(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[15:0],d[11:0],dpra[15:0],clk,we,dpo[11:0]" */;
  input [15:0]a;
  input [11:0]d;
  input [15:0]dpra;
  input clk;
  input we;
  output [11:0]dpo;
endmodule
