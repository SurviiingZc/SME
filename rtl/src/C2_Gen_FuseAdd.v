`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 

    
*/

module C2_Gen_FuseAdd (
    input  [  2:0]    i_Compute_Precision  ,
    input  [ 19:0]    i_Exception_Handling ,
    output            o_FuseAdd_SelfAdd
);

wire FPCR_EBF;

assign FPCR_EBF             = (i_Exception_Handling[8] == 1'd1) ? 1'd1 : 1'd0           ;
assign o_FuseAdd_SelfAdd    = (i_Compute_Precision == `BF16) ? 1'd1 : 1'd0 ;

endmodule