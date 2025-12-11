`timescale 1ns / 1ps

module Adder(A,B,C);

input wire  [15:0]  A       ;
input wire  [13:0]  B       ;
output wire [15:0]  C       ;

wire [12:0] cout_adder_16bit;
wire        xor_o1          ;

assign C[1:0] = A[1:0];

Half_Adder Half_Adder_C2(
    .a      (A[2])                  ,
    .b      (B[0])                  ,
    .o_cout (cout_adder_16bit[0])   ,
    .o_sum  (C[2])
);

Compressor_3_2 fCompressor_3_2_C3(
    .i0 (A[3]),
    .i1 (B[1]),
    .ci (cout_adder_16bit[0]),
    .co (cout_adder_16bit[1]),
    .d  (C[3])
);

Half_Adder Half_Adder_C4(
    .a      (A[4])                  ,
    .b      (cout_adder_16bit[1])   ,
    .o_cout (cout_adder_16bit[2])   ,
    .o_sum  (C[4])
);  

genvar i;
generate
    for(i=5;i<=14;i=i+1) begin
        Compressor_3_2 Compressor_3_2_C7_5(
                    .i0 (A[i]),
                    .i1 (B[i-2]),
                    .ci (cout_adder_16bit[i-3]),
    
                    .co (cout_adder_16bit[i-2]), 
                    .d  (C[i])
        );          
    end
endgenerate

assign xor_o1 = A[15] ^ B[13]; 
assign C[15] = xor_o1 ^ cout_adder_16bit[12];
    
endmodule