`timescale 1ns / 1ps

/*
    Function    : 
    Description : 

    
*/

module C3_CLA_72 (
    input            i_Cin           ,
    input  [71:0]    i_Addnum1       ,
    input  [71:0]    i_Addnum2       ,
    output           o_Cout          ,
    output [71:0]    o_Sum           
);

wire [17:0] Cin  ;
wire [17:0] Cout ;

genvar i;

generate

    for(i = 1 ; i < 18 ; i = i + 1) begin : ADD_WIRE_72
        assign Cin[i] = Cout[i-1] ;
    end

    for(i = 0 ; i < 18 ; i = i + 1) begin : CLA_Module_72
        C3_CLA_4 u_C3_CLA_4(
            .i_Cin      ( Cin[i]             ),
            .i_Addnum1  ( i_Addnum1[i*4+:4]  ),
            .i_Addnum2  ( i_Addnum2[i*4+:4]  ),
            .o_Cout     ( Cout[i]            ),
            .o_Sum      ( o_Sum[i*4+:4]      )
        );
    end

endgenerate

assign Cin[0] = i_Cin       ;
assign o_Cout = Cout[17]    ;

endmodule