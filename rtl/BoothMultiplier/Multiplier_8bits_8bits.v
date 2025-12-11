`timescale 1ns / 1ps

module Multiplier_8bits_8bits(A_NUM,B_NUM,C_NUM);

input wire  [7:0]   A_NUM ;
input wire  [7:0]   B_NUM ;
output wire [15:0]  C_NUM ;

wire [9:0]     PP1     ;
wire [9:0]     PP2     ;
wire [9:0]     PP3     ;
wire [9:0]     PP4     ;

wire [15:0]     PPcompressed1   ;
wire [13:0]     PPcompressed2   ;


Gen_PP_Booth u_Gen_PP_Booth(
    .A_NUM      (A_NUM  ),
    .B_NUM      (B_NUM  ),
    .PP1        (PP1    ),
    .PP2        (PP2    ),
    .PP3        (PP3    ),
    .PP4        (PP4    )
);

Compressor_PP u_Compressor_PP(
    .PP1        (PP1    ),
    .PP2        (PP2    ),
    .PP3        (PP3    ),
    .PP4        (PP4    ),
    .PPout1     (PPcompressed1),
    .PPout2     (PPcompressed2) 
);

Adder u_Adder(
    .A      (PPcompressed1  ),
    .B      (PPcompressed2  ),
    .C      (C_NUM          )
);

endmodule
