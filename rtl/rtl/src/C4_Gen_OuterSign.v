`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 

    
*/

module C4_Gen_OuterSign (
    input  [  2:0]    i_Compute_Precision  ,
    input             i_Is_Widening        ,
    output            o_OuterSign
);

assign o_OuterSign    = !i_Is_Widening && (i_Compute_Precision == `FP16) ? 1'd1 : 1'd0 ;

endmodule


