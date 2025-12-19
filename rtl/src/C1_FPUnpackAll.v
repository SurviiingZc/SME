`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 
*/

module C1_FPUnpackAll (
    input             i_Compute_Mode         ,
    input  [  2:0]    i_Compute_Precision    ,
    input             i_Is_Widening          ,
    input  [  1:0]    i_Vector_Group_Num     ,
    input  [ 19:0]    i_Exception_Handling   ,
    input             i_Add_or_Subtract      ,
    input             i_FMLAL                ,
    input  [ 31:0]    i_Operand_A            ,
    input  [ 31:0]    i_Operand_B            ,
    input  [127:0]    i_Operand_C            ,

    output [ 11:0]    o_TypeA                ,
    output [  3:0]    o_SignA                ,
    output [ 31:0]    o_ExpoA                ,
    output [ 95:0]    o_MantA                ,
    output [127:0]    o_ValueA               ,
    output [  2:0]    o_Precision_Addend     ,

    output [  5:0]    o_Type1                ,
    output [  1:0]    o_Sign1                ,
    output [ 15:0]    o_Expo1                ,
    output [ 47:0]    o_Mant1                ,
    output [ 63:0]    o_Value1               ,
    output [  2:0]    o_Precision_Operand1   ,

    output [  5:0]    o_Type2                ,
    output [  1:0]    o_Sign2                ,
    output [ 15:0]    o_Expo2                ,
    output [ 47:0]    o_Mant2                ,
    output [ 63:0]    o_Value2               ,
    output [  2:0]    o_Precision_Operand2   ,

    output [  3:0]    o_OutSign              ,
    output [ 35:0]    o_OutExpo              ,
    output            o_IsBfloat16           ,
    output            o_N                    
);

wire          is_16_bits    ;
wire          is_32_bits    ;
wire          FPCR_EBF      ;

genvar i,j,k;

wire [31:0] Operand1        [1:0] ;
wire [31:0] Operand2        [1:0] ;
wire [31:0] Addend          [3:0] ;
 
wire [ 2:0] T_TypeA         [3:0] ;
wire        T_SignA         [3:0] ;
wire [ 7:0] T_ExpoA         [3:0] ;
wire [23:0] T_MantA         [3:0] ;
wire [31:0] T_ValueA        [3:0] ;

wire [8:0]  T_OutExpo       [3:0] ;
wire        T_OutSign       [3:0] ;

wire [ 2:0] T_Type1         [1:0] ;
wire        T_Sign1         [1:0] ;
wire [ 1:0] Temp_Sign1            ;
wire [ 1:0] Final_Sign1           ;
wire [ 7:0] T_Expo1         [1:0] ;
wire [23:0] T_Mant1         [1:0] ;
wire [31:0] T_Value1        [1:0] ;

wire [ 2:0] T_Type2         [1:0] ;
wire        T_Sign2         [1:0] ;
wire [ 7:0] T_Expo2         [1:0] ;
wire [ 1:0] Temp_Sign2            ;
wire [23:0] T_Mant2         [1:0] ;
wire [31:0] T_Value2        [1:0] ;

wire [ 2:0] T_BFType1       [1:0] ;
wire        T_BFSign1       [1:0] ;
wire [ 7:0] T_BFExpo1       [1:0] ;
wire [23:0] T_BFMant1       [1:0] ;
wire [31:0] T_BFValue1      [1:0] ;

wire [ 2:0] T_BFType2       [1:0] ;
wire        T_BFSign2       [1:0] ;
wire [ 7:0] T_BFExpo2       [1:0] ;
wire [23:0] T_BFMant2       [1:0] ;
wire [31:0] T_BFValue2      [1:0] ;

wire             is_Double_Vector                       ;
wire             is_Not_Widening                        ;
wire             is_Widening                            ;
wire             FMOP_FP32_Non_Widening                 ;
wire             FMOP_FP16_Non_Widening                 ;
wire             FMOP_Widening                          ;
wire             BFMOP_Widening_SBF                     ;
wire             BFMOP_Widening_EBF                     ;
wire             FDOT                                   ;
wire             FMLA_FP16                              ;
wire             FMLA_FP32                              ;
wire             FMLAL                                  ;
wire [2:0]       Compute_Precision_Addend               ;
wire [2:0]       Compute_Precision_Operand1             ;
wire [2:0]       Compute_Precision_Operand2             ;

assign o_IsBfloat16                 = (i_Compute_Precision == `BF16)                                                  ;
assign o_N                          = (i_Compute_Precision == `FP32) ? 'b1 : 'b0                                      ;
assign is_16_bits                   = ((i_Compute_Precision == `BF16) | (i_Compute_Precision == `FP16)) ? 'b1 : 'b0   ;
assign is_32_bits                   = ((i_Compute_Precision == `FP32)) ? 'b1 : 'b0                                    ;
assign FPCR_EBF                     = (i_Exception_Handling[8] == 1'd1) ? 1'd1 : 1'd0                                 ;
assign o_Precision_Addend           = Compute_Precision_Addend                                                        ;
assign o_Precision_Operand1         = Compute_Precision_Operand1                                                      ;
assign o_Precision_Operand2         = Compute_Precision_Operand2                                                      ;
assign is_Not_Widening              = (i_Is_Widening == `Operands_Is_Not_Widening) ? 1'd1 : 1'd0                      ;
assign is_Widening                  = (i_Is_Widening == `Operands_Is_Widening) ? 1'd1 : 1'd0                          ;
assign Compute_Precision_Addend     = is_16_bits & is_Not_Widening ? `FP16 : `FP32                                    ;
assign Compute_Precision_Operand1   = i_Compute_Precision                                                             ;
assign Compute_Precision_Operand2   = i_Compute_Precision                                                             ;

generate
    for(i = 0 ; i < 2 ; i = i + 1) begin : I_OUT
        for(j = 0 ; j < 2 ; j = j + 1) begin : J_OUT
            assign T_OutExpo[i+j*2]         = ((o_Type1[3*j+:3] == `FPType_Zero) | (o_Type2[3*i+:3] == `FPType_Zero)) ? 'd0 : T_Expo2[i] + T_Expo1[j] ;
            assign T_OutSign[i+j*2]         = Temp_Sign2[i] ^ Final_Sign1[j] ;
            assign o_OutSign[(i+j*2)*1+:1]  = T_OutSign[i+j*2]        ;
            assign o_OutExpo[(i+j*2)*9+:9]  = i_FMLAL ? T_OutExpo[i+j*2] + 'd112 : T_OutExpo[i+j*2]        ;
        end
    end

    for(i = 0 ; i < 4 ; i = i + 1) begin:FPNum_Addend
        assign Addend[i]            = i_Operand_C[32*i+:32] ;
        assign o_TypeA[3*i+:3]      = T_TypeA[i]            ;
        assign o_SignA[1*i+:1]      = T_SignA[i]            ;
        assign o_ExpoA[8*i+:8]      = T_ExpoA[i]            ;
        assign o_MantA[24*i+:24]    = T_MantA[i]            ;
        assign o_ValueA[32*i+:32]   = T_ValueA[i]           ;
    end

    for(j = 0 ; j < 2 ; j = j + 1) begin:FPNum_Operand1
        assign Operand1[j]          = (is_16_bits == 1'd1) ? {16'd0,i_Operand_A[16*j+:16]} : i_Operand_A ;
        assign o_Type1[3*j+:3]      = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand1 == `BF16)) ? T_BFType1[j]  : T_Type1[j]       ;
        assign o_Sign1[1*j+:1]      = Final_Sign1[1*j+:1]                                                                             ;
        assign Temp_Sign1[1*j+:1]   = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand1 == `BF16)) ? T_BFSign1[j]  : T_Sign1[j]       ;
        assign Final_Sign1[1*j+:1]  = i_Add_or_Subtract ? Temp_Sign1[1*j+:1] : ~Temp_Sign1[1*j+:1]                                    ;
        assign o_Expo1[8*j+:8]      = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand1 == `BF16)) ? T_BFExpo1[j]  : T_Expo1[j]       ;
        assign o_Mant1[24*j+:24]    = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand1 == `BF16)) ? T_BFMant1[j]  : T_Mant1[j]       ;
        assign o_Value1[32*j+:32]   = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand1 == `BF16)) ? T_BFValue1[j] : T_Value1[j]      ;
    end

    for(k = 0 ; k < 2 ; k = k + 1) begin:FPNum_Operand2
        assign Operand2[k]          = (is_16_bits == 1'd1) ? {16'd0,i_Operand_B[16*k+:16]} : i_Operand_B ;
        assign o_Type2[3*k+:3]      = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand2 == `BF16)) ? T_BFType2[k]  : T_Type2[k]      ;
        assign o_Sign2[1*k+:1]      = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand2 == `BF16)) ? T_BFSign2[k]  : T_Sign2[k]      ;
        assign Temp_Sign2[1*k+:1]   = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand2 == `BF16)) ? T_BFSign2[k]  : T_Sign2[k]      ;
        assign o_Expo2[8*k+:8]      = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand2 == `BF16)) ? T_BFExpo2[k]  : T_Expo2[k]      ;
        assign o_Mant2[24*k+:24]    = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand2 == `BF16)) ? T_BFMant2[k]  : T_Mant2[k]      ;
        assign o_Value2[32*k+:32]   = ((FPCR_EBF == 1'd0) & (Compute_Precision_Operand2 == `BF16)) ? T_BFValue2[k] : T_Value2[k]     ;
    end

endgenerate

generate
    for(i = 0 ; i < 4 ; i = i + 1) begin:FPUnpackBase_Addend
        C1_FPUnpackBase u_FPUnpackBase_Addend(
            .FP_Number             ( Addend[i]                  ),
            .i_Compute_Precision   ( Compute_Precision_Addend   ),
            .i_Exception_Handling  ( i_Exception_Handling       ),
            .o_FPType              ( T_TypeA[i]                 ),
            .o_FP_Number_Sign      ( T_SignA[i]                 ),
            .o_FP_Exponent         ( T_ExpoA[i]                 ),
            .o_FP_Mantissa         ( T_MantA[i]                 ),
            .o_FP_Number_Value     ( T_ValueA[i]                )
        );
    end
    
    for(j = 0 ; j < 2 ; j = j + 1) begin:FPUnpackBase_Operand1
        C1_FPUnpackBase u_FPUnpackBase_Operand1(
            .FP_Number             ( Operand1[j]                    ),
            .i_Compute_Precision   ( Compute_Precision_Operand1     ),
            .i_Exception_Handling  ( i_Exception_Handling           ),
            .o_FPType              ( T_Type1[j]                     ),
            .o_FP_Number_Sign      ( T_Sign1[j]                     ),
            .o_FP_Exponent         ( T_Expo1[j]                     ),
            .o_FP_Mantissa         ( T_Mant1[j]                     ),
            .o_FP_Number_Value     ( T_Value1[j]                    )
        );
    end

    for(k = 0 ; k < 2 ; k = k + 1) begin:FPUnpackBase_Operand2
        C1_FPUnpackBase u_FPUnpackBase_Operand2(
            .FP_Number             ( Operand2[k]                    ),
            .i_Compute_Precision   ( Compute_Precision_Operand2     ),
            .i_Exception_Handling  ( i_Exception_Handling           ),
            .o_FPType              ( T_Type2[k]                     ),
            .o_FP_Number_Sign      ( T_Sign2[k]                     ),
            .o_FP_Exponent         ( T_Expo2[k]                     ),
            .o_FP_Mantissa         ( T_Mant2[k]                     ),
            .o_FP_Number_Value     ( T_Value2[k]                    )
        );
    end

    for(j = 0 ; j < 2 ; j = j + 1) begin:BFUnpack_Operand1
        C1_BFUnpack u_BFUnpack_Operand1(
            .BF_Number          ( Operand1[j]           ),
            .i_BF_Data_Width    ( `BF_Data_Width_16     ),
            .o_BFType           ( T_BFType1[j]          ),
            .o_BF_Number_Sign   ( T_BFSign1[j]          ),
            .o_BF_Mantissa      ( T_BFMant1[j]          ),
            .o_BF_Exponent      ( T_BFExpo1[j]          ),
            .o_BF_Number_Value  ( T_BFValue1[j]         )
        );
    end

    for(k = 0 ; k < 2 ; k = k + 1) begin:BFUnpack_Operand2
        C1_BFUnpack u_BFUnpack_Operand2(
            .BF_Number          ( Operand2[k]           ),
            .i_BF_Data_Width    ( `BF_Data_Width_16     ),
            .o_BFType           ( T_BFType2[k]          ),
            .o_BF_Number_Sign   ( T_BFSign2[k]          ),
            .o_BF_Mantissa      ( T_BFMant2[k]          ),
            .o_BF_Exponent      ( T_BFExpo2[k]          ),
            .o_BF_Number_Value  ( T_BFValue2[k]         )
        );
    end

endgenerate

endmodule
