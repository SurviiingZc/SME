`timescale 1ns / 1ps

module Compressor_PP(PP1,PP2,PP3,PP4,PPout1,PPout2);

input wire [9:0] PP1      ;
input wire [9:0] PP2      ;
input wire [9:0] PP3      ;
input wire [9:0] PP4      ;
output wire [15:0] PPout1 ;
output wire [13:0] PPout2 ;


wire [11:0] PP1_code;
wire [10:0] PP2_code;
wire [10:0] PP3_code; 
wire [9:0]  PP4_code;   
wire [15:0] PPC1_1; 
wire [13:0] PPC1_2;    
wire [6:0] cout_class1_ppc12; 
wire    PP1_s  ;   
assign  PP1_s = ~PP1[9];  //NOT
assign PP1_code = {PP1[9],{2{PP1_s}},PP1[8:0]};
assign PP2_code = {1'b1,PP2};
assign PP3_code = {1'b1,PP3};
assign PP4_code = PP4;   

genvar i;
generate 
    for(i = 4 ; i <= 5 ; i = i + 1) begin : compressor_3_2_inst
        Compressor_3_2 u_Compressor_3_2 (
            .i0 (PP1_code[i]),
            .i1 (PP2_code[i-2]),
            .ci (PP3_code[i-4]),
            .co (PPC1_2[i-1]),
            .d  (PPC1_1[i])
        );       
    end
endgenerate


Compressor_4_2_Without_Cin u_Compressor_4_2_Without_Cin(
    .i0  (PP1_code[6]),
    .i1  (PP2_code[4]),
    .i2  (PP3_code[2]),
    .i3  (PP4_code[0]),
    .co  (cout_class1_ppc12[0]),
    .c   (PPC1_2[5]),
    .d   (PPC1_1[6])
);


generate 
    for(i = 7 ; i <= 11 ; i = i + 1) begin: Compressor_4_2_inst
        Compressor_4_2 u_Compressor_4_2 (
                .i0 (PP1_code[i]),
                .i1 (PP2_code[i-2]),
                .i2 (PP3_code[i-4]),
                .i3 (PP4_code[i-6]),
                .ci (cout_class1_ppc12[i-7]),  
        
                .co (cout_class1_ppc12[i-6]),
                .c  (PPC1_2[i-1]),
                .d  (PPC1_1[i])
            );              
    end
endgenerate  

Compressor_4_2_With_0_1 u_Compressor_4_2_With_0_1(
        .i1   (PP3_code[8]   ),
        .i3   (PP4_code[6]   ),
        .ci   (cout_class1_ppc12[5]),

        .co  (cout_class1_ppc12[6]),
        .c   (PPC1_2[11]),
        .d   (PPC1_1[12])
);    

Compressor_3_2 u_Compressor_3_2_(
    .i0      (PP3_code[9]),
    .i1      (PP4_code[7]),
    .ci      (cout_class1_ppc12[6]),

    .co      (PPC1_2[12]),
    .d       (PPC1_1[13])
);

assign PPC1_1[14] = ~PP4_code[8];  
assign PPC1_2[13] = PP4_code[8];

assign PPC1_1[15]   = PP4_code[9]       ;
assign PPC1_1[3:0]  = PP1_code[3:0]     ; 
assign PPC1_2[1:0]  = PP2_code[1:0]     ;
assign PPC1_2[2]    = 1'b0              ; 

assign PPout1 = PPC1_1;
assign PPout2 = PPC1_2;
   
    
endmodule

