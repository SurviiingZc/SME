`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

/*
    Function    : 
    Description : 
*/

module C1_FPMultiplyComb (
    input                i_Compute_Mode         ,
    input      [ 2:0]    i_Compute_Precision    ,
    input                i_Is_Widening          ,
    input                i_Add_or_Subtract      ,
    input                i_ZmIsSigned           ,
    input                i_ZnIsSigned           ,
    input                i_Num_of_Vector_Group  ,
    input      [  1:0]   i_Vector_Group_Num     ,
    input      [ 19:0]   i_Exception_Handling   ,
    input      [ 31:0]   i_ZA_Base_Address      ,
    input      [ 3:0]    i_Active_Element_A     ,
    input      [ 3:0]    i_Active_Element_B     ,
    input      [ 31:0]   i_Operand_A            ,
    input      [ 31:0]   i_Operand_B            ,
    input      [127:0]   i_Operand_C            ,
    output     [  2:0]   o_Precision_Addend     ,
    output     [191:0]   o_Mant                 ,
    output     [127:0]   o_Result               ,
    output     [  3:0]   o_OutSign              ,
    output     [ 35:0]   o_OutExpo              ,
    output               o_IsBfloat16           ,
    output               o_N                    ,
    output     [ 11:0]   o_TypeA                ,
    output     [  3:0]   o_SignA                ,
    output     [ 31:0]   o_ExpoA                ,
    output     [  3:0]   o_Is_Exception         ,
    output     [ 95:0]   o_MantA                ,
    output               o_Keep_Expo_signed     ,
    output               o_Internal_Acc
);

wire [ 11:0]    T_TypeA                ;
wire [  3:0]    T_SignA                ;
// wire [ 31:0]    T_ExpoA                ;
// wire [ 95:0]    T_MantA                ;
wire [127:0]    T_ValueA               ;
wire [  5:0]    T_Type1                ;
wire [  1:0]    T_Sign1                ;
wire [ 15:0]    T_Expo1                ;
wire [ 47:0]    T_Mant1                ;
wire [ 63:0]    T_Value1               ;
wire [  2:0]    T_Precision_Operand1   ;
wire [  5:0]    T_Type2                ;
wire [  1:0]    T_Sign2                ;
wire [ 15:0]    T_Expo2                ;
wire [ 47:0]    T_Mant2                ;
wire [ 63:0]    T_Value2               ;
wire [  2:0]    T_Precision_Operand2   ;

C1_FPUnpackAll u_FPUnpackAll(
    .i_Compute_Mode        ( i_Compute_Mode        ),
    .i_Compute_Precision   ( i_Compute_Precision   ),
    .i_Is_Widening         ( i_Is_Widening         ),
    .i_Vector_Group_Num    ( i_Vector_Group_Num    ),
    .i_Exception_Handling  ( i_Exception_Handling  ),
    .i_Operand_A           ( i_Operand_A           ),
    .i_Operand_B           ( i_Operand_B           ),
    .i_Operand_C           ( i_Operand_C           ),
    .o_TypeA               ( o_TypeA               ),
    .o_SignA               ( o_SignA               ),
    .o_ExpoA               ( o_ExpoA               ),
    .o_MantA               ( o_MantA               ),
    .o_ValueA              ( T_ValueA              ),
    .o_Precision_Addend    ( o_Precision_Addend    ),
    .o_Type1               ( T_Type1               ),
    .o_Sign1               ( T_Sign1               ),
    .o_Expo1               ( T_Expo1               ),
    .o_Mant1               ( T_Mant1               ),
    .o_Value1              ( T_Value1              ),
    .o_Precision_Operand1  ( T_Precision_Operand1  ),
    .o_Type2               ( T_Type2               ),
    .o_Sign2               ( T_Sign2               ),
    .o_Expo2               ( T_Expo2               ),
    .o_Mant2               ( T_Mant2               ),
    .o_Value2              ( T_Value2              ),
    .o_Precision_Operand2  ( T_Precision_Operand2  ),
    .o_OutSign             ( o_OutSign             ),
    .o_OutExpo             ( o_OutExpo             ),
    .o_IsBfloat16          ( o_IsBfloat16          ),
    .o_N                   ( o_N                   )
);

C1_ExceptionHandling u_ExceptionHandling(
    .i_Operand_A           ( i_Operand_A           ),
    .i_Operand_B           ( i_Operand_B           ),
    .i_Operand_C           ( i_Operand_C           ),
    .i_TypeA               ( o_TypeA               ),
    .i_SignA               ( o_SignA               ),
    .i_Precision_Addend    ( o_Precision_Addend    ),
    .i_Type1               ( T_Type1               ),
    .i_Sign1               ( T_Sign1               ),
    .i_Type2               ( T_Type2               ),
    .i_Sign2               ( T_Sign2               ),
    .i_Compute_Mode        ( i_Compute_Mode        ),
    .i_Is_Widening         ( i_Is_Widening         ),
    .i_Vector_Group_Num    ( i_Vector_Group_Num    ),
    .i_Compute_Precision   ( i_Compute_Precision   ),
    .i_Exception_Handling  ( i_Exception_Handling  ),
    .o_Is_Exception        ( o_Is_Exception        ),
    .o_Result              ( o_Result              ),
    .o_Keep_Expo_signed    ( o_Keep_Expo_signed    ),
    .o_Internal_Acc        ( o_Internal_Acc        )
);

C1_FPMutiArray u_FPMutiArray(
    .i_Compute_Precision  ( i_Compute_Precision  ),
    .i_Operand_A          ( i_Operand_A          ),
    .i_Operand_B          ( i_Operand_B          ),
    .o_Mant               ( o_Mant               )
);

endmodule
