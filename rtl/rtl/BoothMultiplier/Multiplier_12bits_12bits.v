`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/14 20:29:52
// Design Name: 
// Module Name: Multiplier_12bits_12bits
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


module Multiplier_12bits_12bits(i_Numerical_Precision,A_NUM,B_NUM,C_NUM);

input wire  [1:0]    i_Numerical_Precision  ;
input wire  [11:0]   A_NUM ;
input wire  [11:0]   B_NUM ;
output wire [23:0]   C_NUM ;

wire [7:0]  A_High_8bit_NUM       ;
wire [7:0]  B_High_8bit_NUM       ;

wire signed [4:0]  A_Low_4bit_NUM       ;
wire signed [4:0]  B_Low_4bit_NUM       ;

wire        [23:0] PP1;
wire        [16:0] PP2;
wire        [16:0] PP3;
wire        [9:0]  PP4;

wire               PP4_PP1;
wire        [3:0]  PP4_PP2;
wire        [3:0]  PP4_PP3;
wire        [7:0]  PP4_PP4;
wire        [4:0]  PP4_Temp;
wire        [7:0]  PP4_SUM;

wire  [11:0]   A_NUM_Temp ;
wire  [11:0]   B_NUM_Temp ;
wire  [23:0]   C_NUM_Temp ;

assign A_NUM_Temp = (i_Numerical_Precision == 2'b00) ? {11'd0,A_NUM[3:0],1'b0} : 
                        (i_Numerical_Precision == 2'b01) ? {A_NUM[7:0],4'd0} : A_NUM;

assign B_NUM_Temp = (i_Numerical_Precision == 2'b00) ? {11'd0,B_NUM[3:0],1'b0} : 
                        (i_Numerical_Precision == 2'b01) ? {B_NUM[7:0],4'd0} : B_NUM;

assign A_High_8bit_NUM = A_NUM_Temp[11:4];
assign B_High_8bit_NUM = B_NUM_Temp[11:4];

assign A_Low_4bit_NUM = (i_Numerical_Precision == 2'b00) ? A_NUM_Temp[4:0] : {1'd0,A_NUM_Temp[3:0]};
assign B_Low_4bit_NUM = (i_Numerical_Precision == 2'b00) ? B_NUM_Temp[4:0] : {1'd0,B_NUM_Temp[3:0]};

Multiplier_8bits_8bits u_Multiplier_8bits_8bits_PP1(
    .A_NUM ( A_High_8bit_NUM ),
    .B_NUM ( B_High_8bit_NUM ),
    .C_NUM ( PP1[23:8] )
);

assign PP1[7:0] = 8'd0;

Multiplier_5bits_8bits u_Multiplier_5bits_8bits_PP2(
    .A_NUM ( B_Low_4bit_NUM  ),
    .B_NUM ( A_High_8bit_NUM ),
    .C_NUM ( PP2[16:4] )
);

assign PP2[3:0] = 4'd0;

Multiplier_5bits_8bits u_Multiplier_5bits_8bits_PP3(
    .A_NUM ( A_Low_4bit_NUM  ),
    .B_NUM ( B_High_8bit_NUM ),
    .C_NUM ( PP3[16:4] )
);

assign PP3[3:0] = 4'd0;

// Multiplier_4bits_4bits u_Multiplier_4bits_4bits_PP4(
//     .A_NUM ( {1'b0,A_Low_4bit_NUM[2:0]} ),
//     .B_NUM ( {1'b0,B_Low_4bit_NUM[2:0]} ),
//     .C_NUM (  PP4_PP4                   )
// );

// assign PP4_PP1 = A_Low_4bit_NUM[3] & B_Low_4bit_NUM[3];
// assign PP4_PP2 = {{3{A_Low_4bit_NUM[3]}} & {B_Low_4bit_NUM[2:0],1'b0}};
// assign PP4_PP3 = {{3{B_Low_4bit_NUM[3]}} & {A_Low_4bit_NUM[2:0],1'b0}};

// assign PP4_Temp = (PP4_PP2 + PP4_PP3);

// assign PP4_SUM = {1'd0,PP4_PP1,6'd0} + {3'd0,PP4_Temp} + PP4_PP4;

// assign PP4_SUM = A_Low_4bit_NUM * B_Low_4bit_NUM;

assign PP4     = A_Low_4bit_NUM * B_Low_4bit_NUM;

assign C_NUM_Temp = PP1 + {{7{PP2[16]}},PP2} + {{7{PP3[16]}},PP3} + {{14{PP4[9]}},PP4}; 

assign C_NUM = (i_Numerical_Precision == 2'b00) ? {16'd0,{PP4[9:2]}} : 
                    (i_Numerical_Precision == 2'b01) ? {8'd0,PP1[23:8]} : C_NUM_Temp;

endmodule
