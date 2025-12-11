`timescale 1ns / 1ps

module Compressor_3_2(i0,i1,ci,co,d);

input wire i0   ;
input wire i1   ;
input wire ci   ;
output wire co  ;
output wire d   ;

wire i0_nand_i1     ;
wire AOI_o1         ;
wire xor_o1         ;
wire xoro1_nand_ci  ;
wire AOI_o2         ;

assign i0_nand_i1       = ~(i0 & i1);

assign AOI_o1           = ~((i0 & i0_nand_i1) | (i1 & i0_nand_i1));

assign xor_o1           = ~AOI_o1;

assign xoro1_nand_ci    = ~(ci & xor_o1);

assign AOI_o2           = ~((xoro1_nand_ci & xor_o1) | (xoro1_nand_ci & ci));

assign d                = ~AOI_o2;

assign co               = ~(xoro1_nand_ci & i0_nand_i1);


endmodule