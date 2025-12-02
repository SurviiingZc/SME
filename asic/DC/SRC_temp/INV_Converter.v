`timescale 1ns / 1ps

module INV_Converter_8 (i_Data,o_inv_Data);

input  wire [7:0]   i_Data     ;
output wire [8:0]   o_inv_Data ;

wire [5:0]            wire_cout ;
wire                  not_o     ;

INV_Unit_Origin u_INV_Unit_Origin(
    .a     ( i_Data[1]     ),
    .b     ( i_Data[0]     ),
    .o_xor ( o_inv_Data[1] ),
    .o_or  ( wire_cout[0]  )
);

genvar i;
generate 
    for(i = 2 ; i <= 5 ; i = i + 1) begin
        INV_Unit_Origin u_INV_Unit_Origin_(
            .a     ( i_Data[i]          ),
            .b     ( wire_cout[i-2]     ),
            .o_xor ( o_inv_Data[i]      ),
            .o_or  ( wire_cout[i-1]     )
        );
    end
endgenerate

INV_Unit_Extend u_INV_Unit_Extend_Second_highest(
    .a     ( i_Data[6]          ),
    .b     ( wire_cout[4]       ),
    .o_xor ( o_inv_Data[6]      ),
    .o_nor ( wire_cout[5]       )
);

INV_Unit_Extend u_INV_Unit_Extend_Highest(
    .a     ( i_Data[7]     ),
    .b     ( not_o         ),
    .o_xor ( o_inv_Data[7] ),
    .o_nor (               )
);//改

assign not_o                = ~wire_cout[5]   ;
assign o_inv_Data[0]        = i_Data[0];
assign o_inv_Data[8]        = ~(wire_cout[5] | i_Data[7]);

endmodule