`timescale 1ns / 1ps
`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 

    
*/

module C1_ExceptionHandling (
    input  [ 31:0]    i_Operand_A            ,
    input  [ 31:0]    i_Operand_B            ,
    input  [127:0]    i_Operand_C            ,

    input  [ 11:0]    i_TypeA                ,
    input  [  3:0]    i_SignA                ,
    input  [  2:0]    i_Precision_Addend     ,

    input  [  5:0]    i_Type1                ,
    input  [  1:0]    i_Sign1                ,

    input  [  5:0]    i_Type2                ,
    input  [  1:0]    i_Sign2                ,

    input             i_Compute_Mode         ,
    input             i_Is_Widening          ,
    input  [  1:0]    i_Vector_Group_Num     ,
    input  [  2:0]    i_Compute_Precision    ,
    input  [ 19:0]    i_Exception_Handling   ,
    output [  3:0]    o_Is_Exception         ,
    output [127:0]    o_Result               ,
    output            o_Keep_Expo_signed     ,
    output            o_Internal_Acc         ,
    output            o_Widening_SBF         ,
    output            FMOP_FP16_Non_Widening ,
    output            o_FMLAL
);


wire [ 3:0]      InfA                       ;
wire [ 1:0]      Inf1                       ;
wire [ 1:0]      Inf2                       ;
wire [ 3:0]      ZeroA                      ;
wire [ 1:0]      Zero1                      ;
wire [ 1:0]      Zero2                      ;
wire [ 1:0]      QNaN1                      ;
wire [ 1:0]      QNaN2                      ;
wire             FPCR_EBF                   ;
wire             FPCR_AH                    ;
wire [31:0]      FPInfinity    [3:0]        ;
wire [31:0]      FPDefaultNaN  [3:0]        ;
wire [31:0]      FPZero        [3:0]        ;
wire [31:0]      Grap_Result   [3:0]        ;

wire [31:0]      T_Result      [3:0]        ;
wire [31:0]      T_Verify      [3:0]        ;
wire             T_Defau_NaN   [3:0]        ;
wire             T_Infinity    [3:0]        ;
wire             T_Ve_Zero     [3:0]        ;
wire [ 3:0]      Done                       ;
wire [ 3:0]      SignP                      ;
wire [ 3:0]      InfP                       ;
wire [ 3:0]      ZeroP                      ;
wire [ 3:0]      InvalidOp                  ;
wire             SignPa        [3:0]        ;
wire             SignPb        [3:0]        ;
wire             InfPa         [3:0]        ;
wire             InfPb         [3:0]        ;
wire             ZeroPa        [3:0]        ;
wire             ZeroPb        [3:0]        ;
// reg  [ 1:0]      Caculate_Mode              ;
wire [ 3:0]      FPInfinity_Sign            ;
wire [ 3:0]      FPZero_Sign                ;
wire [ 3:0]      FPInfinity_Data_Width      ;
wire [ 3:0]      FPZero_Data_Width          ;
wire [ 3:0]      FPDefaultNaN_Data_Width    ;
// reg  [ 1:0]      Operand_Num                ;

wire [ 11:0]     FP16NoWidType    [3:0]     ;
wire [127:0]     FP16Number       [3:0]     ;
wire [ 31:0]     FP16NoWidResult  [3:0]     ;
wire             FP16NoWidDone    [3:0]     ;
wire [ 31:0]     NaNResult        [3:0]     ;
wire             NaNDone          [3:0]     ;
wire             FPCR_DN                    ;
wire             NaNProcess                 ;
wire [127:0]     Temp_Result                ;
wire [  3:0]     Temp_Is_Exception          ;
wire [  3:0]     T_Is_Exception             ;
wire [ 31:0]     FPNumNaNResult             ;
wire             FPNumNaNDone               ;

