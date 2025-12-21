`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C1_FPMutiArray (
    input  [  2:0]    i_Compute_Precision    ,
    input  [ 31:0]    i_Operand_A            ,
    input  [ 31:0]    i_Operand_B            ,
    output [191:0]    o_Mant                 
);

wire           SignA             ;
wire           HiddenBitA        ;
wire  [ 7:0]   Exp32A            ;
wire  [23:0]   Frac32A           ;
wire           SignB             ;
wire           HiddenBitB        ;
wire  [ 7:0]   Exp32B            ;
wire  [23:0]   Frac32B           ;
wire  [47:0]   FP32Muti_Result   ;       

wire  [ 4:0]   ExpFP16A         [1:0]   ;
wire           FP16HiddenBitA   [1:0]   ;
wire  [10:0]   FracFP16A        [1:0]   ;
wire  [ 4:0]   ExpFP16B         [1:0]   ;
wire           FP16HiddenBitB   [1:0]   ;
wire  [10:0]   FracFP16B        [1:0]   ;
wire  [21:0]   FP16Result       [3:0]   ;

wire  [ 7:0]   ExpBF16A         [1:0]   ;
wire           BF16HiddenBitA   [1:0]   ;
wire  [ 7:0]   FracBF16A        [1:0]   ;
wire  [ 7:0]   ExpBF16B         [1:0]   ;
wire           BF16HiddenBitB   [1:0]   ;
wire  [ 7:0]   FracBF16B        [1:0]   ;
wire  [15:0]   BF16Result       [3:0]   ;

wire  [47:0]   FloatResult      [3:0]   ;

wire           Is_16_bits               ;
wire           Is_32_bits               ;

wire [ 47:0]   T_Mant00                 ;
wire [ 47:0]   T_Mant01                 ;
wire [ 47:0]   T_Mant10                 ;
wire [ 47:0]   T_Mant11                 ;
wire [191:0]   T_Mant                   ;
genvar i,j,k;

generate
    for(i = 0 ; i < 2 ; i = i + 1) begin : FP16UnpackVar
        assign ExpFP16A         [i] = i_Operand_A[16*i+14:16*i+10]                              ;
        assign FP16HiddenBitA   [i] = ((~(|ExpFP16A[i] == 1'd0)) & (~(&ExpFP16A[i] == 1'd1)))  ;
        assign FracFP16A        [i] = {FP16HiddenBitA[i],i_Operand_A[16*i+9:16*i]}              ;
        assign ExpFP16B         [i] = i_Operand_B[16*i+14:16*i+10]                              ;
        assign FP16HiddenBitB   [i] = ((~(|ExpFP16B[i] == 1'd0)) & (~(&ExpFP16B[i] == 1'd1)))  ;
        assign FracFP16B        [i] = {FP16HiddenBitB[i],i_Operand_B[16*i+9:16*i]}              ;
    end
    
    for(i = 0 ; i < 2 ; i = i + 1) begin : I_FP16Muti
        for(j = 0 ; j < 2 ; j = j + 1) begin : J_FP16Muti
            assign FP16Result[i+j*2] = FracFP16B[i] * FracFP16A[j]  ;
        end
    end

    for(i = 0 ; i < 2 ; i = i + 1) begin : BF16UnpackVar
        assign ExpBF16A         [i] = i_Operand_A[16*i+14:16*i+7]                               ;
        assign BF16HiddenBitA   [i] = ((~(|ExpBF16A[i] == 1'd0)) & (~(&ExpBF16A[i] == 1'd1)))  ;
        assign FracBF16A        [i] = {BF16HiddenBitA[i],i_Operand_A[16*i+6:16*i]}              ;
        assign ExpBF16B         [i] = i_Operand_B[16*i+14:16*i+7]                               ;
        assign BF16HiddenBitB   [i] = ((~(|ExpBF16B[i] == 1'd0)) & (~(&ExpBF16B[i] == 1'd1)))  ;
        assign FracBF16B        [i] = {BF16HiddenBitB[i],i_Operand_B[16*i+6:16*i]}              ;
    end

    // for(i = 0 ; i < 2 ; i = i + 1) begin : I_BF16Muti
    //     for(j = 0 ; j < 2 ; j = j + 1) begin : J_BF16Muti
    //         assign BF16Result[i*2+j] = FracBF16B[i] * FracBF16A[j]  ;
    //     end
    // end

    for(k = 0 ; k < 4 ; k = k + 1) begin : FPRESULT
        assign FloatResult[k] = {48{(i_Compute_Precision == `FP16)}} & {26'd0,FP16Result[k]} | 
                                    {48{(i_Compute_Precision == `BF16)}} & {BF16Result[k],32'd0} | 
                                    {48{i_Compute_Precision == `FP32}} & FP32Muti_Result ;
    end
endgenerate

assign T_Mant       = {T_Mant11,T_Mant10,T_Mant01,T_Mant00}                                           ;
assign T_Mant00     = FloatResult[0]                                                                  ;
assign T_Mant01     = FloatResult[1]                                                                  ; 
assign T_Mant10     = FloatResult[2]                                                                  ;  
assign T_Mant11     = FloatResult[3]                                                                  ; 
assign Is_16_bits   = ((i_Compute_Precision == `BF16) | (i_Compute_Precision == `FP16))               ;
assign Is_32_bits   = ((i_Compute_Precision == `FP32))                                                ;
assign SignA        = i_Operand_A[31]                                                                 ;
assign SignB        = i_Operand_B[31]                                                                 ;
assign Exp32A       = i_Operand_A[30:23]                                                              ;
assign Exp32B       = i_Operand_B[30:23]                                                              ;
assign HiddenBitA   = ((~(|Exp32A == 1'd0)) & (~(&Exp32A == 1'd1)))                                  ;
assign HiddenBitB   = ((~(|Exp32B == 1'd0)) & (~(&Exp32B == 1'd1)))                                  ;
assign Frac32A      = {HiddenBitA,i_Operand_A[22:0]}                                                  ;
assign Frac32B      = {HiddenBitB,i_Operand_B[22:0]}                                                  ;

assign Exp32A     = i_Operand_A[30:23];
assign Exp32B     = i_Operand_B[30:23];
assign HiddenBitA = ((~(|Exp32A == 1'd0)) & (~(&Exp32A == 1'd1)));
assign HiddenBitB = ((~(|Exp32B == 1'd0)) & (~(&Exp32B == 1'd1)));
assign Frac32A    = {HiddenBitA, i_Operand_A[22:0]};
assign Frac32B    = {HiddenBitB, i_Operand_B[22:0]};

wire mode_fp16 = (i_Compute_Precision == `FP16);
wire mode_bf16 = (i_Compute_Precision == `BF16);
wire mode_fp32 = (i_Compute_Precision == `FP32);

// --------------------
// 把“补好隐藏位的尾数”打包给你的复用核
// 约定：
//   FP16 lane0 用 [10:0]，lane1 用 [26:16]
//   BF16 lane0 用 [7:0]， lane1 用 [23:16]
//   FP32 用 [23:0]
// （如果你核内部取位跟这个不一样，就改下面这几行打包位段即可）
// --------------------
wire [31:0] core_A =
    mode_fp32 ? {8'd0, Frac32A} :
    mode_fp16 ? { 5'd0, FracFP16A[1], 5'd0, FracFP16A[0] } :
    mode_bf16 ? { 8'd0, FracBF16A[1], 8'd0, FracBF16A[0] } :
                32'd0;

wire [31:0] core_B =
    mode_fp32 ? {8'd0, Frac32B} :
    mode_fp16 ? { 5'd0, FracFP16B[1], 5'd0, FracFP16B[0] } :
    mode_bf16 ? { 8'd0, FracBF16B[1], 8'd0, FracBF16B[0] } :
                32'd0;

// C1_Booth_ALL u_mul_core (
//         .mode      ( i_Compute_Precision     ),
//         .i_SignedA ( 1'b0 ),
//         .i_SignedB ( 1'b0 ),
//         .i_A       ( core_A      ),
//         .i_B       ( core_B      ),
//         .o_P       ( T_Mant      )
//     );

C1_Mult_ALL u_C1_Mult_ALL (
    .i_operand1             (   core_A        ),               
    .i_operand2             (   core_B        ),    
    .i_ZmIsSigned           (  1'b0         ),    
    .i_ZnIsSigned           (  1'b0         ),    
    .i_Active_Element_A     ( 4'b1111          ),    
    .i_Active_Element_B     ( 4'b1111          ),    
    .FMOP_FP16_Non_Widening ( 1'b1          ),
    .i_Mode                 ( i_Compute_Precision          ),                
    .o_AddZA                (           ),    
    .o_Product              (           ),    
    .o_Mant                 ( o_Mant          )
);


// C1_FPMultiplier u_FPMultiplier00(
//     .i_Multiplier    ( Frac32A          ),
//     .i_Multiplicand  ( Frac32B          ),
//     .o_Product       ( FP32Muti_Result  )
// );

endmodule