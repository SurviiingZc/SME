`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C5_FPProcessNaNs (
    input                 i_FPCR_AH       ,
    input                 i_FPCR_DN       ,
    input       [  5:0]   i_Type          ,
    input       [  1:0]   i_Data_Width    ,
    input       [ 63:0]   i_FPNumber      ,
    output reg  [ 31:0]   o_FP_Result     ,
    output reg            o_Done
);

wire          ALTFP             ;
wire          Op1_NaN           ;
wire          Op2_NaN           ;
wire [ 2:0]   i_Type_1          ;
wire          i_Data_Width_1    ; // 0 -> 16   1 -> 32
wire [31:0]   i_FPNumber_1      ;
wire [ 2:0]   i_Type_2          ;
wire          i_Data_Width_2    ; // 0 -> 16   1 -> 32
wire [31:0]   i_FPNumber_2      ;
wire          Any_SNaN          ;
wire [31:0]   T_FP_NaN_1        ;
wire [31:0]   T_FP_NaN_2        ;

assign i_Type_1       = i_Type       [2:0]      ;
assign i_Data_Width_1 = i_Data_Width [0]        ;
assign i_FPNumber_1   = i_FPNumber   [31:0]     ;
assign i_Type_2       = i_Type       [5:3]      ;
assign i_Data_Width_2 = i_Data_Width [1]        ;
assign i_FPNumber_2   = i_FPNumber   [63:32]    ;

assign ALTFP        = (`FEAT_AFP == 1'd1) & (i_FPCR_AH == 1'd1)                       ; 
assign Op1_NaN      = ((i_Type_1 == `FPType_QNaN) | (i_Type_1 == `FPType_SNaN))       ;
assign Op2_NaN      = ((i_Type_2 == `FPType_QNaN) | (i_Type_2 == `FPType_SNaN))       ;
assign Any_SNaN     = ((i_Type_1 == `FPType_SNaN) | (i_Type_2 == `FPType_SNaN))       ;
assign o_Done       = ((ALTFP & Op1_NaN & Op2_NaN) | Op1_NaN | Op2_NaN) ? 1'd1 : 1'd0 ;
assign o_FP_Result  = {32{ALTFP & Op1_NaN & Op2_NaN}} & T_FP_NaN_1 |
                        {32{i_Type_1 == `FPType_SNaN}} & T_FP_NaN_1 |
                        {32{i_Type_2 == `FPType_SNaN}} & T_FP_NaN_2 |
                        {32{i_Type_1 == `FPType_QNaN}} & T_FP_NaN_1 | 
                        {32{i_Type_2 == `FPType_QNaN}} & T_FP_NaN_2 ;



C5_FPProcessNaN u_FPProcessNaN_OP1(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_1 ),
    .i_Type         ( i_Type_1       ),
    .i_FPNumber     ( i_FPNumber_1   ),
    .o_FP_NaN       ( T_FP_NaN_1     )
);

C5_FPProcessNaN u_FPProcessNaN_OP2(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_2 ),
    .i_Type         ( i_Type_2       ),
    .i_FPNumber     ( i_FPNumber_2   ),
    .o_FP_NaN       ( T_FP_NaN_2     )
);


endmodule