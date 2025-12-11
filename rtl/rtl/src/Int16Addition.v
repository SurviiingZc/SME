`timescale 1ns/1ps

module Int16Addition (
    input signed    [32:0]          i_Product,  
    input signed    [31:0]          i_Addend,      
    output  signed [31:0]        o_Sum     
);

wire signed [33:0] sum_temp = $signed(i_Product) + $signed(i_Addend);
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