wire             is_Outer_Product                       ;
wire             is_Inner_Product                       ;
wire             is_FP32                                ;
wire             is_FP16                                ;
wire             is_BF16                                ;
wire             is_Single_Vector                       ;
wire             is_Double_Vector                       ;
wire             is_Not_Widening                        ;
wire             is_Widening                            ;
wire             FMOP_FP32_Non_Widening                 ;
// wire             FMOP_FP16_Non_Widening                 ;
wire             FMOP_Widening                          ;
wire             BFMOP_Widening_SBF                     ;
wire             BFMOP_Widening_EBF                     ;
wire             FDOT                                   ;
wire             FMLA_FP16                              ;
wire             FMLA_FP32                              ;
wire             FMLAL                                  ;
wire [  2:0]     Caculate_Mode                          ;
wire [  1:0]     Operand_Num                            ;
wire [  3:0]     FPNumNaNWidth                          ;
wire [ 11:0]     FPNumNaNType                           ;
wire [127:0]     FPNumNaNNumber                         ;
wire             is_Addend_FP32                         ;
wire             is_FPMulAdd_ZA                         ;
wire             is_FPDotAdd_ZA                         ;
wire             is_SBFDotAdd_ZA                        ;
wire             is_None_ZA                             ;
wire             Exception_Result                       ;
wire [  3:0]     FPMulAdd_P_FPInfinity                  ;
wire [  3:0]     FPMulAdd_N_FPInfinity                  ;
wire [  3:0]     FPMulAdd_Zero                          ;
wire [  3:0]     FPMulAdd_Diff_Sign_Zero                ;
wire [  3:0]     FPDotAdd_P_FPInfinity                  ;
wire [  3:0]     FPDotAdd_N_FPInfinity                  ;
wire [  3:0]     FPDotAdd_Zero                          ;
wire [  3:0]     SBFDotAdd_FPDefaultNaN                 ;
wire [  3:0]     SBFDotAdd_FPInfinity                   ;
wire [  3:0]     SBFDotAdd_Zero                         ;
wire [127:0]     Temp_Operand_C                         ;
wire [ 11:0]     Temp_TypeA                             ;
wire [  3:0]     Temp_SignA                             ;
wire [  1:0]     FPCR_RMode                             ;

genvar i,j,k;

