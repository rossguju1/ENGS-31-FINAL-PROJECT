// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3.1 (win64) Build 2035080 Fri Oct 20 14:20:01 MDT 2017
// Date        : Tue May 29 16:07:37 2018
// Host        : MECHA-7 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               o:/Documents/GameOfLifeDisplay/GameOfLifeDisplay.srcs/sources_1/ip/old_state_RAM/old_state_RAM_stub.v
// Design      : old_state_RAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_0,Vivado 2017.3.1" *)
module old_state_RAM(clka, rsta, ena, wea, addra, dina, douta, clkb, rstb, enb, 
  web, addrb, dinb, doutb, rsta_busy, rstb_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,ena,wea[0:0],addra[12:0],dina[0:0],douta[0:0],clkb,rstb,enb,web[0:0],addrb[12:0],dinb[0:0],doutb[0:0],rsta_busy,rstb_busy" */;
  input clka;
  input rsta;
  input ena;
  input [0:0]wea;
  input [12:0]addra;
  input [0:0]dina;
  output [0:0]douta;
  input clkb;
  input rstb;
  input enb;
  input [0:0]web;
  input [12:0]addrb;
  input [0:0]dinb;
  output [0:0]doutb;
  output rsta_busy;
  output rstb_busy;
endmodule
