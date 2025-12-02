
`timescale 1ns/1ps

/*
    Function    : Output normalized floating-point result with exponent adjustment
    Description : Supports FP16, FP32, and BF16 formats; adds normalization shift to biased exponent
*/

module C4_Normal_Result #(
    parameter IN_WIDTH = 48,
    parameter EXP_WIDTH = 8
)(
    input                       i_Sign,                  // Sign bit
    input  [EXP_WIDTH:0]        biased_exp_round,         // 
    input  [24:0]               int_mant_round,          // Rounded mantissa
    input  [1:0]                i_Data_Width,            // 0 = FP16, 1 = FP32, 2 = BF16
    output reg [31:0]           o_Normal_Result          // 
);
    // 根据溢出选择输出位宽
    always @(*) begin
        case (i_Data_Width)
            //  2'd0: o_Normal_Result = (int_mant_round[10] ) ? {  16'd0, i_Sign, biased_exp_round[4:0], int_mant_round[10:1] } : {  16'd0, i_Sign, biased_exp_round[4:0], int_mant_round[9:0] } ;
            //  2'd1: o_Normal_Result = (int_mant_round[23] ) ? {       i_Sign, biased_exp_round[7:0], int_mant_round[23:1]}    : {       i_Sign, biased_exp_round[7:0], int_mant_round[22:0]} ;
            //  2'd2: o_Normal_Result = (int_mant_round[7]  ) ? {   i_Sign, biased_exp_round[7:0], int_mant_round[7:1],16'd0}   : {     i_Sign, biased_exp_round[7:0], int_mant_round[6:0] ,16'd0} ;
            2'd0: o_Normal_Result = {  16'd0, i_Sign, biased_exp_round[4:0], int_mant_round[9:0] } ;
            2'd1: o_Normal_Result = {       i_Sign, biased_exp_round[7:0], int_mant_round[22:0]} ;
            2'd2: o_Normal_Result = {     i_Sign, biased_exp_round[7:0], int_mant_round[6:0] ,16'd0} ;
            default: o_Normal_Result = 32'd0;
        endcase
    end

endmodule