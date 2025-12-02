`timescale 1ns/1ps

// `ifndef VCS_FSDB
// `include "Macro_Definition.v"
// `endif

module IntMult #(
    parameter IN_WIDTH = 8
)(
    input [4*IN_WIDTH-1:0]  operand1,     
    input [4*IN_WIDTH-1:0]  operand2,     
    input                   i_ZmIsSigned,  // 0 -> unsigned 1 -> signed
    input                   i_ZnIsSigned,  // 0 -> unsigned 1 -> signed
    output [63:0]           o_Product     
);

wire [IN_WIDTH-1:0] op1_parts [3:0];
wire [IN_WIDTH-1:0] op2_parts [3:0];

assign op1_parts[3] = operand1[31:24];  
assign op1_parts[2] = operand1[23:16];
assign op1_parts[1] = operand1[15:8];
assign op1_parts[0] = operand1[7:0];    

assign op2_parts[3] = operand2[31:24];
assign op2_parts[2] = operand2[23:16];
assign op2_parts[1] = operand2[15:8];
assign op2_parts[0] = operand2[7:0];

wire [2*IN_WIDTH-1:0] products [3:0];

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : MULT_GEN
        IntMultiplier #(
            .IN_WIDTH(IN_WIDTH)
        ) u_IntMultiplier (
            .i_OperandA(op1_parts[i]),
            .i_OperandB(op2_parts[i]),
            .i_SignedA (i_ZmIsSigned), 
            .i_SignedB (i_ZnIsSigned),
            .o_Product (products[i])
        );
    end
endgenerate

assign o_Product = {products[3], products[2], products[1], products[0]};

endmodule
