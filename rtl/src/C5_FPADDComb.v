`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C5_FPADDComb(
    input             i_Compute_Mode         ,
    input             i_Is_Widening          ,
    input             i_Add_or_Subtract      ,
    input  [  1:0]    i_Vector_Group_Num     ,
    input  [  2:0]    i_Precision_Addend     ,
    input  [  2:0]    i_Compute_Precision    ,
    input  [ 19:0]    i_Exception_Handling   ,
	input  [ 31:0]    i_Value1               ,
	input  [ 31:0]    i_Value2               , 

    input             i_FuseAdd_SelfAdd      ,
    input             i_Temp_Sign1           ,
    input             i_Temp_Sign2           ,
    input  [  9:0]    i_Temp_Expo1           ,
    input  [  9:0]    i_Temp_Expo2           ,
    input  [ 47:0]    i_Temp_Mant1           ,
    input  [ 47:0]    i_Temp_Mant2           ,
    input             i_sticky_bit           ,
    output            o_Temp_Sign            ,
    output [  9:0]    o_Temp_Expo            ,
    output [ 72:0]    o_Temp_Mant            ,

    output [ 47:0]    o_Mant                 ,
    output [ 31:0]    o_Fault_Result         ,
    output            o_IsBfloat16           ,
    output            o_N                    ,
	output [  9:0]	  o_Sum_Expo		     ,
	output      	  o_Sum_Sign		     ,
    output      	  o_is_Exception         ,
    output            o_Sticky_Bit          
);

wire [  2:0]    T_Type1                ;
wire            T_Sign1                ;
wire [  7:0]    T_Expo1                ;
wire [ 23:0]    T_Mant1                ;
wire [  2:0]    T_Type2                ;
wire            T_Sign2                ;
wire [  7:0]    T_Expo2                ;
wire [ 23:0]    T_Mant2                ;


C5_FPUnpackAll u_FPUnpackAll(
    .i_Compute_Precision   ( i_Compute_Precision   ),
    .i_Precision_Addend    ( i_Precision_Addend    ),
    .i_Exception_Handling  ( i_Exception_Handling  ),
    .i_Value1              ( i_Value1              ),
    .i_Value2              ( i_Value2              ),
    .o_Type1               ( T_Type1               ),
    .o_Sign1               ( T_Sign1               ),
    .o_Expo1               ( T_Expo1               ),
    .o_Mant1               ( T_Mant1               ),
    .o_Value1              (                       ),
    .o_Type2               ( T_Type2               ),
    .o_Sign2               ( T_Sign2               ),
    .o_Expo2               ( T_Expo2               ),
    .o_Mant2               ( T_Mant2               ),
    .o_Value2              (                       ),
    .o_IsBfloat16          ( o_IsBfloat16          ),
    .o_N                   ( o_N                   ) 
);

C5_ExceptionHandling u_ExceptionHandling(
    .i_Type1               ( T_Type1               ),
    .i_Sign1               ( T_Sign1               ),
    .i_Type2               ( T_Type2               ),
    .i_Sign2               ( T_Sign2               ),
    .i_Compute_Mode        ( i_Compute_Mode        ),
    .i_Is_Widening         ( i_Is_Widening         ),
    .i_Vector_Group_Num    ( i_Vector_Group_Num    ),
    .i_Compute_Precision   ( i_Compute_Precision   ),
    .i_Exception_Handling  ( i_Exception_Handling  ),
    .o_Result              ( o_Fault_Result        ),
    .o_is_Exception        ( o_is_Exception        )
);

C5_FPAddition u_C5_FPAddition(
    .i_Sign1                ( T_Sign1               ),
    .i_Expo1                ( T_Expo1               ),
    .i_Mant1                ( T_Mant1               ),
    .i_Sign2                ( T_Sign2               ),
    .i_Expo2                ( T_Expo2               ),
    .i_Mant2                ( T_Mant2               ),
    .i_Exception_Handling   ( i_Exception_Handling  ),
    .i_Add_or_Subtract      ( i_Add_or_Subtract     ),
    .i_FuseAdd_SelfAdd      ( i_FuseAdd_SelfAdd     ),
    .i_Temp_Sign1           ( i_Temp_Sign1          ),
    .i_Temp_Sign2           ( i_Temp_Sign2          ),
    .i_Temp_Expo1           ( i_Temp_Expo1          ),
    .i_Temp_Expo2           ( i_Temp_Expo2          ),
    .i_Temp_Mant1           ( i_Temp_Mant1          ),
    .i_Temp_Mant2           ( i_Temp_Mant2          ),
    .i_sticky_bit           ( i_sticky_bit          ),
    .o_Temp_Sign            ( o_Temp_Sign           ),
    .o_Temp_Expo            ( o_Temp_Expo           ),
    .o_Temp_Mant            ( o_Temp_Mant           ),
    .o_Sum_Mant             ( o_Mant                ),
    .o_Sum_Expo             ( o_Sum_Expo            ),
    .o_Sum_Sign             ( o_Sum_Sign            ),
    .o_Sticky_Bit           ( o_Sticky_Bit          )
);


endmodule