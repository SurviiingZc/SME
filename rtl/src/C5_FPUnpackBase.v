`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : Unpacking floating-point numbers
    Description : 

    
*/

module C5_FPUnpackBase (
    input  [31:0]      FP_Number            ,
    input  [ 2:0]      i_Compute_Precision  ,
    input  [19:0]      i_Exception_Handling ,
    output [ 2:0]      o_FPType             ,
    output             o_FP_Number_Sign     ,
    output [ 7:0]      o_FP_Exponent        ,
    output [23:0]      o_FP_Mantissa        ,
    output [31:0]      o_FP_Number_Value    
);

wire          FPCR_FIZ      ;
wire          FPCR_FZ16     ;
wire          FPCR_IDE      ;
wire          FPCR_AH       ;
wire          FPCR_FZ       ;
wire          FPCR_AHP      ;
wire          ALTFP         ;
wire          FIZ           ;
wire          FZ            ;
wire          IsBfloat16    ;
wire          is_8_bits     ;
wire          is_16_bits    ;
wire          is_32_bits    ;
wire [ 5:0]   N             ;
wire          is_FP16       ;
// Trapped_Fault_Valid
wire          FPEXC_TFV     ;
wire          Sign          ;
wire [ 4:0]   Exp16         ;
wire [ 9:0]   Frac16        ;
wire [ 7:0]   Exp32         ;
wire [22:0]   Frac32        ;

wire          FP16ExpoAll0              ;
wire          FP16ExpoAll1              ;
wire          FP16FracAll0              ;
wire [ 2:0]   FP16ZeroAndDenormalType   ;
wire [ 2:0]   FP16NaNType               ;
wire [ 2:0]   FP16InfinityAndNaNType    ;
wire [ 2:0]   FP16Fptype                ;

wire [31:0]   FP16ZeroAndDenormalValue  ;
wire [31:0]   FP16NaNValue              ;
wire [31:0]   FP16InfinityAndNaNValue   ;
wire [31:0]   FP16Value                 ;

wire [ 7:0]   FP16ZeroAndDenormalExpo   ;
wire [ 7:0]   FP16NaNExpo               ;
wire [ 7:0]   FP16InfinityAndNaNExpo    ;
wire [ 7:0]   FP16Expo                  ;
wire [23:0]   FP16Mantissa              ;

wire          FPEXC_IDF                 ;
wire          Input_Denormal            ;
wire          FP32ExpoAll0              ;
wire          FP32ExpoAll1              ;
wire          FP32FracAll0              ;
wire [ 2:0]   FP32ZeroAndDenormalType   ;
wire [ 2:0]   FP32NaNType               ;
wire [ 2:0]   FP32InfinityAndNaNType    ;
wire [ 2:0]   FP32Fptype                ;

wire [31:0]   FP32ZeroAndDenormalValue  ;
wire [31:0]   FP32NaNValue              ;
wire [31:0]   FP32InfinityAndNaNValue   ;
wire [31:0]   FP32Value                 ;

wire [ 7:0]   FP32ZeroAndDenormalExpo   ;
wire [ 7:0]   FP32NaNExpo               ;
wire [ 7:0]   FP32InfinityAndNaNExpo    ;
wire [ 7:0]   FP32Expo                  ;
wire [23:0]   FP32Mantissa              ;

assign o_FP_Number_Sign     = Sign                                        ;
assign o_FP_Number_Value    = is_FP16 ? FP16Value : FP32Value             ;
assign o_FP_Mantissa        = is_FP16 ? FP16Mantissa : FP32Mantissa       ;
assign o_FP_Exponent        = is_FP16 ? FP16Expo : FP32Expo               ;
assign o_FPType             = is_FP16 ? FP16Fptype : FP32Fptype           ;


assign FPCR_FIZ     = i_Exception_Handling[ 0]                          ;
assign FPCR_AH      = i_Exception_Handling[ 1]                          ;
assign FPCR_FZ16    = i_Exception_Handling[12]                          ;
assign FPCR_FZ      = i_Exception_Handling[17]                          ;
assign FPCR_AHP     = i_Exception_Handling[19]                          ;
assign FPCR_IDE     = i_Exception_Handling[ 9]                          ;
assign ALTFP        = (`FEAT_AFP == 1'd1)                               ;     
assign FIZ          = ALTFP & (FPCR_FIZ == 1'd1)                       ;
assign FZ           = (FPCR_FZ == 1'd1) & (ALTFP & FPCR_AH == 1'd1)   ;
assign IsBfloat16   = (i_Compute_Precision == `BF16)                    ;
assign is_8_bits    = ((i_Compute_Precision == `FP8))                                                 ;
assign is_16_bits   = ((i_Compute_Precision == `BF16) | (i_Compute_Precision == `FP16))               ;
assign is_32_bits   = ((i_Compute_Precision == `FP32))                                                ;
assign is_FP16      = ((is_16_bits == 1'd1) & ~IsBfloat16)                                           ;

assign Sign                     = (is_32_bits == 1'd1) ? FP_Number[31] : FP_Number[15]          ;
assign Exp16                    = FP_Number[14:10]                                              ;
assign Frac16                   = FP_Number[9:0]                                                ;
assign FP16ExpoAll0             = (|Exp16 == 1'd0)                                              ;
assign FP16ExpoAll1             = (&Exp16 == 1'd1)                                              ;
assign FP16FracAll0             = (|Frac16 == 1'd0)                                             ;
assign FP16ZeroAndDenormalType  = (FP16FracAll0 | FPCR_FZ16) ? `FPType_Zero : `FPType_Denormal ;
assign FP16NaNType              = (Frac16[9] == 1'd1) ? `FPType_QNaN : `FPType_SNaN             ;
assign FP16InfinityAndNaNType   = FP16FracAll0 ? `FPType_Infinity : FP16NaNType                     ;
assign FP16Fptype               = {3{(FP16ExpoAll1 & ((FPCR_AHP == `IEEE_Half_Precision_Format)))}} & FP16InfinityAndNaNType | 
                                    {3{FP16ExpoAll0}} & FP16ZeroAndDenormalType | 
                                    {3{FP16ExpoAll0 | (FP16ExpoAll1 & ((FPCR_AHP == `IEEE_Half_Precision_Format)))}} & `FPType_Nonzero    ;

assign FP16ZeroAndDenormalValue = (FP16FracAll0 | FPCR_FZ16) ? {16'd0,Sign,15'd0} : {16'd0,Sign,Exp16,Frac16}              ;
assign FP16NaNValue             = {16'd0,Sign,15'd0}                                                                        ;
assign FP16InfinityAndNaNValue  = FP16FracAll0 ? {16'd0,Sign,Exp16,Frac16} : FP16NaNValue                                   ;
assign FP16Value                = {32{(FP16ExpoAll1 & ((FPCR_AHP == `IEEE_Half_Precision_Format)))}} & FP16InfinityAndNaNValue | 
                                    {32{FP16ExpoAll0}} & FP16ZeroAndDenormalValue |
                                    {32{~(FP16ExpoAll1 & ((FPCR_AHP == `IEEE_Half_Precision_Format))) | FP16ExpoAll0}} & {16'd0,Sign,Exp16,Frac16}    ;

assign FP16Expo                 = {3'd0,Exp16}                                                  ;
assign FP16Mantissa             = (~FP16ExpoAll0 & ~FP16ExpoAll1) ? {13'd0,1'd1,Frac16} : {13'd0,1'd0,Frac16}         ;

assign Exp32                    = (IsBfloat16 == 1'd1) ? FP_Number[14:7] : FP_Number[30:23]     ;
assign Frac32                   = (IsBfloat16 == 1'd1) ? {FP_Number[6:0],16'd0} : FP_Number[22:0]     ;
assign FP32ExpoAll0             = (|Exp32 == 1'd0)                                              ;
assign FP32ExpoAll1             = (&Exp32 == 1'd1)                                              ;
assign FP32FracAll0             = (|Frac32 == 1'd0)                                             ;

assign FP32ZeroAndDenormalType  = (FP32FracAll0 | FPCR_FZ | FPCR_FIZ) ? `FPType_Zero : `FPType_Denormal ;
assign FP32NaNType              = (Frac32[22] == 1'd1) ? `FPType_QNaN : `FPType_SNaN                      ;
assign FP32InfinityAndNaNType   = FP32FracAll0 ? `FPType_Infinity : FP32NaNType                           ;
assign FP32Fptype               = {3{FP32ExpoAll0}} & FP32ZeroAndDenormalType |
                                    {3{FP32ExpoAll1}} & FP32InfinityAndNaNType | 
                                    {3{~(FP32ExpoAll0 | FP32ExpoAll1)}} & `FPType_Nonzero               ;

assign FP32ZeroAndDenormalValue = (FP32FracAll0 | FPCR_FZ | FPCR_FIZ) ? {Sign,31'd0} : {Sign,8'b00000000,Frac32} ;
assign FP32NaNValue             = {Sign,31'd0}                                                            ;
assign FP32InfinityAndNaNValue  = FP32FracAll0 ? {Sign,Exp32,Frac32} : FP32NaNValue                       ;
assign FP32Value                = {32{FP32ExpoAll0}} & FP32ZeroAndDenormalValue | 
                                    {32{FP32ExpoAll1}} & FP32InfinityAndNaNValue |
                                    {32{~(FP32ExpoAll0 | FP32ExpoAll1)}} & {Sign,Exp32,Frac32}          ;

assign FP32Expo                 = Exp32 ;
assign FP32Mantissa             = (~FP32ExpoAll0 & ~FP32ExpoAll1) ? {1'd1,Frac32} : {1'd0,Frac32}        ;


endmodule