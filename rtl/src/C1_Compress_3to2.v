module Compress_3to2 #(parameter WIDTH = 24) (
    input  [WIDTH-1:0] in_a         ,
    input  [WIDTH-1:0] in_b         ,
    input  [WIDTH-1:0] in_c         ,
    output [WIDTH-1:0] out_sum      ,
    output [WIDTH-1:0] out_carry
);
    assign out_sum   = in_a ^ in_b ^ in_c;
    assign out_carry = (in_a & in_b) | (in_a & in_c) | (in_b & in_c);

endmodule