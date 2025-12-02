`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Pipline_0 (
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
        i_Active_Element_A     ,
        i_Active_Element_B     ,
        i_Operand_A            ,
        i_Operand_B            ,
        i_Operand_C            ,
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
        o_Active_Element_A     ,
        o_Active_Element_B     ,
        o_Operand_A            ,
        o_Operand_B            ,
        o_Operand_C            
);

`ifdef Is_PipLine

input                clk                     ;
input                rst_n                   ;
input                i_Compute_Mode          ;
input      [ 2:0]    i_Compute_Precision     ;
input                i_Is_Widening           ;
input                i_Add_or_Subtract       ;
input                i_ZmIsSigned            ;
input                i_ZnIsSigned            ;
input                i_Num_of_Vector_Group   ;
input      [  1:0]   i_Vector_Group_Num      ;
input      [ 19:0]   i_Exception_Handling    ;
input      [ 31:0]   i_ZA_Base_Address       ;
input      [ 3:0]    i_Active_Element_A      ;
input      [ 3:0]    i_Active_Element_B      ;
input      [ 31:0]   i_Operand_A             ;
input      [ 31:0]   i_Operand_B             ;
input      [127:0]   i_Operand_C             ;
output reg           o_Compute_Mode          ;
output reg [ 2:0]    o_Compute_Precision     ;
output reg           o_Is_Widening           ;
output reg           o_Add_or_Subtract       ;
output reg           o_ZmIsSigned            ;
output reg           o_ZnIsSigned            ;
output reg           o_Num_of_Vector_Group   ;
output reg [  1:0]   o_Vector_Group_Num      ;
output reg [ 19:0]   o_Exception_Handling    ;
output reg [ 31:0]   o_ZA_Base_Address       ;
output reg [  3:0]   o_Active_Element_A      ;
output reg [  3:0]   o_Active_Element_B      ;
output reg [ 31:0]   o_Operand_A             ;
output reg [ 31:0]   o_Operand_B             ;
output reg [127:0]   o_Operand_C             ;


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
        o_Active_Element_A    <= 'd0 ;
        o_Active_Element_B    <= 'd0 ;
        o_Operand_A           <= 'd0 ;
        o_Operand_B           <= 'd0 ;
        o_Operand_C           <= 'd0 ;
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
        o_Active_Element_A    <= o_Active_Element_A    ;
        o_Active_Element_B    <= o_Active_Element_B    ;
        o_Operand_A           <= i_Operand_A           ;
        o_Operand_B           <= i_Operand_B           ;
        o_Operand_C           <= i_Operand_C           ;
    end
end

`else

input                clk                     ;
input                rst_n                   ;
input                i_Compute_Mode          ;
input      [ 2:0]    i_Compute_Precision     ;
input                i_Is_Widening           ;
input                i_Add_or_Subtract       ;
input                i_ZmIsSigned            ;
input                i_ZnIsSigned            ;
input                i_Num_of_Vector_Group   ;
input      [  1:0]   i_Vector_Group_Num      ;
input      [ 19:0]   i_Exception_Handling    ;
input      [ 31:0]   i_ZA_Base_Address       ;
input      [ 3:0]    i_Active_Element_A      ;
input      [ 3:0]    i_Active_Element_B      ;
input      [ 31:0]   i_Operand_A             ;
input      [ 31:0]   i_Operand_B             ;
input      [127:0]   i_Operand_C             ;
output               o_Compute_Mode          ;
output     [ 2:0]    o_Compute_Precision     ;
output               o_Is_Widening           ;
output               o_Add_or_Subtract       ;
output               o_ZmIsSigned            ;
output               o_ZnIsSigned            ;
output               o_Num_of_Vector_Group   ;
output     [  1:0]   o_Vector_Group_Num      ;
output     [ 19:0]   o_Exception_Handling    ;
output     [ 31:0]   o_ZA_Base_Address       ;
output     [  3:0]   o_Active_Element_A      ;
output     [  3:0]   o_Active_Element_B      ;
output     [ 31:0]   o_Operand_A             ;
output     [ 31:0]   o_Operand_B             ;
output     [127:0]   o_Operand_C             ;

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
assign o_Active_Element_A    = o_Active_Element_A    ;
assign o_Active_Element_B    = o_Active_Element_B    ;
assign o_Operand_A           = i_Operand_A           ;
assign o_Operand_B           = i_Operand_B           ;
assign o_Operand_C           = i_Operand_C           ;

`endif

endmodule