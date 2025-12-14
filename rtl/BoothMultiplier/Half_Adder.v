`timescale 1ns / 1ps

module Half_Adder(a,b,o_cout,o_sum);

input  wire a       ;
input  wire b       ;
output wire o_cout  ;
output wire o_sum   ;

assign o_cout = a & b;
assign o_sum  = a ^ b;

endmodule