`timescale 1ns / 1ps
`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

/*
    Function    : 
    Description : 

// BFUnpack()
// ==========
// Unpacks a BFloat16 or single-precision value into its type,
// sign bit and real number that it represents.
// The real number result has the correct sign for numbers and infinities,
// is very large in magnitude for infinities, and is 0.0 for NaNs.
// (These values are chosen to simplify the description of
// comparisons and conversions.)

*/

module C1_BFUnpack (
    input  [31:0]      BF_Number            ,
    input  [ 5:0]      i_BF_Data_Width      ,
    output [ 2:0]      o_BFType             ,
    output             o_BF_Number_Sign     ,
    output [23:0]      o_BF_Mantissa        ,
    output [ 7:0]      o_BF_Exponent        ,
    output [31:0]      o_BF_Number_Value    
);

wire          is_16bits     ;
wire          Sign          ;
wire [ 7:0]   Exp           ;
wire [22:0]   Frac          ;
wire [31:0]   Value         ;
wire [ 2:0]   Fptype        ;
wire [ 7:0]   Exponent      ;
wire [23:0]   Mantissa      ;
wire          BF16ExpoAll0  ;
wire          BF16ExpoAll1  ;
wire          BF16FracAll0  ;

assign is_16bits            = i_BF_Data_Width == 'd16                               ; 
assign Sign                 = is_16bits ? BF_Number[15] : BF_Number[31]             ;
assign Exp                  = is_16bits ? BF_Number[14:7] : BF_Number[30:23]        ;
assign Frac                 = is_16bits ? {BF_Number[6:0],16'd0} : BF_Number[22:0]  ;
assign BF16ExpoAll0         = |Exp == 1'd0                                          ;
assign BF16ExpoAll1         = &Exp == 1'd1                                          ;
assign BF16FracAll0         = |Frac == 1'd0                                         ;
assign Fptype               = {3{BF16ExpoAll0}} & `FPType_Zero |
                                {3{BF16ExpoAll1 & BF16FracAll0}} & `FPType_Infinity |
                                {3{BF16ExpoAll1 & ~BF16FracAll0}} & `FPType_QNaN |
                                {3{~(BF16ExpoAll0 | BF16ExpoAll1)}} & `FPType_Nonzero;
assign Value                = {32{BF16ExpoAll0}} & {Sign,31'd0} |
                                {32{BF16ExpoAll1 & ~BF16FracAll0}} & {Sign,31'd0} | 
                                {32{~(BF16ExpoAll0 | (BF16ExpoAll1 & ~BF16FracAll0))}} & {Sign,Exp,Frac} ;
assign Exponent             = {8{~(BF16ExpoAll0 | (BF16ExpoAll1 & ~BF16FracAll0))}} & Exp ;
assign Mantissa             = {24{BF16ExpoAll1 & BF16FracAll0}} |
                                {24{~(BF16ExpoAll0 | BF16ExpoAll1)}} & {1'd1,Frac} ;

assign o_BFType             = Fptype    ;
assign o_BF_Number_Sign     = Sign      ;
assign o_BF_Mantissa        = Mantissa  ;
assign o_BF_Exponent        = Exponent  ;
assign o_BF_Number_Value    = Value     ;




endmodule
