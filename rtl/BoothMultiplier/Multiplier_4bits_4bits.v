`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/14 20:28:40
// Design Name: 
// Module Name: Multiplier_4bits_4bits
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


module Multiplier_4bits_4bits(A_NUM,B_NUM,C_NUM);

input wire  [3:0]   A_NUM ;
input wire  [3:0]   B_NUM ;
output wire [7:0]   C_NUM ;

// 符号扩展至7位以避免移位溢出
wire signed [6:0] a_ext = {{3{A_NUM[3]}}, A_NUM};

// 生成部分积，手动处理符号和移位
wire [9:0] pp0 = {{3{a_ext[6]}}, a_ext} & {10{B_NUM[0]}}; // b0: a
wire [9:0] pp1 = {{2{a_ext[6]}}, a_ext, 1'b0} & {10{B_NUM[1]}}; // b1: a<<1
wire [9:0] pp2 = {{1{a_ext[6]}}, a_ext, 2'b0} & {10{B_NUM[2]}}; // b2: a<<2
wire [9:0] pp3 = (~{a_ext, 3'b0} + 1) & {10{B_NUM[3]}}; // b3: -a<<3

// 两级超前进位加法结构优化延迟
wire [9:0] sum_01 = pp0 + pp1;
wire [9:0] sum_23 = pp2 + pp3;
wire [9:0] total = sum_01 + sum_23;

// 取低8位作为最终结果
assign C_NUM = total[7:0];

endmodule
