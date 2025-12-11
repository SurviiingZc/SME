`timescale 1ns/1ps

/*
    Function    : 
    Description : 

    
*/

module C6_FPNaN (
    input           i_Sign          ,
    input           i_Data_Width    , // 0 -> 16   1 -> 32
    output [31:0]   o_FPNaN
);

assign o_FPNaN = (i_Data_Width == 1'd0) ? {16'd0,i_Sign,{15{1'd1}}} : {i_Sign,{31{1'd1}}} ; 

endmodule