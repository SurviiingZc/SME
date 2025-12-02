`timescale 1ns/1ps

module IntAddition(
    input  signed [31:0]         product,     // signed
    input  signed [31:0]         i_Addend,    // signed
    output signed [31:0]    o_Sum     
);

wire signed [32:0] sum_temp = product + i_Addend;
assign o_Sum = sum_temp[31:0];
// always @(*) begin
//     if ($signed(sum_temp) > $signed(32'h7FFF_FFFF)) begin
//         o_Sum = 32'h7FFF_FFFF;  
//     end 
//     else if ($signed(sum_temp) < $signed(32'h8000_0000)) begin
//         o_Sum = 32'h8000_0000;  
//     end 
//     else begin
//         o_Sum = sum_temp[31:0];
//     end    
// end

endmodule