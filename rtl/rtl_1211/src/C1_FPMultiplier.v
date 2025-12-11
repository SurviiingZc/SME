`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 

    
*/

module C1_FPMultiplier (
    input  [23:0]   i_Multiplier      ,
    input  [23:0]   i_Multiplicand    ,
    output [47:0]   o_Product
);

assign o_Product = i_Multiplier * i_Multiplicand ;

endmodule
