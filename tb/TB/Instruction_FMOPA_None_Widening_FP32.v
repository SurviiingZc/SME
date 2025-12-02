`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Instruction_FMOPA_None_Widening_FP32(
    clk                   ,
    rst                   ,
    Test_Case             ,
    i_send_data_start     ,
    o_Compute_Mode        ,
    o_Compute_Precision   ,
    o_Is_Widening         ,
    o_Add_or_Subtract     ,
    o_ZmIsSigned          ,
    o_ZnIsSigned          ,
    o_Num_of_Vector_Group ,
    o_Vector_Group_Num    ,
    o_Exception_Handling  ,
    o_ZA_Base_Address     ,
    o_Active_Element_A    ,
    o_Active_Element_B    ,
    o_Operand_A           ,
    o_Operand_B           ,
    o_Operand_C           ,
    o_Right_Result        ,
    Test_Instruction      ,
    receiver_result_valid ,
    Test_Situation        
);

parameter C                 = 5   ;

localparam Case_Count = 2 ** C + 32;
input               clk                     ;
input               rst                     ;
input             i_send_data_start         ;
input   [ C:0]    Test_Case                 ;
output            o_Compute_Mode            ;
output  [ 2:0]    o_Compute_Precision       ;
output            o_Is_Widening             ;
output            o_Add_or_Subtract         ;
output            o_ZmIsSigned              ;
output            o_ZnIsSigned              ;
output            o_Num_of_Vector_Group     ;
output  [ 1:0]    o_Vector_Group_Num        ;
output  [19:0]    o_Exception_Handling      ;
output  [31:0]    o_ZA_Base_Address         ;
output  [ 3:0]    o_Active_Element_A        ;
output  [ 3:0]    o_Active_Element_B        ;
output  [31:0]    o_Operand_A               ;
output  [31:0]    o_Operand_B               ;
output  [127:0]   o_Operand_C               ;
output  [127:0]   o_Right_Result            ;
output  [999:0]   Test_Instruction          ;
output  [999:0]   Test_Situation            ;
output            receiver_result_valid     ;

wire    [31:0]    s_axis_a_tdata            ;
wire              s_axis_a_tvalid           ;
wire              s_axis_a_tready           ;
    
wire    [31:0]    s_axis_b_tdata            ;
wire              s_axis_b_tvalid           ;
wire              s_axis_b_tready           ;
    
wire    [31:0]    s_axis_c_tdata            ;
wire              s_axis_c_tvalid           ;
wire              s_axis_c_tready           ;
    
wire    [31:0]    m_axis_result_tdata       ;
wire              m_axis_result_tvalid      ;
wire              m_axis_result_tready      ;
wire              sender_busy               ;
wire              send_data_start           ;
wire    [31:0]    receiver_result           ;
wire              receiver_result_valid     ;

//Floating-point Control Signal.
reg              AHP      ;
reg              DN       ;
reg              FZ       ;
reg    [1:0]     RMode    ;
reg    [1:0]     Stride   ;
reg              FZ16     ;
reg    [1:0]     Len      ;
reg              IDE      ;
reg              EBF      ;
reg              IXE      ;
reg              UFE      ;
reg              OFE      ;
reg              DZE      ;
reg              IOE      ;
reg              NEP      ;
reg              AH       ;
reg              FIZ      ;

reg              Sign_FP16            ;
reg  [ 4:0]      Exp_FP16             ;
reg  [ 9:0]      Frac_FP16            ;
reg  [15:0]      Value_FP16           ;
reg              Sign_BF16            ;
reg  [ 7:0]      Exp_BF16             ;
reg  [ 6:0]      Frac_BF16            ;
reg  [15:0]      Value_BF16           ;
reg              Sign_FP32            ;
reg  [ 7:0]      Exp_FP32             ;
reg  [22:0]      Frac_FP32            ;
reg  [31:0]      Value_FP32           ;


wire             is_BF16_FP16_FP32     ;
wire             is_8_bits             ;
wire             is_16_bits            ;
wire             is_32_bits            ;
reg    [7:0]     Active_Mapped_8_bits  ;
reg    [7:0]     Active_Mapped_16_bits ;
reg    [7:0]     Active_Mapped_32_bits ;
reg    [7:0]     Active_Mapped_8_Sel   ;
reg    [7:0]     Active_Mapped_16_Sel  ;
reg    [7:0]     Active_Mapped_32_Sel  ;
reg    [7:0]     T_Active_Element      ;
integer          i,j,k                 ;

reg  [31:0]       A1                  [Case_Count - 1:0]  ;
reg  [31:0]       B1                  [Case_Count - 1:0]  ;
reg  [31:0]       C1                  [Case_Count - 1:0]  ;
reg  [31:0]       Result              [Case_Count - 1:0]  ;
reg  [999:0]      Situation           [Case_Count - 1:0]  ;

assign Test_Instruction       = "FMOPA_None_Widening_FP32"                                         ;
assign Test_Situation         = Situation[Test_Case]                                               ;
assign o_Compute_Mode         = `Outer_Product                                                     ;
assign o_Compute_Precision    = `FP32                                                              ;
assign o_Add_or_Subtract      = `Addition_Operation                                                ;
assign o_ZmIsSigned           = `Zm_Is_Signed                                                      ;
assign o_ZnIsSigned           = `Zn_Is_Signed                                                      ;
assign o_Is_Widening          = `Operands_Is_Not_Widening                                          ;
assign o_Num_of_Vector_Group  = `Two_Vector_Group                                                  ;
assign o_Vector_Group_Num     = `Single_Vector_Group                                               ;
assign o_Exception_Handling   = {AHP,DN,FZ,RMode,Stride,FZ16,Len,IDE,EBF,IXE,UFE,OFE,DZE,IOE,NEP,AH,FIZ}  ; 
assign o_ZA_Base_Address      = $random()                                                          ;
assign o_Active_Element_A     = T_Active_Element[3:0]                                              ;
assign o_Active_Element_B     = T_Active_Element[7:4]                                              ;
assign o_Operand_A            = A1[Test_Case]                                                      ;
assign o_Operand_B            = B1[Test_Case]                                                      ;
assign o_Operand_C            = {96'd0,C1[Test_Case]}                                              ;
//assign o_Right_Result         = (Test_Case < 12) ? {96'd0,Result[Test_Case]} : {96'd0,receiver_result};
assign o_Right_Result         = {96'd0,receiver_result};
assign is_BF16_FP16_FP32      = ((o_Compute_Precision == `FP32) | (o_Compute_Precision == `FP16) | (o_Compute_Precision == `BF16) | (o_Compute_Precision == `FP8)) ? 'b1 : 'b0 ;
assign is_8_bits              = ((o_Compute_Precision == `INT8) | (o_Compute_Precision == `FP8)) ? 'b1 : 'b0                                                                   ;
assign is_16_bits             = ((o_Compute_Precision == `BF16) | (o_Compute_Precision == `INT16) | (o_Compute_Precision == `FP16)) ? 'b1 : 'b0                                ;
assign is_32_bits             = ((o_Compute_Precision == `FP32) | (o_Compute_Precision == `INT32)) ? 'b1 : 'b0                                                                 ;
// assign receiver_result_valid  = 1 ;

