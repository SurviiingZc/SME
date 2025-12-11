`timescale 1ns / 1ps

module Compressor_4_2_Without_Cin(i0,i1,i2,i3,ci,co,c,d);

input wire i0   ;
input wire i1   ;
input wire i2   ;
input wire i3   ;
input wire ci   ;
output wire co  ;
output wire c   ;
output wire d   ;

wire    wire_d      ;

Compressor_3_2 u_Compressor_3_2(
    .i0     ( i0     ),
    .i1     ( i1     ),
    .ci     ( i2     ),
    .co     ( co     ),
    .d      ( wire_d )
);

Half_Adder u_Half_Adder(
    .a      ( wire_d ),
    .b      ( i3     ),
    .o_cout ( c      ),
    .o_sum  ( d      )
);
 
endmodule