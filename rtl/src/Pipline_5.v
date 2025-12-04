`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Pipline_5 (
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
        i_Precision_Addend     ,
        i_Mant                 ,
        i_Fault_Result         ,
        i_IsBfloat16           ,
        i_N                    ,
        i_Sum_Expo	           ,
        i_Sum_Sign	           ,
        i_Temp_Sign            ,
        i_Temp_Expo            ,
        i_Temp_Mant            ,
        i_Is_Exception         ,
        i_Sticky_Bit           ,
        o_Sticky_Bit           ,
        o_Is_Exception         ,
        o_Mant                 ,
        o_Fault_Result         ,
        o_IsBfloat16           ,
        o_N                    ,
        o_Sum_Expo	           ,
        o_Sum_Sign	           ,
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
        o_Precision_Addend     ,
        o_Temp_Sign            ,
        o_Temp_Expo            ,
        o_Temp_Mant            
);

`ifdef Is_PipLine

input                 clk                     ;
input                 rst_n                   ;
input       [ 2:0]    i_Precision_Addend      ;
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
input       [195:0]   i_Mant                  ;
input       [127:0]   i_Fault_Result          ;
input       [  3:0]   i_IsBfloat16            ;
input       [  3:0]   i_N                     ;
input       [ 31:0]	  i_Sum_Expo		      ;
input       [  3:0]   i_Sum_Sign		      ;
input                 i_Temp_Sign             ;
input       [  9:0]   i_Temp_Expo             ;
input       [ 72:0]   i_Temp_Mant             ;
input       [  3:0]   i_Is_Exception          ;
input                 i_Sticky_Bit            ;
output reg            o_Sticky_Bit            ;
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
output reg  [  2:0]   o_Precision_Addend      ;
output reg  [195:0]   o_Mant                  ;
output reg  [127:0]   o_Fault_Result          ;
output reg  [  3:0]   o_IsBfloat16            ;
output reg  [  3:0]   o_N                     ;
output reg  [ 39:0]	  o_Sum_Expo		      ;
output reg  [  3:0]   o_Sum_Sign		      ;
output reg            o_Temp_Sign             ;
output reg  [  9:0]   o_Temp_Expo             ;
output reg  [ 72:0]   o_Temp_Mant             ;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        o_Compute_Mode         <= 'd0 ;
        o_Compute_Precision    <= 'd0 ;
        o_Is_Widening          <= 'd0 ;
        o_Add_or_Subtract      <= 'd0 ;
        o_ZmIsSigned           <= 'd0 ;
        o_ZnIsSigned           <= 'd0 ;
        o_Num_of_Vector_Group  <= 'd0 ;
        o_Vector_Group_Num     <= 'd0 ;
        o_Exception_Handling   <= 'd0 ;
        o_ZA_Base_Address      <= 'd0 ;
        o_Precision_Addend     <= 'd0 ;
        o_Mant                 <= 'd0 ;
        o_Fault_Result         <= 'd0 ;
        o_IsBfloat16           <= 'd0 ;
        o_N                    <= 'd0 ;
        o_Sum_Expo	           <= 'd0 ;
        o_Sum_Sign	           <= 'd0 ;
        o_Temp_Sign            <= 'd0 ;
        o_Temp_Expo            <= 'd0 ;
        o_Temp_Mant            <= 'd0 ;
        o_Is_Exception         <= 'd0 ;
        o_Sticky_Bit           <= 'd0 ;
    end 
    else begin
        o_Compute_Mode         <= i_Compute_Mode         ;
        o_Compute_Precision    <= i_Compute_Precision    ;
        o_Is_Widening          <= i_Is_Widening          ;
        o_Add_or_Subtract      <= i_Add_or_Subtract      ;
        o_ZmIsSigned           <= i_ZmIsSigned           ;
        o_ZnIsSigned           <= i_ZnIsSigned           ;
        o_Num_of_Vector_Group  <= i_Num_of_Vector_Group  ;
        o_Vector_Group_Num     <= i_Vector_Group_Num     ;
        o_Exception_Handling   <= i_Exception_Handling   ;
        o_ZA_Base_Address      <= i_ZA_Base_Address      ;
        o_Precision_Addend     <= i_Precision_Addend     ;
        o_Mant                 <= i_Mant                 ;
        o_Fault_Result         <= i_Fault_Result         ;
        o_IsBfloat16           <= i_IsBfloat16           ;
        o_N                    <= i_N                    ;
        o_Sum_Expo	           <= i_Sum_Expo	         ;
        o_Sum_Sign	           <= i_Sum_Sign	         ;
        o_Temp_Sign            <= i_Temp_Sign            ;
        o_Temp_Expo            <= i_Temp_Expo            ;
        o_Temp_Mant            <= i_Temp_Mant            ;
        o_Is_Exception         <= i_Is_Exception         ;
        o_Sticky_Bit           <= i_Sticky_Bit           ;
    end
end

`else

input                 clk                     ;
input                 rst_n                   ;
input       [ 2:0]    i_Precision_Addend      ;
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

input       [195:0]   i_Mant                  ;
input       [127:0]   i_Fault_Result          ;
input       [  3:0]   i_IsBfloat16            ;
input       [  3:0]   i_N                     ;
input       [ 31:0]	  i_Sum_Expo		      ;
input       [  3:0]   i_Sum_Sign		      ;
input                 i_Temp_Sign             ;
input       [  9:0]   i_Temp_Expo             ;
input       [ 72:0]   i_Temp_Mant             ;
input       [  3:0]   i_Is_Exception          ;
input                 i_Sticky_Bit            ;
output                o_Sticky_Bit            ;
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
output      [  2:0]   o_Precision_Addend      ;
output      [195:0]   o_Mant                  ;
output      [127:0]   o_Fault_Result          ;
output      [  3:0]   o_IsBfloat16            ;
output      [  3:0]   o_N                     ;
output      [ 39:0]	  o_Sum_Expo		      ;
output      [  3:0]   o_Sum_Sign		      ;
output                o_Temp_Sign             ;
output      [  9:0]   o_Temp_Expo             ;
output      [ 72:0]   o_Temp_Mant             ;

assign o_Compute_Mode           = i_Compute_Mode            ;
assign o_Compute_Precision      = i_Compute_Precision       ;
assign o_Is_Widening            = i_Is_Widening             ;
assign o_Add_or_Subtract        = i_Add_or_Subtract         ;
assign o_ZmIsSigned             = i_ZmIsSigned              ;
assign o_ZnIsSigned             = i_ZnIsSigned              ;
assign o_Num_of_Vector_Group    = i_Num_of_Vector_Group     ;
assign o_Vector_Group_Num       = i_Vector_Group_Num        ;
assign o_Exception_Handling     = i_Exception_Handling      ;
assign o_ZA_Base_Address        = i_ZA_Base_Address         ;
assign o_Precision_Addend       = i_Precision_Addend        ;
assign o_Mant                   = i_Mant                    ;
assign o_Fault_Result           = i_Fault_Result            ;
assign o_IsBfloat16             = i_IsBfloat16              ;
assign o_N                      = i_N                       ;
assign o_Sum_Expo	            = i_Sum_Expo	            ;
assign o_Sum_Sign	            = i_Sum_Sign	            ;
assign o_Temp_Sign              = i_Temp_Sign               ;
assign o_Temp_Expo              = i_Temp_Expo               ;
assign o_Temp_Mant              = i_Temp_Mant               ;
assign o_Is_Exception           = i_Is_Exception            ;
assign o_Sticky_Bit             = i_Sticky_Bit              ;

`endif
    
endmodule