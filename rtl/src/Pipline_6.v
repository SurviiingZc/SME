`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module Pipline_6 (
        clk                    ,
        rst_n                  ,

        i_Round_Result         ,
        o_Result     
);

`ifdef Is_PipLine

input                 clk                     ;
input                 rst_n                   ;

input       [127:0]   i_Round_Result          ;
output reg  [127:0]   o_Result                ;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        o_Result               <= 'd0               ;
    end 
    else begin
        o_Result               <= i_Round_Result    ;
    end
end

`else

input                 clk                           ;
input                 rst_n                         ;
input       [127:0]   i_Round_Result                ;
output      [127:0]   o_Result                      ;

assign o_Result               = i_Round_Result      ;

`endif
    
endmodule