assign FPCR_AH          = i_Exception_Handling[1]  ;
assign FPCR_EBF         = i_Exception_Handling[8]  ;
assign FPCR_DN          = i_Exception_Handling[18] ;
assign FPCR_RMode       = i_Exception_Handling[16:15]   ;
assign NaNProcess       = ((Caculate_Mode == 2'd0 ) | (Caculate_Mode == 2'd3)) & i_Compute_Precision == `FP16   ;
// assign o_Result         = Temp_Result                                                                           ;
// assign o_Is_Exception   = Temp_Is_Exception                                                                     ;

assign o_Result         = {Temp_Result[127:96],Temp_Result[63:32],Temp_Result[95:64],Temp_Result[31:0]}         ;

// assign o_Is_Exception   = {4{Exception_Result}} & T_Is_Exception                                                ;
assign o_Is_Exception   = {Temp_Is_Exception[3],Temp_Is_Exception[1],Temp_Is_Exception[2],Temp_Is_Exception[0]} ;
assign Temp_Operand_C   = {i_Operand_C[127:96],i_Operand_C[63:32],i_Operand_C[95:64],i_Operand_C[31:0]}         ;
assign Temp_TypeA       = {i_TypeA[11:9],i_TypeA[5:3],i_TypeA[8:6],i_TypeA[2:0]}                                ;
assign Temp_SignA       = {i_SignA[3],i_SignA[1],i_SignA[2],i_SignA[0]}                                         ;



generate
    for(i = 0 ; i < 4 ; i = i + 1) begin : OP_A
        assign InfA[i]  = (Temp_TypeA[i*3+:3] == `FPType_Infinity) ? 1'd1 : 1'd0    ;
        assign ZeroA[i] = (Temp_TypeA[i*3+:3] == `FPType_Zero) ? 1'd1 : 1'd0        ;
    end

    for(j = 0 ; j < 2 ; j = j + 1) begin : OP_1
        assign Inf1[j]  = (i_Type1[j*3+:3] == `FPType_Infinity) ? 1'd1 : 1'd0    ;
        assign Zero1[j] = (i_Type1[j*3+:3] == `FPType_Zero) ? 1'd1 : 1'd0        ;
        assign QNaN1[j] = (i_Type1[j*3+:3] == `FPType_QNaN) ? 1'd1 : 1'd0        ;
    end

    for(k = 0 ; k < 2 ; k = k + 1) begin : OP_2
        assign Inf2[k]  = (i_Type2[k*3+:3] == `FPType_Infinity) ? 1'd1 : 1'd0    ;
        assign Zero2[k] = (i_Type2[k*3+:3] == `FPType_Zero) ? 1'd1 : 1'd0        ;
        assign QNaN2[k] = (i_Type2[k*3+:3] == `FPType_QNaN) ? 1'd1 : 1'd0        ;
    end

    for(i = 0 ; i < 4 ; i = i + 1) begin : Out
        assign NaNResult            [i]         = (NaNProcess == 1'd1) ? FP16NoWidResult[i] : FPNumNaNResult      ;
        assign NaNDone              [i]         = (NaNProcess == 1'd1) ? FP16NoWidDone[i] : FPNumNaNDone          ;
        assign Grap_Result          [i]         = (NaNDone[i] == 1'd1) ? NaNResult[i] : T_Result[i]               ;
        assign Temp_Result          [i*32+:32]  = Grap_Result[i] | FP16NoWidResult[i]                             ;
        // assign Temp_Is_Exception    [i]         = FP16NoWidDone[i] | NaNDone[i] | (((InvalidOp[i] & (is_Addend_FP32 | is_FPDotAdd_ZA)) | (is_SBFDotAdd_ZA & (SBFDotAdd_FPDefaultNaN[i])))) | ((((is_Addend_FP32 | is_FPMulAdd_ZA) & (FPMulAdd_P_FPInfinity[i] | FPMulAdd_N_FPInfinity[i])) | (is_FPDotAdd_ZA & (FPDotAdd_P_FPInfinity[i] | FPDotAdd_N_FPInfinity[i])) | (is_SBFDotAdd_ZA & SBFDotAdd_FPInfinity))) | (((is_Addend_FP32 | is_FPMulAdd_ZA) & (FPMulAdd_Zero[i] | FPMulAdd_Diff_Sign_Zero[i])) | (is_FPDotAdd_ZA & FPDotAdd_Zero[i] | (is_SBFDotAdd_ZA & SBFDotAdd_Zero[i]))) ;
        assign Temp_Is_Exception    [i]         = FP16NoWidDone[i] | NaNDone[i] | T_Defau_NaN[i] | T_Infinity[i] | T_Ve_Zero[i] ;
    end
endgenerate

assign is_Outer_Product       = (i_Compute_Mode == `Outer_Product) ? 1'd1 : 1'd0 ;
assign is_Inner_Product       = (i_Compute_Mode == `Inner_Product) ? 1'd1 : 1'd0 ;
assign is_FP32                = (i_Compute_Precision == `FP32) ? 1'd1 : 1'd0 ;
assign is_FP16                = (i_Compute_Precision == `FP16) ? 1'd1 : 1'd0 ;
assign is_BF16                = (i_Compute_Precision == `BF16) ? 1'd1 : 1'd0 ;
assign is_Single_Vector       = (i_Vector_Group_Num == `Single_Vector_Group) ? 1'd1 : 1'd0;
assign is_Double_Vector       = (i_Vector_Group_Num == `Double_Vector_Group) ? 1'd1 : 1'd0;
assign is_Not_Widening        = (i_Is_Widening == `Operands_Is_Not_Widening) ? 1'd1 : 1'd0;
assign is_Widening            = (i_Is_Widening == `Operands_Is_Widening) ? 1'd1 : 1'd0;


assign o_Keep_Expo_signed     = FMOP_Widening | FDOT | FMLAL | BFMOP_Widening_EBF;
assign FMOP_FP32_Non_Widening = (is_Outer_Product & is_FP32 & is_Not_Widening) ? 1'd1 : 1'd0 ;
assign FMOP_FP16_Non_Widening = (is_Outer_Product & is_FP16 & is_Not_Widening) ? 1'd1 : 1'd0 ;
assign FMOP_Widening          = (is_Outer_Product & is_FP16 & is_Widening) ? 1'd1 : 1'd0 ;
assign BFMOP_Widening_SBF     = (is_Outer_Product & is_BF16 & is_Widening & ~FPCR_EBF) ? 1'd1 : 1'd0 ;
assign BFMOP_Widening_EBF     = (is_Outer_Product & is_BF16 & is_Widening & FPCR_EBF) ? 1'd1 : 1'd0 ;
assign FDOT                   = (is_Inner_Product & is_FP16 & is_Widening & is_Single_Vector) ? 1'd1 : 1'd0 ;
assign FMLA_FP16              = (is_Inner_Product & is_FP16 & is_Not_Widening & is_Single_Vector) ? 1'd1 : 1'd0 ;
assign FMLA_FP32              = (is_Inner_Product & is_FP32 & is_Not_Widening & is_Single_Vector) ? 1'd1 : 1'd0 ;
assign FMLAL                  = (is_Inner_Product & is_FP16 & is_Widening & is_Double_Vector) ? 1'd1 : 1'd0 ;
assign Exception_Result       = FMOP_FP32_Non_Widening | FMOP_FP16_Non_Widening | FMLA_FP16 | FMLA_FP32 ;
assign o_Widening_SBF         = BFMOP_Widening_SBF | FMLAL                                                     ;
assign o_FMLAL                = FMLAL                                                                          ;

