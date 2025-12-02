`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module IntMultiplier #(
    parameter IN_WIDTH = 8
)(
    input  [IN_WIDTH-1:0]     i_OperandA,   
    input  [IN_WIDTH-1:0]     i_OperandB,   
    input                     i_SignedA,    // 0 -> unsigned 1 -> signed
    input                     i_SignedB,    // 0 -> unsigned 1 -> signed
    output [2*IN_WIDTH-1:0]  o_Product      
);
generate
    if (IN_WIDTH == 8) begin
        BoothIntMul8 u_booth8 (
            .a (i_OperandA),
            .b (i_OperandB),
            .signedA (i_SignedA),
            .signedB (i_SignedB),
            .p (o_Product)
        );
    end else if (IN_WIDTH == 16) begin
        BoothIntMul16 u_booth16 (
            .a (i_OperandA),
            .b (i_OperandB),
            .signedA (i_SignedA),
            .signedB (i_SignedB),
            .p (o_Product)
        );
    end else begin
        wire signed [IN_WIDTH:0] extended_operandA = 
            (i_SignedA == `Zm_Is_Unsigned) ? {1'b0, i_OperandA} : {i_OperandA[IN_WIDTH-1], i_OperandA} ;
        wire signed [IN_WIDTH:0] extended_operandB = 
            (i_SignedB == `Zm_Is_Unsigned) ? {1'b0, i_OperandB} : {i_OperandB[IN_WIDTH-1], i_OperandB} ;
        wire signed [2*IN_WIDTH+1:0] full_product = extended_operandA * extended_operandB;
        assign o_Product = full_product[2*IN_WIDTH-1:0];
    end
endgenerate


endmodule