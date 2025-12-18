`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C3_FPProcessNaN (
    input           i_FPCR_AH     ,
    input           i_FPCR_DN     ,
    input           i_Data_Width  , // 0 -> 16   1 -> 32
    input  [ 2:0]   i_Type        ,
    input  [31:0]   i_FPNumber    ,
    output [31:0]   o_FP_NaN      
);

wire        is_QNaN     ;
wire        is_SNaN     ;
wire [31:0] Para_16     ;
wire [31:0] Para_32     ;
wire [31:0] Para_FP     ;
wire [31:0] FP_Value    ;
wire [31:0] FP_DNaN     ;


assign Para_16      = {i_FPNumber[31:10],1'd1,i_FPNumber[8:0]}          ;
assign Para_32      = {i_FPNumber[31:23],1'd1,i_FPNumber[21:0]}         ;
assign Para_FP      = (i_Data_Width == 1'd0) ? Para_16 : Para_32        ;
assign is_QNaN      = (i_Type == `FPType_QNaN) ? 1'd1 : 1'd0            ;
assign is_SNaN      = (i_Type == `FPType_SNaN) ? 1'd1 : 1'd0            ;
assign FP_Value     = (i_Type == `FPType_SNaN) ? Para_FP : i_FPNumber   ;
assign o_FP_NaN     = (i_FPCR_DN == 1'd1) ? FP_DNaN : FP_Value          ;

C3_FPDefaultNaN u_FPDefaultNaN(
    .i_FPCR_AH     ( i_FPCR_AH     ),
    .i_Data_Width  ( i_Data_Width  ),
    .o_DefaultNaN  ( FP_DNaN       )
);

endmodule