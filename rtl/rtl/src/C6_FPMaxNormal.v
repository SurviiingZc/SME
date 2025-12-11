`timescale 1ns/1ps

/*
    Function    : 
    Description : 

    
*/

module C6_FPMaxNormal (
    input           i_Sign          ,
    input           i_Data_Width    , // 0 -> 16   1 -> 32
    output [31:0]   o_FPMaxNormal
);

assign o_FPMaxNormal = (i_Data_Width == 1'd0) ? {16'd0,i_Sign,{4{1'd1}},{1'b0},{10{1'd1}}} : {i_Sign,{7{1'd1}},{1'b0},{23{1'd1}}} ; 

endmodule