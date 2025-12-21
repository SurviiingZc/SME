`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Instruction_ADDVA_SINT32(
    Test_Case             ,
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
    Test_Situation        
);

parameter C = 5;

localparam Case_Count = 2 ** C + 32;

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

reg signed [31:0]       A1                  [Case_Count - 1:0]  ;
reg signed [31:0]       C1                  [Case_Count - 1:0]  ;
reg signed [31:0]       Result              [Case_Count - 1:0]  ;
reg        [999:0]      Situation           [Case_Count - 1:0]  ;

integer m,n;

// generate
//     for(m = 32 ; m < Case_Count ; m = m + 1) begin
//         assign Result[m] = A1[m] + C1[m]    ;
//     end
// endgenerate

assign Test_Instruction       = "ADDVA_SINT32"                                                     ;
assign Test_Situation         = Situation[Test_Case]                                               ;
assign o_Compute_Mode         = `Outer_Product                                                     ;
assign o_Compute_Precision    = `INT32                                                             ;
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
assign o_Operand_B            = 32'd0                                                              ;
assign o_Operand_C            = {96'd0,C1[Test_Case]}                                              ;
assign o_Right_Result         = {96'd0,Result[Test_Case]}                                          ;
assign is_BF16_FP16_FP32      = ((o_Compute_Precision == `FP32) | (o_Compute_Precision == `FP16) | (o_Compute_Precision == `BF16) | (o_Compute_Precision == `FP8)) ? 'b1 : 'b0 ;
assign is_8_bits              = ((o_Compute_Precision == `INT8) | (o_Compute_Precision == `FP8)) ? 'b1 : 'b0                                                                   ;
assign is_16_bits             = ((o_Compute_Precision == `BF16) | (o_Compute_Precision == `INT16) | (o_Compute_Precision == `FP16)) ? 'b1 : 'b0                                ;
assign is_32_bits             = ((o_Compute_Precision == `FP32) | (o_Compute_Precision == `INT32)) ? 'b1 : 'b0                                                                 ;

always @(*) begin
    AHP      = `IEEE_Half_Precision_Format                              ;
    DN       = `NaN_Propagate_Through_Floating_Point_Operation          ;
    FZ       = `Do_Not_Flush_Denormalized_Results_to_Zero               ;
    RMode    = `Round_Towards_Zero                                      ;
    Stride   = `Stride_1                                                ;
    FZ16     = `Do_Not_Flush_Denormalized_Results_to_Zero_Half          ;
    Len      = `Length_1                                                ;
    IDE      = `Trap_Enabled_for_Input_Denormal                         ;
    EBF      = `Standard_BFloat16_Behaviors                             ;
    IXE      = `Trap_Enabled_for_Inexact_Result                         ;
    UFE      = `Trap_Enabled_for_Underflow                              ;
    OFE      = `Trap_Enabled_for_Overflow                               ;
    DZE      = `Trap_Enabled_for_Divide_by_Zero                         ;
    IOE      = `Trap_Enabled_for_Invalid_Operation                      ;
    NEP      = `Not_Affect_Output_Elements                              ;
    AH       = `IEEE_Handling_Floating_Point_Numbers                    ;
    FIZ      = `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF        ;

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

    // How to deal with overflow situations?
    for(j = 32 ; j < Case_Count ; j = j + 1) begin
        Situation[j]                   = "Random Situation"                                 ;
        A1[j]                          = $random()                                             ;
        C1[j]                          = $random()                                             ;
        // Result[j]                      = A1[j] + C1[j]                                      ;
    end
end

always @(*) begin

    for(k = 0 ; k < 32 ; k = k + 1) begin
        Situation[k]                   = "Blank Situation"                                  ;
        A1[k]                          = 'd0                                      ;
        C1[k]                          = 'd0                                      ;
        Result[k]                      = 'd0                                      ;
    end

    Situation[0] = "Normal Situation((+1)+(+1))"                ;
    A1[0]        = 32'sb00000000000000000000000000000001        ;
    C1[0]        = 32'sb00000000000000000000000000000001        ;
    Result[0]    = o_Active_Element_A[0] ? A1[0] + C1[0] : C1[0]  ;

    Situation[1] = "Normal Situation((-1)+(-1))"                ;
    A1[1]        = 32'sb11111111111111111111111111111111        ;
    C1[1]        = 32'sb11111111111111111111111111111111        ;
    Result[1]    = o_Active_Element_A[0] ? A1[1] + C1[1] : C1[1]  ;

    Situation[2] = "Normal Situation((+0)+(+0))"                ;
    A1[2]        = 32'sb00000000000000000000000000000000        ;
    C1[2]        = 32'sb00000000000000000000000000000000        ;
    Result[2]    = o_Active_Element_A[0] ? A1[2] + C1[2] : C1[2]  ;

    Situation[3] = "Boundary Situation((+2147483647)+(+2147483647))"                ;
    A1[3]        = 32'sb01111111111111111111111111111111        ;
    C1[3]        = 32'sb01111111111111111111111111111111        ;
    Result[3]    = o_Active_Element_A[0] ? A1[3] + C1[3] : C1[3]  ;

    Situation[4] = "Boundary Situation((-2147483648)+(-2147483648))"                ;
    A1[4]        = 32'sb10000000000000000000000000000000        ;
    C1[4]        = 32'sb10000000000000000000000000000000        ;
    Result[4]    = o_Active_Element_A[0] ? A1[4] + C1[4] : C1[4]  ;

    Situation[5] = "Boundary Situation((+2147483647)+(-2147483648))"                ;
    A1[5]        = 32'sb01111111111111111111111111111111        ;
    C1[5]        = 32'sb10000000000000000000000000000000        ;
    Result[5]    = o_Active_Element_A[0] ? A1[5] + C1[5] : C1[5]  ;

    Situation[6] = "Boundary Situation((-2147483648)+(+2147483647))"                ;
    A1[6]        = 32'sb10000000000000000000000000000000        ;
    C1[6]        = 32'sb01111111111111111111111111111111        ;
    Result[6]    = o_Active_Element_A[0] ? A1[6] + C1[6] : C1[6]  ;

    Situation[7] = "Boundary Situation((+2147483647)+(-1))"     ;
    A1[7]        = 32'sb01111111111111111111111111111111        ;
    C1[7]        = 32'sb11111111111111111111111111111111        ;
    Result[7]    = o_Active_Element_A[0] ? A1[7] + C1[7] : C1[7]  ;

    Situation[8] = "Boundary Situation((-2147483648)+(+1))"     ;
    A1[8]        = 32'sb10000000000000000000000000000000        ;
    C1[8]        = 32'sb00000000000000000000000000000001        ;
    Result[8]    = o_Active_Element_A[0] ? A1[8] + C1[8] : C1[8]  ;

    for(m = 32 ; m < Case_Count ; m = m + 1) begin
        Result[m] = A1[m] + C1[m]    ;
    end

end


endmodule