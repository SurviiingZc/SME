`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Pipline_2 (
        clk                    ,
        rst_n                  ,
        i_Compute_Mode         ,
        i_Compute_Precision    ,
        i_Is_Widening          ,
        i_Add_or_Subtract      ,
        i_ZmIsSigned           ,
        i_ZnIsSigned           ,
        i_Num_of_Vector_Group  ,
        i_Vector_Group_Num     ,
        i_Exception_Handling   ,
        i_ZA_Base_Address      ,
        i_Operand_C            ,
        i_Precision_Addend     ,
        i_Rounded_result       ,
        i_FuseAdd_SelfAdd      ,
        i_Temp_Sign1           ,
        i_Temp_Sign2           ,
        i_Temp_Expo1           ,
        i_Temp_Expo2           ,
        i_Temp_Mant1           ,
        i_Temp_Mant2           ,
        i_Normal_Sign          ,
        i_Normal_Exp           ,
        i_Normal_Mantissa      ,
        i_is_int_op            ,
        i_TypeA                ,
        i_SignA                ,
        i_ExpoA                ,
        i_MantA                , 
        i_Is_Exception         ,
        i_Result               ,
        i_Sticky_Flag          ,
        i_Internal_Acc         ,
        i_Keep_Expo_signed     ,
        o_Keep_Expo_signed     ,
        o_Internal_Acc         ,
        o_Sticky_Flag          ,
        o_Result               ,
        o_Is_Exception         ,
        o_Compute_Mode         ,
        o_Compute_Precision    ,
        o_Is_Widening          ,
        o_Add_or_Subtract      ,
        o_ZmIsSigned           ,
        o_ZnIsSigned           ,
        o_Num_of_Vector_Group  ,
        o_Vector_Group_Num     ,
        o_Exception_Handling   ,
        o_ZA_Base_Address      ,
        o_Operand_C            ,
        o_Precision_Addend     ,
        o_Rounded_result       ,
        o_FuseAdd_SelfAdd      ,
        o_Temp_Sign1           ,
        o_Temp_Sign2           ,
        o_Temp_Expo1           ,
        o_Temp_Expo2           ,
        o_Temp_Mant1           ,
        o_Temp_Mant2           ,
        o_Normal_Sign          ,
        o_Normal_Exp           ,
        o_Normal_Mantissa      ,
        o_TypeA                ,
        o_SignA                ,
        o_ExpoA                ,
        o_MantA                
);

`ifdef Is_PipLine

