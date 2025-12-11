`timescale 1ns / 1ps

module Multiplier_24bits_24bits(i_Numerical_Precision,A_NUM,B_NUM,C_NUM);

input wire  [1:0]    i_Numerical_Precision  ;
input wire  [23:0]   A_NUM                  ;
input wire  [23:0]   B_NUM                  ;
output wire [47:0]   C_NUM                  ;

wire [11:0]  A_High_12bit_NUM       ;
wire [11:0]  B_High_12bit_NUM       ;

wire [11:0]  A_Low_12bit_NUM       ;
wire [11:0]  B_Low_12bit_NUM       ;

wire [12:0]  PPTemp;

wire [23:0] PP1;
wire [23:0] PP2;
wire [23:0] PP3;
wire [23:0] PP4;
// wire [25:0] PP2;
// wire [25:0] PP3;
// wire [25:0] PP4;
wire [23:0] PP5;
wire [23:0] PP6;
wire [23:0] PP7;

wire [47:0] Shift_PP1;
wire [47:0] Shift_PP2;
wire [47:0] Shift_PP3;
wire [47:0] Shift_PP4;
wire [47:0] Shift_PP5;
wire [47:0] Shift_PP6;
wire [47:0] Shift_PP7;
wire [47:0] C_NUM_Temp;

assign A_High_12bit_NUM = (i_Numerical_Precision == 2'b11) ? A_NUM[23:12] : A_NUM[11:0];
assign B_High_12bit_NUM = (i_Numerical_Precision == 2'b11) ? B_NUM[23:12] : B_NUM[11:0];
assign A_Low_12bit_NUM  = A_NUM[11:0];
assign B_Low_12bit_NUM  = B_NUM[11:0];

Multiplier_12bits_12bits u_Multiplier_12bits_12bits_PP1(
    .i_Numerical_Precision  ( i_Numerical_Precision ),
    .A_NUM                  ( A_High_12bit_NUM      ),
    .B_NUM                  ( B_High_12bit_NUM      ),
    .C_NUM                  ( PP1                   )
);

Multiplier_12bits_12bits u_Multiplier_12bits_12bits_PP2(
    .i_Numerical_Precision  ( i_Numerical_Precision ),
    .A_NUM                  ( A_Low_12bit_NUM       ),
    .B_NUM                  ( B_High_12bit_NUM      ),
    .C_NUM                  ( PP2                   )
);

Multiplier_12bits_12bits u_Multiplier_12bits_12bits_PP3(
    .i_Numerical_Precision  ( i_Numerical_Precision ),
    .A_NUM                  ( A_High_12bit_NUM      ),
    .B_NUM                  ( B_Low_12bit_NUM       ),
    .C_NUM                  ( PP3                   )
);

Multiplier_12bits_12bits u_Multiplier_12bits_12bits_PP4(
    .i_Numerical_Precision  ( i_Numerical_Precision ),
    .A_NUM                  ( A_Low_12bit_NUM       ),
    .B_NUM                  ( B_Low_12bit_NUM       ),
    .C_NUM                  ( PP4                   )
);

// Multiplier_13bits_13bits u_Multiplier_13bits_13bits_PP2(
//     .A_NUM ( {1'b0,B_Low_12bit_NUM}         ),
//     .B_NUM ( {A_High_12bit_NUM,1'b0}        ),
//     .C_NUM ( PP2                            )
// );

// Multiplier_13bits_13bits u_Multiplier_13bits_13bits_PP3(
//     .A_NUM ( {1'b0,A_Low_12bit_NUM}         ),
//     .B_NUM ( {B_High_12bit_NUM,1'b0}        ),
//     .C_NUM ( PP3                            )
// );

// Multiplier_13bits_13bits u_Multiplier_13bits_13bits__PP4(
//     .A_NUM ( {1'b0,A_Low_12bit_NUM} ),
//     .B_NUM ( {1'b0,B_Low_12bit_NUM} ),
//     .C_NUM ( PP4                          )
// );

// assign Shift_PP1 = {PP1,24'd0};
// assign Shift_PP2 = {{11{PP2[25]}},PP2,11'd0};
// assign Shift_PP3 = {{11{PP3[25]}},PP3,11'd0};
// assign Shift_PP4 = {{22{PP4[25]}},PP4};

// assign Shift_PP1 = {PP1,24'd0};
// assign Shift_PP2 = {12'd0,PP2,12'd0};
// assign Shift_PP3 = {12'd0,PP3,12'd0};
// assign Shift_PP4 = {24'd0,PP4};

// assign C_NUM_Temp = Shift_PP1 + Shift_PP2 + Shift_PP3 + Shift_PP4;
assign PPTemp     = PP2 + PP3 ;

assign C_NUM_Temp = (PP1 << 24) + (PPTemp << 12) + PP4;

assign C_NUM = (i_Numerical_Precision == 2'b11) ? C_NUM_Temp : {24'd0,PP1};

endmodule
