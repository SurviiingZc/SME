`timescale 1ns / 1ps

module INV_Unit_Origin(a,b,o_xor,o_or);

input  wire a       ;
input  wire b       ;
output wire o_xor   ;
output wire o_or    ;

assign o_xor    = a ^ b;
assign o_or     = a | b;

endmodule