input                 clk                     ;
input                 rst_n                   ;
input       [ 2:0]    i_Precision_Addend      ;
input       [127:0]   i_Rounded_result        ;
input                 i_Compute_Mode          ;
input       [ 2:0]    i_Compute_Precision     ;
input                 i_Is_Widening           ;
input                 i_Add_or_Subtract       ;
input                 i_ZmIsSigned            ;
input                 i_ZnIsSigned            ;
input                 i_Num_of_Vector_Group   ;
input       [  1:0]   i_Vector_Group_Num      ;
input       [ 19:0]   i_Exception_Handling    ;
input       [ 31:0]   i_ZA_Base_Address       ;
input       [127:0]   i_Operand_C             ;
input                 i_FuseAdd_SelfAdd       ;
input                 i_Temp_Sign1            ;
input                 i_Temp_Sign2            ;
input      [  9:0]    i_Temp_Expo1            ;
input      [  9:0]    i_Temp_Expo2            ;
input      [ 47:0]    i_Temp_Mant1            ;
input      [ 47:0]    i_Temp_Mant2            ;
input      [  3:0]    i_Normal_Sign           ;
input      [ 39:0]    i_Normal_Exp            ;
input      [191:0]    i_Normal_Mantissa       ;
input                 i_is_int_op             ;
input       [ 11:0]   i_TypeA                 ;
input       [  3:0]   i_SignA                 ;
input       [ 31:0]   i_ExpoA                 ;
input       [ 95:0]   i_MantA                 ;
input       [  3:0]   i_Is_Exception          ;
input       [127:0]   i_Result                ;
input       [  3:0]   i_Sticky_Flag           ;
input                 i_Internal_Acc          ;
input                 i_Keep_Expo_signed      ;
output reg            o_Keep_Expo_signed      ;
output reg            o_Internal_Acc          ;
output reg  [  3:0]   o_Sticky_Flag           ;
output reg  [127:0]   o_Result                ;
output reg  [  3:0]   o_Is_Exception          ;
output reg            o_Compute_Mode          ;
output reg  [ 2:0]    o_Compute_Precision     ;
output reg            o_Is_Widening           ;
output reg            o_Add_or_Subtract       ;
output reg            o_ZmIsSigned            ;
output reg            o_ZnIsSigned            ;
output reg            o_Num_of_Vector_Group   ;
output reg  [  1:0]   o_Vector_Group_Num      ;
output reg  [ 19:0]   o_Exception_Handling    ;
output reg  [ 31:0]   o_ZA_Base_Address       ;
output reg  [127:0]   o_Operand_C             ;
output reg  [127:0]   o_Rounded_result        ;
output reg  [ 2:0]    o_Precision_Addend      ;
output reg            o_FuseAdd_SelfAdd       ;
output reg            o_Temp_Sign1            ;
output reg            o_Temp_Sign2            ;
output reg [  9:0]    o_Temp_Expo1            ;
output reg [  9:0]    o_Temp_Expo2            ;
output reg [ 47:0]    o_Temp_Mant1            ;
output reg [ 47:0]    o_Temp_Mant2            ;
output reg [  3:0]    o_Normal_Sign           ;
output reg [ 39:0]    o_Normal_Exp            ;
output reg [191:0]    o_Normal_Mantissa       ;
output reg [ 11:0]    o_TypeA                 ;
output reg [  3:0]    o_SignA                 ;
output reg [ 31:0]    o_ExpoA                 ;
output reg [ 95:0]    o_MantA                 ;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_Compute_Mode        <= 'd0 ;
        o_Compute_Precision   <= 'd0 ;
        o_Is_Widening         <= 'd0 ;
        o_Add_or_Subtract     <= 'd0 ;
        o_ZmIsSigned          <= 'd0 ;
        o_ZnIsSigned          <= 'd0 ;
        o_Num_of_Vector_Group <= 'd0 ;
        o_Vector_Group_Num    <= 'd0 ;
        o_Exception_Handling  <= 'd0 ;
        o_ZA_Base_Address     <= 'd0 ;
        o_Operand_C           <= 'd0 ;
        o_Rounded_result      <= 'd0 ;
        o_Precision_Addend    <= 'd0 ;
        o_FuseAdd_SelfAdd     <= 'd0 ;
        o_Temp_Sign1          <= 'd0 ;
        o_Temp_Sign2          <= 'd0 ;
        o_Temp_Expo1          <= 'd0 ;
        o_Temp_Expo2          <= 'd0 ;
        o_Temp_Mant1          <= 'd0 ;
        o_Temp_Mant2          <= 'd0 ;
        o_Normal_Sign         <= 'd0 ;
        o_Normal_Exp          <= 'd0 ;
        o_Normal_Mantissa     <= 'd0 ;
        o_TypeA               <= 'd0 ;
        o_SignA               <= 'd0 ;
        o_ExpoA               <= 'd0 ;
        o_MantA               <= 'd0 ;
        o_Is_Exception        <= 'd0 ;
        o_Result              <= 'd0 ;
        o_Sticky_Flag         <= 'd0 ;
        o_Internal_Acc        <= 'd0 ;
        o_Keep_Expo_signed    <= 'd0 ;
    end else if (i_is_int_op) begin
        o_Compute_Mode        <= 'd0 ;
        o_Compute_Precision   <= 'd0 ;
        o_Is_Widening         <= 'd0 ;
        o_Add_or_Subtract     <= 'd0 ;
        o_ZmIsSigned          <= 'd0 ;
        o_ZnIsSigned          <= 'd0 ;
        o_Num_of_Vector_Group <= 'd0 ;
        o_Vector_Group_Num    <= 'd0 ;
        o_Exception_Handling  <= 'd0 ;
        o_ZA_Base_Address     <= 'd0 ;
        o_Operand_C           <= 'd0 ;
        o_Rounded_result      <= 'd0 ;
        o_Precision_Addend    <= 'd0 ;
        o_FuseAdd_SelfAdd     <= 'd0 ;
        o_Temp_Sign1          <= 'd0 ;
        o_Temp_Sign2          <= 'd0 ;
        o_Temp_Expo1          <= 'd0 ;
        o_Temp_Expo2          <= 'd0 ;
        o_Temp_Mant1          <= 'd0 ;
        o_Temp_Mant2          <= 'd0 ;
        o_Normal_Sign         <= 'd0 ;
        o_Normal_Exp          <= 'd0 ;
        o_Normal_Mantissa     <= 'd0 ;
    end else begin
        o_Compute_Mode        <= i_Compute_Mode        ;
        o_Compute_Precision   <= i_Compute_Precision   ;
        o_Is_Widening         <= i_Is_Widening         ;
        o_Add_or_Subtract     <= i_Add_or_Subtract     ;
        o_ZmIsSigned          <= i_ZmIsSigned          ;
        o_ZnIsSigned          <= i_ZnIsSigned          ;
        o_Num_of_Vector_Group <= i_Num_of_Vector_Group ;
        o_Vector_Group_Num    <= i_Vector_Group_Num    ;
        o_Exception_Handling  <= i_Exception_Handling  ;
        o_ZA_Base_Address     <= i_ZA_Base_Address     ;
        o_Operand_C           <= i_Operand_C           ;
        o_Rounded_result      <= i_Rounded_result      ;
        o_Precision_Addend    <= i_Precision_Addend    ;
        o_FuseAdd_SelfAdd     <= i_FuseAdd_SelfAdd     ;
        o_Temp_Sign1          <= i_Temp_Sign1          ;
        o_Temp_Sign2          <= i_Temp_Sign2          ;
        o_Temp_Expo1          <= i_Temp_Expo1          ;
        o_Temp_Expo2          <= i_Temp_Expo2          ;
        o_Temp_Mant1          <= i_Temp_Mant1          ;
        o_Temp_Mant2          <= i_Temp_Mant2          ;
        o_Normal_Sign         <= i_Normal_Sign         ;
        o_Normal_Exp          <= i_Normal_Exp          ;
        o_Normal_Mantissa     <= i_Normal_Mantissa     ;
        o_TypeA               <= i_TypeA               ;
        o_SignA               <= i_SignA               ;
        o_ExpoA               <= i_ExpoA               ;
        o_MantA               <= i_MantA               ; 
        o_Result              <= i_Result              ;
        o_Is_Exception        <= i_Is_Exception        ;
        o_Sticky_Flag         <= i_Sticky_Flag         ;
        o_Internal_Acc        <= i_Internal_Acc        ;
        o_Keep_Expo_signed    <= i_Keep_Expo_signed    ;
    end
