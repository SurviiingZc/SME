`timescale 1ns / 1ps

module Booth_Decoder_Lowest(Booth_Code,A,Inversed_A,PP_Out);

input wire  [1:0]      Booth_Code  ;  
input wire  [7:0]      A           ;  
input wire  [8:0]      Inversed_A  ;  
output wire [9:0]      PP_Out      ;  
    
wire [8:0]  pp_source                   ;
wire        not_code0                   ;
wire        flag_not_2x = Booth_Code[0] ;
wire        flag_2x                     ;
wire        flag_s1                     ;
wire        flag_s2                     ;

assign not_code0 = ~Booth_Code[0];

assign  flag_2x = not_code0;
assign  flag_s1 = Booth_Code[1];
assign  flag_s2 = ~(Booth_Code[1] | not_code0);

assign pp_source = ~(({{A[7]}, A}  & {9{flag_s2}}) | (Inversed_A & {9{flag_s1}}));

assign PP_Out[0] = ~(flag_2x | pp_source[0]);

assign PP_Out[8:1] = ~(({8{flag_2x}} & pp_source[7:0]) | ({8{flag_not_2x}} & pp_source[8:1]));

assign PP_Out[9] = pp_source[8];

endmodule