always @(*) begin
    DN       = `Operation_Involving_NaNs_Returns_Default_NaN            ;
    AHP      = `IEEE_Half_Precision_Format                              ;
    FZ       = `Flush_Denormalized_Results_to_Zero                      ;
    RMode    = `Round_to_Nearest_Mode                                   ;
    Stride   = `Stride_1                                                ;
    FZ16     = `Flush_Denormalized_Results_to_Zero_Half                 ;
    Len      = `Length_1                                                ;
    IDE      = `Trap_Enabled_for_Input_Denormal                         ;
    EBF      = `Extended_BFloat16_Behaviors                             ;
    IXE      = `Trap_Enabled_for_Inexact_Result                         ;
    UFE      = `Trap_Enabled_for_Underflow                              ;
    OFE      = `Trap_Enabled_for_Overflow                               ;
    DZE      = `Trap_Enabled_for_Divide_by_Zero                         ;
    IOE      = `Trap_Enabled_for_Invalid_Operation                      ;
    NEP      = `Not_Affect_Output_Elements                              ;
    AH       = `IEEE_Handling_Floating_Point_Numbers                    ;
    FIZ      = `Flush_Denormalized_Results_to_Zero_S_D_BF               ;

    Active_Mapped_8_bits   = 8'b1111_1111           ;
    Active_Mapped_16_bits  = 8'b0101_0101           ;
    Active_Mapped_32_bits  = 8'b0001_0001           ;

    `ifdef Randomly_Generate_Activation_Bits
    for(i = 0 ; i < 8 ; i = i + 1) begin
        Active_Mapped_8_Sel[i]  = Active_Mapped_8_bits[i] ? $random() % 2 : 1'd0     ;
        Active_Mapped_16_Sel[i] = Active_Mapped_16_bits[i] ? $random() % 2 : 1'd0    ;
        Active_Mapped_32_Sel[i] = Active_Mapped_32_bits[i] ? $random() % 2 : 1'd0    ;
        T_Active_Element[i]     = is_8_bits ? Active_Mapped_8_Sel[i] :
                                    is_16_bits ? Active_Mapped_16_Sel[i] :
                                    is_32_bits ? Active_Mapped_32_Sel[i] : 1'dz;
    end
    `else
    T_Active_Element     = is_8_bits ? Active_Mapped_8_bits :
                                is_16_bits ? Active_Mapped_16_bits :
                                is_32_bits ? Active_Mapped_32_bits : 8'dz;
    `endif

    for(j = 32 ; j < Case_Count ; j = j + 1) begin
        Situation[j]                   = "Random Situation"                                 ;
        A1[j]                          = $random()                                          ;
        B1[j]                          = $random()                                          ;
        C1[j]                          = $random()                                          ;
        Result[j]                      = 'dz                                                ;
    end