end

`else

input                 clk                     ;
input                 rst_n                   ;
input       [ 2:0]    i_Precision_Addend      ;
input       [127:0]   i_Rounded_result        ;
input                 i_Compute_Mode          ;
input       [ 2:0]    i_Compute_Precision     ;
input                 i_Is_Widening           ;
input                 i_Add_or_Subtract       ;
input                 i_ZmIsSigned            ;
input                 i_ZnIsSigned            ;
input                 i_Num_of_Vector_Group   ;
input       [  1:0]   i_Vector_Group_Num      ;
input       [ 19:0]   i_Exception_Handling    ;
input       [ 31:0]   i_ZA_Base_Address       ;
input       [127:0]   i_Operand_C             ;
input                 i_FuseAdd_SelfAdd       ;
input                 i_Temp_Sign1            ;
input                 i_Temp_Sign2            ;
input      [  9:0]    i_Temp_Expo1            ;
input      [  9:0]    i_Temp_Expo2            ;
input      [ 47:0]    i_Temp_Mant1            ;
input      [ 47:0]    i_Temp_Mant2            ;
input      [  3:0]    i_Normal_Sign           ;
input      [ 39:0]    i_Normal_Exp            ;
input      [191:0]    i_Normal_Mantissa       ;
input                 i_is_int_op             ;
input       [ 11:0]   i_TypeA                 ;
input       [  3:0]   i_SignA                 ;
input       [ 31:0]   i_ExpoA                 ;
input       [ 95:0]   i_MantA                 ;
input       [  3:0]   i_Is_Exception          ;
input       [127:0]   i_Result                ;
input       [  3:0]   i_Sticky_Flag           ;
input                 i_Internal_Acc          ;
input                 i_Keep_Expo_signed      ;
output                o_Keep_Expo_signed      ;
output                o_Internal_Acc          ;
output      [  3:0]   o_Sticky_Flag           ;
output      [127:0]   o_Result                ;
output      [  3:0]   o_Is_Exception          ;
output                o_Compute_Mode          ;
output      [ 2:0]    o_Compute_Precision     ;
output                o_Is_Widening           ;
output                o_Add_or_Subtract       ;
output                o_ZmIsSigned            ;
output                o_ZnIsSigned            ;
output                o_Num_of_Vector_Group   ;
output      [  1:0]   o_Vector_Group_Num      ;
output      [ 19:0]   o_Exception_Handling    ;
output      [ 31:0]   o_ZA_Base_Address       ;
output      [127:0]   o_Operand_C             ;
output      [127:0]   o_Rounded_result        ;
output      [ 2:0]    o_Precision_Addend      ;
output                o_FuseAdd_SelfAdd       ;
output                o_Temp_Sign1            ;
output                o_Temp_Sign2            ;
output     [  9:0]    o_Temp_Expo1            ;
output     [  9:0]    o_Temp_Expo2            ;
output     [ 47:0]    o_Temp_Mant1            ;
output     [ 47:0]    o_Temp_Mant2            ;
output     [  3:0]    o_Normal_Sign           ;
output     [ 39:0]    o_Normal_Exp            ;
output     [191:0]    o_Normal_Mantissa       ;
output     [ 11:0]    o_TypeA                 ;
output     [  3:0]    o_SignA                 ;
output     [ 31:0]    o_ExpoA                 ;
output     [ 95:0]    o_MantA                 ;

assign o_Compute_Mode        = i_Compute_Mode        ;
assign o_Compute_Precision   = i_Compute_Precision   ;
assign o_Is_Widening         = i_Is_Widening         ;
assign o_Add_or_Subtract     = i_Add_or_Subtract     ;
assign o_ZmIsSigned          = i_ZmIsSigned          ;
assign o_ZnIsSigned          = i_ZnIsSigned          ;
assign o_Num_of_Vector_Group = i_Num_of_Vector_Group ;
assign o_Vector_Group_Num    = i_Vector_Group_Num    ;
assign o_Exception_Handling  = i_Exception_Handling  ;
assign o_ZA_Base_Address     = i_ZA_Base_Address     ;
assign o_Operand_C           = i_Operand_C           ;
assign o_Rounded_result      = i_Rounded_result      ;
assign o_Precision_Addend    = i_Precision_Addend    ;
assign o_FuseAdd_SelfAdd     = i_FuseAdd_SelfAdd     ;
assign o_Temp_Sign1          = i_Temp_Sign1          ;
assign o_Temp_Sign2          = i_Temp_Sign2          ;
assign o_Temp_Expo1          = i_Temp_Expo1          ;
assign o_Temp_Expo2          = i_Temp_Expo2          ;
assign o_Temp_Mant1          = i_Temp_Mant1          ;
assign o_Temp_Mant2          = i_Temp_Mant2          ;
assign o_Normal_Sign         = i_Normal_Sign         ;
assign o_Normal_Exp          = i_Normal_Exp          ;
assign o_Normal_Mantissa     = i_Normal_Mantissa     ;
assign o_TypeA               = i_TypeA               ;
assign o_SignA               = i_SignA               ;
assign o_ExpoA               = i_ExpoA               ;
assign o_MantA               = i_MantA               ;
assign o_Is_Exception        = i_Is_Exception        ;
assign o_Result              = i_Result              ;
assign o_Sticky_Flag         = i_Sticky_Flag         ;
assign o_Internal_Acc        = i_Internal_Acc        ;
assign o_Keep_Expo_signed    = i_Keep_Expo_signed    ;

`endif
    
endmodule