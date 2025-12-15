`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 
*/

module C3_FPUnpackAll (
    input  [  2:0]    i_Compute_Precision    ,
    input  [  2:0]    i_Precision_Addend     ,
    input  [ 19:0]    i_Exception_Handling   ,
	input  [ 31:0]    i_Value1               ,
	input  [ 31:0]    i_Value2               ,

	output [  2:0]    o_Type1                ,
	output            o_Sign1                ,
	output [  7:0]    o_Expo1                ,
	output [ 23:0]    o_Mant1                ,
	output [ 31:0]    o_Value1               ,

	output [  2:0]    o_Type2                ,
	output            o_Sign2                ,
	output [  7:0]    o_Expo2                ,
	output [ 23:0]    o_Mant2                ,
	output [ 31:0]    o_Value2               ,
    output            o_IsBfloat16           ,
    output            o_N                    
);

wire          is_16_bits    ;
wire          is_32_bits    ;
wire          FPCR_EBF      ;
wire [ 5:0]   N             ;

genvar i,j,k;

wire [31:0]     Operand1       ;
wire [31:0]     Operand2       ;
wire [31:0]     Addend         ;
wire [ 2:0]     T_Type1        ;
wire            T_Sign1        ;
wire [ 7:0]     T_Expo1        ;
wire [23:0]     T_Mant1        ;
wire [31:0]     T_Value1       ;
wire [ 2:0]     T_Type2        ;
wire            T_Sign2        ;
wire [ 7:0]     T_Expo2        ;
wire [23:0]     T_Mant2        ;
wire [31:0]     T_Value2       ;
wire [ 2:0]     T_BFType1      ;
wire            T_BFSign1      ;
wire [ 7:0]     T_BFExpo1      ;
wire [23:0]     T_BFMant1      ;
wire [31:0]     T_BFValue1     ;
wire [ 2:0]     T_BFType2      ;
wire            T_BFSign2      ;
wire [ 7:0]     T_BFExpo2      ;
wire [23:0]     T_BFMant2      ;
wire [31:0]     T_BFValue2     ;

assign FPCR_EBF             = (i_Exception_Handling[8] == 1'd1) ? 1'd1 : 1'd0                                 ;
assign o_IsBfloat16         = (i_Compute_Precision == `BF16)                                                  ;
assign o_N                  = (i_Precision_Addend == `FP32) ? 'b1 : 'b0                                       ;
assign Operand1             = i_Value1  ;
assign o_Type1              = T_Type1   ;
assign o_Sign1              = T_Sign1   ;
assign o_Expo1              = T_Expo1   ;
assign o_Mant1              = T_Mant1   ;
assign o_Value1             = T_Value1  ;

assign Operand2             = i_Value2  ;
assign o_Type2              = T_Type2   ;
assign o_Sign2              = T_Sign2   ;
assign o_Expo2              = T_Expo2   ;
assign o_Mant2              = T_Mant2   ;
assign o_Value2             = T_Value2  ;


C3_FPUnpackBase u_FPUnpackBase_Operand1(
    .FP_Number             ( Operand1                       ),
    .i_Compute_Precision   ( i_Compute_Precision            ),
    .i_Exception_Handling  ( i_Exception_Handling           ),
    .o_FPType              ( T_Type1                        ),
    .o_FP_Number_Sign      ( T_Sign1                        ),
    .o_FP_Exponent         ( T_Expo1                        ),
    .o_FP_Mantissa         ( T_Mant1                        ),
    .o_FP_Number_Value     ( T_Value1                       )
);

C3_FPUnpackBase u_FPUnpackBase_Operand2(
    .FP_Number             ( Operand2                       ),
    .i_Compute_Precision   ( i_Compute_Precision            ),
    .i_Exception_Handling  ( i_Exception_Handling           ),
    .o_FPType              ( T_Type2                        ),
    .o_FP_Number_Sign      ( T_Sign2                        ),
    .o_FP_Exponent         ( T_Expo2                        ),
    .o_FP_Mantissa         ( T_Mant2                        ),
    .o_FP_Number_Value     ( T_Value2                       )
);

C3_BFUnpack u_BFUnpack_Operand1(
    .BF_Number          ( Operand1              ),
    .i_BF_Data_Width    ( `BF_Data_Width_16     ),
    .o_BFType           ( T_BFType1             ),
    .o_BF_Number_Sign   ( T_BFSign1             ),
    .o_BF_Mantissa      ( T_BFMant1             ),
    .o_BF_Exponent      ( T_BFExpo1             ),
    .o_BF_Number_Value  ( T_BFValue1            )
);

C3_BFUnpack u_BFUnpack_Operand2(
    .BF_Number          ( Operand2              ),
    .i_BF_Data_Width    ( `BF_Data_Width_16     ),
    .o_BFType           ( T_BFType2             ),
    .o_BF_Number_Sign   ( T_BFSign2             ),
    .o_BF_Mantissa      ( T_BFMant2             ),
    .o_BF_Exponent      ( T_BFExpo2             ),
    .o_BF_Number_Value  ( T_BFValue2            )
);


endmodule