assign o_Internal_Acc         = FMOP_Widening | BFMOP_Widening_SBF | BFMOP_Widening_EBF | FDOT | FMLAL;

assign Caculate_Mode          = {2{(FMOP_FP32_Non_Widening | FMOP_FP16_Non_Widening | FMLA_FP16 | FMLA_FP32 | FMLAL)}} & 2'd0 | 
                                    {2{(FMOP_Widening | BFMOP_Widening_EBF | FDOT)}} & 2'd1 |
                                    {2{(BFMOP_Widening_SBF)}} & 2'd2 |
                                    {2{~(FMOP_FP32_Non_Widening | FMOP_FP16_Non_Widening | FMLA_FP16 | FMLA_FP32 | FMLAL | FMOP_Widening | BFMOP_Widening_EBF | FDOT | BFMOP_Widening_SBF)}} & 2'd3 ;
assign Operand_Num            = {2{BFMOP_Widening_SBF}} & 2'b00 | 
                                    {2{FMOP_FP32_Non_Widening | FMOP_FP16_Non_Widening | FMLA_FP16 | FMLA_FP32}} & 2'b01 |
                                    {2{FMLAL}} & 2'b10 | 
                                    {2{FMOP_Widening | BFMOP_Widening_EBF | FDOT}} & 2'b11 ;
