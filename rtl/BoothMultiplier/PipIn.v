`timescale 1ns / 1ps

module PipIn(clk,rst_n,i_Numerical_Precision,i_A_NUM,i_B_NUM,o_Numerical_Precision,o_A_NUM,o_B_NUM);

input wire           clk                    ;
input wire           rst_n                  ;
input wire  [1:0]    i_Numerical_Precision  ;
input wire  [23:0]   i_A_NUM                ;
input wire  [23:0]   i_B_NUM                ;
output reg  [1:0]    o_Numerical_Precision  ;
output reg  [23:0]   o_A_NUM                ;
output reg  [23:0]   o_B_NUM                ;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        o_Numerical_Precision <= 2'd0                    ;
        o_A_NUM               <= 24'd0                   ;
        o_B_NUM               <= 24'd0                   ;
    end
    else begin
        o_Numerical_Precision <= i_Numerical_Precision   ;
        o_A_NUM               <= i_A_NUM                 ;
        o_B_NUM               <= i_B_NUM                 ;
    end
end

endmodule