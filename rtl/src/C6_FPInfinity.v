`timescale 1ns/1ps

/*
    Function    : 
    Description : 

    
*/

module C6_FPInfinity (
    input           i_Sign          ,
    input           i_Data_Width    , // 0 -> 16   1 -> 32
    output [31:0]   o_FPInfinity
);

assign o_FPInfinity = (i_Data_Width == 1'd0) ? {16'd0,i_Sign,{5{1'd1}},{10{1'd0}}} : {i_Sign,{8{1'd1}},{23{1'd0}}} ; 

endmodule