assign FPNumNaNType           = ({12{FMOP_FP32_Non_Widening | FMLA_FP32}} & {`FPType_Zero,i_Type2[2:0],i_Type1[2:0],Temp_TypeA[2:0]}) |
                                    ({12{FMOP_Widening | BFMOP_Widening_EBF | FDOT}} & {i_Type2[5:3],i_Type2[2:0],i_Type1[5:3],i_Type1[2:0]}) |
                                    ({12{~(FMOP_FP32_Non_Widening | FMLA_FP32 | FMOP_Widening | BFMOP_Widening_EBF | FDOT)}} & {`FPType_Zero,`FPType_Zero,`FPType_Zero,`FPType_Zero}) ;

assign FPNumNaNWidth          = {4{FMOP_FP16_Non_Widening | FMOP_Widening | BFMOP_Widening_SBF | FDOT | FMLA_FP16}} & 4'b0000 |
                                    {4{FMLAL}} &  4'b0001 | 
                                    {4{FMOP_FP32_Non_Widening | BFMOP_Widening_EBF | FMLA_FP32}} & 4'b1111 |
                                    {4{~(FMOP_FP16_Non_Widening | FMOP_Widening | BFMOP_Widening_SBF | FDOT | FMLA_FP16 | FMLAL | FMOP_FP32_Non_Widening | BFMOP_Widening_EBF | FMLA_FP32)}} & 4'b0001 ;
assign FPNumNaNNumber         = {128{FMOP_FP32_Non_Widening | FMLA_FP32}} & {32'd0,i_Operand_B,i_Operand_A,Temp_Operand_C[31:0]} | 
                                    {128{FMOP_Widening | BFMOP_Widening_EBF | FDOT}} & {{16'd0,i_Operand_B[31:16]},{16'd0,i_Operand_B[15:0]},{16'd0,i_Operand_A[31:16]},{16'd0,i_Operand_A[15:0]}};

assign is_Addend_FP32         = (i_Precision_Addend == `FP32) ? 1'd1 : 1'd0 ;
assign is_Addend_FP16         = (i_Precision_Addend == `FP16) ? 1'd1 : 1'd0 ;
assign is_FPMulAdd_ZA         = (Caculate_Mode == 2'd0) ? 1'd1 : 1'd0       ;
assign is_FPDotAdd_ZA         = (Caculate_Mode == 2'd1) ? 1'd1 : 1'd0       ;
assign is_SBFDotAdd_ZA        = (Caculate_Mode == 2'd2) ? 1'd1 : 1'd0       ;
assign is_None_ZA             = (Caculate_Mode == 2'd3) ? 1'd1 : 1'd0       ;

generate 
    for(i = 0 ; i < 2 ; i = i + 1) begin : OP2
        for(j = 0 ; j < 2 ; j = j + 1) begin : OP1

            assign FP16NoWidType[i*2+j]            = {`FPType_Nonzero,i_Type2[i*3+:3],i_Type1[j*3+:3],Temp_TypeA[3*(i*2+j)+:3]}                                ;
            assign FP16Number[i*2+j]               = {32'd0,{16'd0,i_Operand_B[i*16+:16]},{16'd0,i_Operand_A[j*16+:16]},Temp_Operand_C[32*(i*2+j)+:32]}        ;
            assign SignP[i*2+j]                    = i_Sign1[j] ^ i_Sign2[i]                                                                                ;
            assign InfP[i*2+j]                     = Inf1[j] | Inf2[i]                                                                                      ;
            assign ZeroP[i*2+j]                    = Zero1[j] | Zero2[i]                                                                                    ;
            assign SignPa [i*2+j]                  = (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA ) ? i_Sign1[0] ^ i_Sign2[0] : 1'd0 ; //signed to unsigned conversion occurs
            assign SignPb [i*2+j]                  = (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA ) ? i_Sign1[1] ^ i_Sign2[1] : 1'd0 ;
            assign InfPa  [i*2+j]                  = (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA ) ? Inf1[0] | Inf2[0]       : 1'd0 ;
            assign InfPb  [i*2+j]                  = (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA ) ? Inf1[1] | Inf2[1]       : 1'd0 ;
            assign ZeroPa [i*2+j]                  = (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA ) ? Zero1[0] | Zero2[0]     : 1'd0 ;
            assign ZeroPb [i*2+j]                  = (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA ) ? Zero1[1] | Zero2[1]     : 1'd0 ; //signed to unsigned conversion occurs

            // Non SNaN-generated Invalid Operation cases are multiplies of zeroby infinity and additions of opposite-signed infinities. 
            assign InvalidOp[i*2+j]                = (is_FPMulAdd_ZA & ((Inf1[j] & Zero2[i]) | (Zero1[j] & Inf2[i]) | (InfA[i*2+j] & InfP[i*2+j] & (SignP[i*2+j] != Temp_SignA[i*2+j])))) 
                                                        | (((i*2 + j) == 2'd0) & is_FPDotAdd_ZA & ((Inf1[0] & Zero2[0]) | (Zero1[0] & Inf2[0]) | (Inf1[1] & Zero2[1]) | (Zero1[1] & Inf2[1]) | (InfPa[i*2+j] & InfPb[i*2+j] & (SignPa[i*2+j] != SignPb[i*2+j]))));
            
            //signed to unsigned conversion occurs
            assign FPMulAdd_P_FPInfinity[i*2+j]    = (InfA[i*2+j] & (Temp_SignA[i*2+j] == 1'd0)) | (InfP[i*2+j] & (SignP[i*2+j] == 1'd0))       ;
            assign FPMulAdd_N_FPInfinity[i*2+j]    = (InfA[i*2+j] & (Temp_SignA[i*2+j] == 1'd1)) | (InfP[i*2+j] & (SignP[i*2+j] == 1'd1))       ;
            assign FPMulAdd_Zero        [i*2+j]    = ZeroA[i*2+j] & ZeroP[i*2+j] & SignP[i*2+j] == Temp_SignA[i*2+j]                            ;
            assign FPMulAdd_Diff_Sign_Zero[i*2+j]  = ZeroA[i*2+j] & ZeroP[i*2+j] & SignP[i*2+j] != Temp_SignA[i*2+j]                            ;
            assign FPDotAdd_P_FPInfinity[i*2+j]    = (InfPa[i*2+j] & (SignPa[i*2+j] == 1'd0)) | (InfPb[i*2+j] & (SignPb[i*2+j] == 1'd0))        ;
            assign FPDotAdd_N_FPInfinity[i*2+j]    = (InfPa[i*2+j] & (SignPa[i*2+j] == 1'd1)) | (InfPb[i*2+j] & (SignPb[i*2+j] == 1'd1))        ;
            assign FPDotAdd_Zero        [i*2+j]    = ZeroPa[i*2+j] & ZeroPb[i*2+j] & (SignPa[i*2+j] == SignPb[i*2+j])                           ;
            assign SBFDotAdd_FPDefaultNaN[i*2+j]   = (QNaN1[j] | QNaN2[i] | (Inf1[j] & Zero2[i]) | (Inf2[i] & Zero1[j]))                        ;
            assign SBFDotAdd_FPInfinity  [i*2+j]   = Inf1[j] | Inf2[i]                                                                          ;
            assign SBFDotAdd_Zero        [i*2+j]   = Zero1[j] | Zero2[i]                                                                        ;

            assign FPDefaultNaN_Data_Width[i*2+j]  = ((InvalidOp[i*2+j] & is_Addend_FP32 & (is_FPMulAdd_ZA | is_FPDotAdd_ZA)) | (is_SBFDotAdd_ZA & SBFDotAdd_FPDefaultNaN[i*2+j]))         ;
            assign FPInfinity_Sign[i*2+j]          = ((is_FPMulAdd_ZA & FPMulAdd_N_FPInfinity[i*2+j]) | (is_FPDotAdd_ZA & FPDotAdd_N_FPInfinity[i*2+j])) & 1'd1 | (is_SBFDotAdd_ZA) & (i_Sign1[j] ^ i_Sign2[i]);
            assign FPInfinity_Data_Width[i*2+j]    = (is_FPMulAdd_ZA & (FPMulAdd_P_FPInfinity[i*2+j] | FPMulAdd_N_FPInfinity[i*2+j]) & is_Addend_FP32) | (is_FPDotAdd_ZA & (FPDotAdd_P_FPInfinity[i*2+j] | FPDotAdd_N_FPInfinity[i*2+j]) & is_Addend_FP32) | (is_SBFDotAdd_ZA & SBFDotAdd_FPInfinity[i*2+j]);
            assign FPZero_Data_Width[i*2+j]        = (is_FPMulAdd_ZA & (FPMulAdd_Zero[i*2+j] | FPMulAdd_Diff_Sign_Zero[i*2+j]) & is_Addend_FP32) | (is_FPDotAdd_ZA & FPDotAdd_Zero[i*2+j] & is_Addend_FP32) | (is_SBFDotAdd_ZA & SBFDotAdd_Zero);
            assign FPZero_Sign[i*2+j]              = (is_FPMulAdd_ZA & FPMulAdd_Zero) & Temp_SignA[i*2+j] | (is_FPMulAdd_ZA & FPDotAdd_Zero) & SignPa[i*2+j] | ((is_SBFDotAdd_ZA & SBFDotAdd_Zero) | FMLAL) & (i_Sign1[j] ^ i_Sign2[i]);
            assign T_Result[i*2+j]                 = {32{T_Defau_NaN[i*2+j]}} & FPDefaultNaN[i*2+j] | 
                                                        {32{T_Infinity[i*2+j] & ~T_Defau_NaN[i*2+j]}} & FPInfinity[i*2+j] |
                                                        {32{T_Ve_Zero[i*2+j] & ~T_Defau_NaN[i*2+j] & ~T_Infinity[i*2+j]}} & FPZero[i*2+j] ;
            assign T_Verify[i*2+j]                  = {32{((is_Addend_FP32 | is_FPMulAdd_ZA) & (FPMulAdd_P_FPInfinity[i*2+j] | FPMulAdd_N_FPInfinity[i*2+j])) | (is_FPDotAdd_ZA & (FPDotAdd_P_FPInfinity[i*2+j] | FPDotAdd_N_FPInfinity[i*2+j])) | (is_SBFDotAdd_ZA & SBFDotAdd_FPInfinity[i*2+j])}};
            assign T_Defau_NaN[i*2+j]               = ((InvalidOp[i*2+j] & (is_Addend_FP32 | is_FPDotAdd_ZA | (FMOP_FP32_Non_Widening | FMOP_FP16_Non_Widening | FMLA_FP32 | FMLA_FP16))) | (is_SBFDotAdd_ZA & (SBFDotAdd_FPDefaultNaN[i*2+j])));
            assign T_Infinity [i*2+j]               = ((is_Addend_FP32 | is_FPMulAdd_ZA) & (FPMulAdd_P_FPInfinity[i*2+j] | FPMulAdd_N_FPInfinity[i*2+j])) | (is_FPDotAdd_ZA & (FPDotAdd_P_FPInfinity[i*2+j] | FPDotAdd_N_FPInfinity[i*2+j])) | (is_SBFDotAdd_ZA & SBFDotAdd_FPInfinity[i*2+j]);
            // assign T_Ve_Zero  [i*2+j]               = ((is_Addend_FP32 | is_FPMulAdd_ZA) & (FPMulAdd_Zero[i*2+j] | FPMulAdd_Diff_Sign_Zero[i*2+j])) | (is_FPDotAdd_ZA & FPDotAdd_Zero[i*2+j] | (is_SBFDotAdd_ZA & SBFDotAdd_Zero[i*2+j]))                                              ;
            assign T_Ve_Zero  [i*2+j]               = ((is_Addend_FP32 | is_FPMulAdd_ZA) & (FPMulAdd_Zero[i*2+j] | FPMulAdd_Diff_Sign_Zero[i*2+j])) | (is_FPDotAdd_ZA & FPDotAdd_Zero[i*2+j] | (is_SBFDotAdd_ZA & SBFDotAdd_Zero[i*2+j]))                                              ;

        end 

    end
endgenerate

generate
    for(i = 0 ; i < 4 ; i = i + 1) begin : U_FPInfinity
        C1_FPInfinity u_FPInfinity(
            .i_Sign        ( FPInfinity_Sign[i]        ),
            .i_Data_Width  ( FPInfinity_Data_Width[i]  ),
            .o_FPInfinity  ( FPInfinity[i]             )
        );
    end

    for(j = 0 ; j < 4 ; j = j + 1) begin : U_FPDefaultNaN
        C1_FPDefaultNaN u_FPDefaultNaN(
            .i_FPCR_AH     ( FPCR_AH                       ),
            .i_Data_Width  ( FPDefaultNaN_Data_Width[j]    ),
            .o_DefaultNaN  ( FPDefaultNaN[j]               )
        );
    end

    for(k = 0 ; k < 4 ; k = k + 1) begin : U_FPZero
        C1_FPZero u_FPZero(
            .i_Sign          ( FPZero_Sign[k]               ),
            .i_Data_Width    ( FPZero_Data_Width[k]         ),
            .i_FMLAL         ( o_Widening_SBF               ),
            .i_DiffSign_Zero ( FPMulAdd_Diff_Sign_Zero[k]   ),
            .i_FPCR_RMode    ( FPCR_RMode                   ),
            .o_FPZero        ( FPZero[k]                    )
        );
    end

    for(i = 0 ; i < 4 ; i = i + 1) begin : U_FPProcessNaN
        C1_FPProcessNaNs u_FPProcessFP16NaNs(
            .i_FPCR_AH      ( FPCR_AH            ),
            .i_FPCR_DN      ( FPCR_DN            ),
            .i_Operand_Num  ( Operand_Num        ),
            .i_Type         ( FP16NoWidType[i]   ),
            .i_Data_Width   ( FPNumNaNWidth      ),
            .i_FPNumber     ( FP16Number[i]      ),
            .o_FP_Result    ( FP16NoWidResult[i] ),
            .o_Done         ( FP16NoWidDone[i]   )
        );
    end

endgenerate

C1_FPProcessNaNs u_FPProcessNaNs(
    .i_FPCR_AH      ( FPCR_AH            ),
    .i_FPCR_DN      ( FPCR_DN            ),
    .i_Operand_Num  ( Operand_Num        ),
    .i_Type         ( FPNumNaNType       ),
    .i_Data_Width   ( FPNumNaNWidth      ),
    .i_FPNumber     ( FPNumNaNNumber     ),
    .o_FP_Result    ( FPNumNaNResult     ),
    .o_Done         ( FPNumNaNDone       )
);

endmodule