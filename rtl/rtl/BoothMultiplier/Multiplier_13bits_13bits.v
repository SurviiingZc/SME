`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 17:44:43
// Design Name: 
// Module Name: Multiplier_13bits_13bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Multiplier_13bits_13bits(A_NUM,B_NUM,C_NUM);

input wire  [12:0]   A_NUM ;
input wire  [12:0]   B_NUM ;
output wire [25:0]   C_NUM ;

wire [7:0]  A_High_8bit_NUM       ;
wire [7:0]  B_High_8bit_NUM       ;

wire [4:0]  A_Low_5bit_NUM       ;
wire [4:0]  B_Low_5bit_NUM       ;

wire        [25:0] PP1;
wire        [17:0] PP2;
wire        [17:0] PP3;
wire        [10:0] PP4;

wire        [9:0]  PP4_SUM;

assign A_High_8bit_NUM = A_NUM[12:5];
assign B_High_8bit_NUM = B_NUM[12:5];

assign A_Low_5bit_NUM = A_NUM[4:0];
assign B_Low_5bit_NUM = B_NUM[4:0];

Multiplier_8bits_8bits u_Multiplier_8bits_8bits_PP1(
    .A_NUM ( A_High_8bit_NUM ),
    .B_NUM ( B_High_8bit_NUM ),
    .C_NUM ( PP1[25:10] )
);

assign PP1[9:0] = 10'd0;

Multiplier_5bits_8bits u_Multiplier_5bits_8bits_PP2(
    .A_NUM ( B_Low_5bit_NUM  ),
    .B_NUM ( A_High_8bit_NUM ),
    .C_NUM ( PP2[17:5] )
);

assign PP2[4:0] = 5'd0;

Multiplier_5bits_8bits u_Multiplier_5bits_8bits_PP3(
    .A_NUM ( A_Low_5bit_NUM  ),
    .B_NUM ( B_High_8bit_NUM ),
    .C_NUM ( PP3[17:5] )
);

assign PP3[4:0] = 5'd0;

assign PP4_SUM = A_Low_5bit_NUM * B_Low_5bit_NUM;

assign PP4     = {1'd0,PP4_SUM};

assign C_NUM = PP1 + {{8{PP2[17]}},PP2} + {{8{PP3[17]}},PP3} + {{15{PP4[10]}},PP4}; 

endmodule
