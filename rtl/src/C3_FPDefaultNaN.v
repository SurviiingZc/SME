`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C3_FPDefaultNaN (
    input              i_FPCR_AH    ,
    input              i_Data_Width , // 0 -> 16   1 -> 32
    output [31:0]      o_DefaultNaN 
);

wire Sign;

assign Sign         = ((`FEAT_AFP == 1'd1) & ~(`AArch32)) ? i_FPCR_AH : 1'd0   ;
assign o_DefaultNaN = (i_Data_Width == 1'd0) ? {16'd0,Sign,{5{1'd1}},{1'd1,{9{1'd0}}}} : {Sign,{8{1'd1}},{1'd1,{22{1'd0}}}} ;

endmodule