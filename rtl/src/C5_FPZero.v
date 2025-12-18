`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 
    
*/

module C5_FPZero (
    input           i_Sign          ,
    input           i_DiffSign_Zero ,
    input           i_Widening_SBF  ,
    input  [ 1:0]   i_FPCR_RMode    ,
    input           i_Data_Width    , // 0 -> 16   1 -> 32
    output [31:0]   o_FPZero
);

wire  [31:0] FP16_Zero;
wire  [31:0] FP32_Zero;
wire  [31:0] BF32_Zero;

assign FP16_Zero = (i_DiffSign_Zero == 1'd0) ? {16'd0,i_Sign,{5{1'd0}},{10{1'd0}}} :
                    (i_FPCR_RMode == `Round_Towards_Minus_Infinity) ? {16'd0,1'd1,{5{1'd0}},{10{1'd0}}} : {16'd0,1'd0,{5{1'd0}},{10{1'd0}}};
assign FP32_Zero = (i_DiffSign_Zero == 1'd0) ? {i_Sign,{8{1'd0}},{23{1'd0}}} :
                    (i_FPCR_RMode == `Round_Towards_Minus_Infinity) ? {1'd1,{8{1'd0}},{23{1'd0}}} : {1'd0,{8{1'd0}},{23{1'd0}}};

assign BF32_Zero = {1'd0,{8{1'd0}},{23{1'd0}}};

assign o_FPZero = (i_Data_Width == 1'd0) ? FP16_Zero : 
                    i_Widening_SBF ? BF32_Zero : FP32_Zero    ; 

endmodule