`timescale 1ns / 1ps

module PipOut(clk,rst_n,i_C_NUM,o_C_NUM);

input  wire          clk                      ;
input  wire          rst_n                    ;
input  wire [47:0]   i_C_NUM                  ;
output reg  [47:0]   o_C_NUM                  ;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        o_C_NUM <= 2'd0      ;
    end
    else begin
        o_C_NUM <= i_C_NUM   ;
    end
end

endmodule