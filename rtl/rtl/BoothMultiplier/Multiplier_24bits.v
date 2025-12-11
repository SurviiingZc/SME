`timescale 1ns / 1ps

module Multiplier_24bits(clk,rst_n,i_Numerical_Precision,i_A_NUM,i_B_NUM,o_C_NUM);

input wire           clk                    ;
input wire           rst_n                  ;
input wire  [1:0]    i_Numerical_Precision  ;
input wire  [23:0]   i_A_NUM                ;
input wire  [23:0]   i_B_NUM                ;
output wire [47:0]   o_C_NUM                ;

wire  [1:0]    T_Numerical_Precision    ;
wire  [23:0]   T_A_NUM                  ;
wire  [23:0]   T_B_NUM                  ;
wire  [47:0]   T_C_NUM                  ;

PipIn u_PipIn(
    .clk                   ( clk                   ),
    .rst_n                 ( rst_n                 ),
    .i_Numerical_Precision ( i_Numerical_Precision ),
    .i_A_NUM               ( i_A_NUM               ),
    .i_B_NUM               ( i_B_NUM               ),
    .o_Numerical_Precision ( T_Numerical_Precision ),
    .o_A_NUM               ( T_A_NUM               ),
    .o_B_NUM               ( T_B_NUM               )
);

Multiplier_24bits_24bits u_Multiplier_24bits_24bits(
    .i_Numerical_Precision ( T_Numerical_Precision ),
    .A_NUM                 ( T_A_NUM               ),
    .B_NUM                 ( T_B_NUM               ),
    .C_NUM                 ( T_C_NUM               )
);

PipOut u_PipOut(
    .clk     ( clk     ),
    .rst_n   ( rst_n   ),
    .i_C_NUM ( T_C_NUM ),
    .o_C_NUM ( o_C_NUM )
);



endmodule