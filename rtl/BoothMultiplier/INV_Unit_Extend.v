`timescale 1ns / 1ps

module INV_Unit_Extend(a,b,o_xor,o_nor);

input  wire a       ;
input  wire b       ;
output wire o_xor   ;
output wire o_nor   ;

assign o_xor    = a ^ b;
assign o_nor    = ~(a | b);

endmodule