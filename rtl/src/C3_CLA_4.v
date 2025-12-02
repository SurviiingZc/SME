`timescale 1ns / 1ps

/*
    Function    : 
    Description : 

    
*/

module C3_CLA_4 (
    input           i_Cin           ,
    input  [3:0]    i_Addnum1       ,
    input  [3:0]    i_Addnum2       ,
    output          o_Cout          ,
    output [3:0]    o_Sum           
);

wire p0,p1,p2,p3,g0,g1,g2,g3;
wire c1,c2,c3,c4;

assign p0 = i_Addnum1[0] ^ i_Addnum2[0] ;
assign p1 = i_Addnum1[1] ^ i_Addnum2[1] ;
assign p2 = i_Addnum1[2] ^ i_Addnum2[2] ;
assign p3 = i_Addnum1[3] ^ i_Addnum2[3] ;

assign g0 = i_Addnum1[0] & i_Addnum2[0] ;
assign g1 = i_Addnum1[1] & i_Addnum2[1] ;
assign g2 = i_Addnum1[2] & i_Addnum2[2] ;
assign g3 = i_Addnum1[3] & i_Addnum2[3] ;

assign c1 = g0 | (p0 & i_Cin) ;
assign c2 = g1 | (p1 & g0) | (p1 & p0 & i_Cin) ;
assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & i_Cin) ;
assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & i_Cin) ;

assign o_Sum[0] = p0 ^ i_Cin ;
assign o_Sum[1] = p1 ^ c1    ;
assign o_Sum[2] = p2 ^ c2    ;
assign o_Sum[3] = p3 ^ c3    ;
assign o_Cout   = c4         ;

endmodule