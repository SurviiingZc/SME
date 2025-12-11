`timescale 1ns / 1ps

module Booth_Decoder_Other(Booth_Code,A,Inversed_A,PP_Out);

input wire  [2:0]      Booth_Code  ;  
input wire  [7:0]      A           ;  
input wire  [8:0]      Inversed_A  ;  
output wire [9:0]      PP_Out      ;  
    
wire [8:0]  pp_source                   ;

wire    not_c2                  ;
wire    c1_and_c0               ;
wire    c1_nor_c0               ;
wire    nor_o2                  ;
wire    flag_2x                 ;
wire    flag_s1                 ;
wire    flag_s2                 ;


assign not_c2       = ~Booth_Code[2]                  ;
assign c1_and_c0    = Booth_Code[1] & Booth_Code[0]         ;
assign c1_nor_c0    = ~(Booth_Code[1] | Booth_Code[0])      ;
assign nor_o2       = ~(c1_and_c0 | c1_nor_c0)  ;

assign flag_2x      = ~nor_o2                   ;
assign flag_s1      = ~(not_c2 | c1_and_c0)     ;
assign flag_s2      = ~(Booth_Code[2] | c1_nor_c0)    ;

wire    flag_not_2x = nor_o2    ; 

assign pp_source = ~(({{A[7]}, A}  & {9{flag_s2}}) | (Inversed_A & {9{flag_s1}}));

assign PP_Out[0] = ~(flag_2x | pp_source[0]);

assign PP_Out[8:1] = ~(({8{flag_2x}} & pp_source[7:0]) | ({8{flag_not_2x}} & pp_source[8:1]));

assign PP_Out[9] = pp_source[8];

endmodule