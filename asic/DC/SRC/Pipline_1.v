`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Pipline_1 (
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
        i_Mant                 ,
        i_Result               ,
        i_OutSign              ,
        i_OutExpo              ,
        i_IsBfloat16           ,
        i_N                    ,
        i_Int_Product          ,        
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
        o_Mant                 ,
        o_Result               ,
        o_OutSign              ,
        o_OutExpo              ,
        o_IsBfloat16           ,
        o_Int_Product          ,        
        o_N                    
);

`ifdef Is_PipLine

input                 clk                     ;
input                 rst_n                   ;
input       [ 2:0]    i_Precision_Addend      ;
input       [191:0]   i_Mant                  ;
input       [127:0]   i_Result                ;
input       [  3:0]   i_OutSign               ;
input       [ 35:0]   i_OutExpo               ;
input                 i_IsBfloat16            ;
input                 i_N                     ;
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
input       [ 63:0]   i_Int_Product           ;     
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
output reg  [191:0]   o_Mant                  ;
output reg  [127:0]   o_Result                ;
output reg  [  3:0]   o_OutSign               ;
output reg  [ 35:0]   o_OutExpo               ;
output reg            o_IsBfloat16            ;
output reg            o_N                     ;
output reg  [ 2:0]    o_Precision_Addend      ;
output reg  [ 63:0]   o_Int_Product           ;     

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
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
        o_Mant                <= 'd0 ;
        o_Result              <= 'd0 ;
        o_OutSign             <= 'd0 ;
        o_OutExpo             <= 'd0 ;
        o_IsBfloat16          <= 'd0 ;
        o_N                   <= 'd0 ;
        o_Precision_Addend    <= 'd0 ;
        o_Int_Product         <= 'd0 ;              
    end
    else begin
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
        o_Mant                <= i_Mant                ;
        o_Result              <= i_Result              ;
        o_OutSign             <= i_OutSign             ;
        o_OutExpo             <= i_OutExpo             ;
        o_IsBfloat16          <= i_IsBfloat16          ;
        o_N                   <= i_N                   ;
        o_Precision_Addend    <= i_Precision_Addend    ;
        o_Int_Product         <= i_Int_Product         ;  
    end
end

`else

input                 clk                     ;
input                 rst_n                   ;
input       [ 2:0]    i_Precision_Addend      ;
input       [191:0]   i_Mant                  ;
input       [127:0]   i_Result                ;
input       [  3:0]   i_OutSign               ;
input       [ 35:0]   i_OutExpo               ;
input                 i_IsBfloat16            ;
input                 i_N                     ;
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
output      [191:0]   o_Mant                  ;
output      [127:0]   o_Result                ;
output      [  3:0]   o_OutSign               ;
output      [ 35:0]   o_OutExpo               ;
output                o_IsBfloat16            ;
output                o_N                     ;
output      [ 2:0]    o_Precision_Addend      ;
input       [ 63:0]   i_Int_Product           ;     
output      [ 63:0]   o_Int_Product           ;     
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
assign o_Mant                = i_Mant                ;
assign o_Result              = i_Result              ;
assign o_OutSign             = i_OutSign             ;
assign o_OutExpo             = i_OutExpo             ;
assign o_IsBfloat16          = i_IsBfloat16          ;
assign o_N                   = i_N                   ;
assign o_Precision_Addend    = i_Precision_Addend    ;
assign o_Int_Product         = i_Int_Product         ;
`endif
    
endmodule