end

always @(*) begin

    for(k = 0 ; k < 32 ; k = k + 1) begin
        Situation[k]                   = "Blank Situation"                                  ;
        A1[k]                          = 'd0                                      ;
        B1[k]                          = 'd0                                      ;
        C1[k]                          = 'd0                                      ;
        Result[k]                      = 'd0                                      ;
    end

    Situation[0] = "(-FPType_Zero) * (+FPType_Zero) + (-FPType_Zero)" ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[0]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[0]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[0]        = Value_FP32                                   ;
    Result[0]    = Value_FP32                                   ;

    Situation[1] = "(+FPType_Zero) * (+FPType_Infinity) + (+FPType_Zero)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[1]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[1]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[1]        = Value_FP32                                   ;
    Result[1]    = Value_FP32                                   ;

    Situation[2] = "(-FPType_Infinity) * (-FPType_Zero) + (+FPType_Zero)" ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[2]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[2]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[2]        = Value_FP32                                   ;
    Result[2]    = Value_FP32                                   ;

    Situation[3] = "(+FPType_Zero) * (-FPType_Infinity) + (+FPType_Zero)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[3]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[3]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[3]        = Value_FP32                                   ;
    Result[3]    = Value_FP32                                   ;

    Situation[4] = "(+FPType_Denormal) * (-FPType_Infinity) + (+FPType_Infinity)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {{22{1'd0}},1'd1}                            ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[4]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[4]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[4]        = Value_FP32                                   ;
    Result[4]    = Value_FP32                                   ;

    Situation[5] = "(+FPType_Denormal) * (+FPType_Infinity) + (+FPType_Infinity)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {{22{1'd0}},1'd1}                            ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[5]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[5]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[5]        = Value_FP32                                   ;
    Result[5]    = Value_FP32                                   ;

    Situation[6] = "(+FPType_Denormal) * (-FPType_Infinity) + (-FPType_Infinity)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd0}}                                    ;
    Frac_FP32    = {{22{1'd0}},1'd1}                            ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[6]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[6]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[6]        = Value_FP32                                   ;
    Result[6]    = Value_FP32                                   ;

    Situation[6] = "(+FPType_QNaN) * (-FPType_QNaN) + (-FPType_QNaN)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[6]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[6]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[6]        = Value_FP32                                   ;
    Result[6]    = Value_FP32                                   ;

    Situation[7] = "(+FPType_SNaN) * (-FPType_SNaN) + (-FPType_SNaN)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[7]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[7]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[7]        = Value_FP32                                   ;
    Result[7]    = Value_FP32                                   ;

    Situation[8] = "(+FPType_QNaN) * (-FPType_SNaN) + (-FPType_SNaN)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[8]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[8]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[8]        = Value_FP32                                   ;
    Result[8]    = Value_FP32                                   ;

    Situation[9] = "(+FPType_QNaN) * (-FPType_QNaN) + (-FPType_SNaN)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[9]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[9]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0   ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[9]        = Value_FP32                                   ;
    Result[9]    = Value_FP32                                   ;

    Situation[10] = "(+FPType_SNaN) * (-FPType_QNaN) + (-FPType_SNaN)" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[10]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd1,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[10]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd1                                         ;
    Exp_FP32     = {8{1'd1}}                                    ;
    Frac_FP32    = {1'd0,22'd55}                                ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[10]        = Value_FP32                                  ;
    Result[10]    = Value_FP32                                  ;

    Situation[11] = " 1 * 1 + 1" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b01111111}                                ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[11]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b01111111}                                ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[11]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b01111111}                                ;
    Frac_FP32    = {23{1'd0}}                                   ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[11]        = Value_FP32                                  ;
    Result[11]    = Value_FP32                                  ;

    Situation[12] = " 3 * 5 + 11" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b10000000}                                ;
    Frac_FP32    = {1'b1, {22{1'd0}}}                           ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[12]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b10000001}                                ;
    Frac_FP32    = {1'b0,1'b1,{21{1'd0}}}                       ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[12]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b10000010}                                ;
    Frac_FP32    = {1'b0,2'b11,{20{1'd0}}}                      ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[12]        = Value_FP32                                  ;
    Result[12]    = Value_FP32                                  ;

    Situation[13] = " 3 * 5 + 11" ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b10000000}                                ;
    Frac_FP32    = {{22{1'd0}},1'b1}                            ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    A1[13]        = o_Active_Element_A[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b10000000}                                ;
    Frac_FP32    = {{22{1'd0}},1'b1}                            ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    B1[13]        = o_Active_Element_B[0] ? Value_FP32 : 32'd0  ;
    Sign_FP32    = 1'd0                                         ;
    Exp_FP32     = {8'b10000000}                                ;
    Frac_FP32    = {{22{1'd0}},1'b1}                            ;
    Value_FP32   = {Sign_FP32,Exp_FP32,Frac_FP32}               ;
    C1[13]        = Value_FP32                                  ;
    Result[12]    = Value_FP32                                  ;
end

    // IP_FP32_FMA u_IP_FP32_FMA (
    //     .aclk(clk),
    //     .aresetn(rst),

    //     .s_axis_a_tdata(s_axis_a_tdata),
    //     .s_axis_a_tvalid(s_axis_a_tvalid),
    //     .s_axis_a_tready(s_axis_a_tready),

    //     .s_axis_b_tdata(s_axis_b_tdata),
    //     .s_axis_b_tvalid(s_axis_b_tvalid),
    //     .s_axis_b_tready(s_axis_b_tready),

    //     .s_axis_c_tdata(s_axis_c_tdata),
    //     .s_axis_c_tvalid(s_axis_c_tvalid),
    //     .s_axis_c_tready(s_axis_c_tready),

    //     .m_axis_result_tdata(m_axis_result_tdata),
    //     .m_axis_result_tvalid(m_axis_result_tvalid),
    //     .m_axis_result_tready(m_axis_result_tready)    
    // );

    // axis_master u_axis_master (
    //     .ACLK(clk),
    //     .ARESETn(rst),
    //     .start(i_send_data_start),
    //     .data_a(o_Operand_A),
    //     .data_b(o_Operand_B),
    //     .data_c(o_Operand_C[31:0]),
    //     .busy(sender_busy),

    //     .M_AXIS_A_TDATA(s_axis_a_tdata),
    //     .M_AXIS_A_TVALID(s_axis_a_tvalid),
    //     .M_AXIS_A_TREADY(s_axis_a_tready),

    //     .M_AXIS_B_TDATA(s_axis_b_tdata),
    //     .M_AXIS_B_TVALID(s_axis_b_tvalid),
    //     .M_AXIS_B_TREADY(s_axis_b_tready),

    //     .M_AXIS_C_TDATA(s_axis_c_tdata),
    //     .M_AXIS_C_TVALID(s_axis_c_tvalid),
    //     .M_AXIS_C_TREADY(s_axis_c_tready)
    // );


    // axis_slave_receiver u_axis_slave (
    //     .ACLK(clk),
    //     .ARESETn(rst),

    //     .result(receiver_result),
    //     .result_valid(receiver_result_valid),

    //     .S_AXIS_RESULT_TDATA(m_axis_result_tdata),
    //     .S_AXIS_RESULT_TVALID(m_axis_result_tvalid),
    //     .S_AXIS_RESULT_TREADY(m_axis_result_tready)
    // );

endmodule