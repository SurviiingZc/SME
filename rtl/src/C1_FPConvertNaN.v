`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C1_FPConvertNaN (
    input           i_In_Data_Width      , // 0 -> 16   1 -> 32
    input           i_Output_Data_Width  , // 0 -> 16   1 -> 32
    input  [31:0]   i_FPNumber           ,
    output [31:0]   o_FP_QNaN     
);

wire        FP_Sign    ;
wire [21:0] FP_Frac    ;
wire [31:0] FP16_Frac  ;
wire [31:0] FP32_Frac  ;

assign FP_Sign      = (i_In_Data_Width == 1'd1) ? i_FPNumber[31] : i_FPNumber[15]            ;
assign FP_Frac      = (i_In_Data_Width == 1'd1) ? i_FPNumber[21:0] : {i_FPNumber[8:0],13'd0} ;
assign FP16_Frac    = {16'd0,FP_Sign,6'b111111,FP_Frac[21:13]}                               ;
assign FP32_Frac    = {FP_Sign,9'b111111111,FP_Frac[21:0]}                                   ;
assign o_FP_QNaN    = (i_Output_Data_Width == 1'd1) ? FP32_Frac : FP16_Frac                  ;

endmodule