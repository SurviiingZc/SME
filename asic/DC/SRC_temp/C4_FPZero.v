`timescale 1ns/1ps

/*
    Function    : 
    Description : 

    
*/

module C4_FPZero (
    input           i_Sign          ,
    input           i_Data_Width    , // 0 -> 16   1 -> 32
    output [31:0]   o_FPZero
);

assign o_FPZero = (i_Data_Width == 1'd0) ? {16'd0,i_Sign,{5{1'd0}},{10{1'd0}}} : {i_Sign,{8{1'd0}},{23{1'd0}}} ; 

endmodule