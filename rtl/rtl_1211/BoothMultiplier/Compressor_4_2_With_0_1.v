`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 20:40:23
// Design Name: 
// Module Name: Compressor_4_2_With_0_1
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


module Compressor_4_2_With_0_1(i1,i3,ci,co,c,d);

input wire i1   ;
input wire i3   ;
input wire ci   ;
output wire co  ;
output wire c   ;
output wire d   ;

wire    inv_i1 ; 
assign  inv_i1 = ~i1;

assign  co = i1; 

Compressor_3_2 u_Compressor_3_2(
    .i0     (inv_i1),
    .i1     (i3),
    .ci     (ci),

    .co     (c),
    .d      (d)
); 


endmodule
