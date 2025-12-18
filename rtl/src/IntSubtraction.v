`timescale 1ns/1ps

module IntSubtraction(
    input   signed [31:0]         product,     // signed
    input   signed [31:0]         i_Addend,    // signed
    output  signed [31:0]    o_Sub     
);

wire signed [32:0] sub_temp = product - i_Addend;
assign o_Sub = sub_temp[31:0];
// always @(*) begin
//     if ($signed(sub_temp) > $signed(32'h7FFF_FFFF)) begin
//         o_Sub = 32'h7FFF_FFFF;  
//     end 
//     else if ($signed(sub_temp) < $signed(32'h8000_0000)) begin
//         o_Sub = 32'h8000_0000;  
//     end 
//     else begin
//         o_Sub = sub_temp[31:0];
//     end    
// end

endmodule