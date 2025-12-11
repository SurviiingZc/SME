`timescale 1ns / 1ps

module Gen_PP_Booth(A_NUM,B_NUM,PP1,PP2,PP3,PP4);

input  wire [7:0]   A_NUM   ;
input  wire [7:0]   B_NUM   ;
output wire [9:0]   PP1     ;
output wire [9:0]   PP2     ;
output wire [9:0]   PP3     ;
output wire [9:0]   PP4     ;

wire [1:0]  B_code1 ;
wire [2:0]  B_code2 ;
wire [2:0]  B_code3 ;
wire [2:0]  B_code4 ;

wire [8:0] inversed_A  ;

INV_Converter_8 u_INV_Converter_8(
    .i_Data         (A_NUM      ),
    .o_inv_Data     (inversed_A ) 
);
    
assign B_code1 = B_NUM[1:0]         ;
assign B_code2 = B_NUM[3:1]         ;
assign B_code3 = B_NUM[5:3]         ;
assign B_code4 = B_NUM[7:5]         ;

Booth_Decoder_Lowest u_Booth_Decoder_Lowest_PP1(
    .Booth_Code   (B_code1    ),  
    .A            (A_NUM      ),
    .Inversed_A   (inversed_A ),
    .PP_Out       (PP1        ) 
);

Booth_Decoder_Other Booth_Decoder_Other_PP2(
    .Booth_Code (B_code2            ),
    .A          (A_NUM              ),
    .Inversed_A (inversed_A         ),
    .PP_Out     (PP2                ) 
);

Booth_Decoder_Other Booth_Decoder_Other_PP3(
    .Booth_Code (B_code3            ),
    .A          (A_NUM              ),
    .Inversed_A (inversed_A         ),
    .PP_Out     (PP3                ) 
);

Booth_Decoder_Other Booth_Decoder_Other_PP4(
    .Booth_Code (B_code4            ),
    .A          (A_NUM              ),
    .Inversed_A (inversed_A         ),
    .PP_Out     (PP4                )
);

endmodule
