`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : Unpacking floating-point numbers
    Description : 

    
*/

module C1_FPUnpackBase (
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
wire          is_FP16       ;
wire          FPEXC_TFV     ;
wire          FP16ExpoAll0  ;
wire          FP16ExpoAll1  ;
wire          FP16FracAll0  ;
wire          FP32ExpoAll0  ;
wire          FP32ExpoAll1  ;
wire          FP32FracAll0  ;

wire [ 2:0]   Fptype_16        ;
wire [31:0]   Value_16         ;
wire [ 7:0]   Exponent_16      ;
wire [23:0]   Mantissa_16      ;
wire [ 2:0]   Fptype_32        ;
wire [31:0]   Value_32         ;
wire [ 7:0]   Exponent_32      ;
wire [23:0]   Mantissa_32      ;

reg            FPEXC_IDF     ;
wire  [ 4:0]   Exp16         ;
wire  [ 9:0]   Frac16        ;
wire  [ 7:0]   Exp32         ;
wire  [22:0]   Frac32        ;

wire           Sign          ;

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

assign Sign                 = is_32_bits ? FP_Number[31] : FP_Number[15]                        ;
assign Exp16                = FP_Number[14:10]                                                  ;
assign Frac16               = FP_Number[9:0]                                                    ;
assign Exp32                = IsBfloat16 ? FP_Number[14:7] : FP_Number[30:23]                   ;
assign Frac32               = IsBfloat16 ? {FP_Number[6:0],16'd0} : FP_Number[22:0]             ;
assign FP16ExpoAll0         = |Exp16 == 1'd0                                                    ;
assign FP16ExpoAll1         = &Exp16 == 1'd1                                                    ;
assign FP16FracAll0         = |Frac16 == 1'd0                                                   ;
assign FP32ExpoAll0         = |Exp32 == 1'd0                                                    ;
assign FP32ExpoAll1         = &Exp32 == 1'd1                                                    ;
assign FP32FracAll0         = |Frac32 == 1'd0                                                   ;



assign Fptype_16            = {3{(FP16ExpoAll0 & (FP16FracAll0 | FPCR_FZ16))}} & `FPType_Zero |
                                {3{(FP16ExpoAll0 & ~(FP16FracAll0 | FPCR_FZ16))}} & `FPType_Denormal |
                                {3{(FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format) & FP16FracAll0)}} & `FPType_Infinity |
                                {3{(FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format) & ~FP16FracAll0 & Frac16[9])}} & `FPType_QNaN |
                                {3{(FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format) & ~FP16FracAll0 & ~Frac16[9])}} & `FPType_SNaN |
                                {3{~(FP16ExpoAll0 | (FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format)))}} & `FPType_Nonzero;
assign Value_16             = {3{(FP16ExpoAll0 & (FP16FracAll0 | FPCR_FZ16))}} & {16'd0,Sign,15'd0} |
                                {3{(FP16ExpoAll0 & ~(FP16FracAll0 | FPCR_FZ16))}} & {16'd0,Sign,5'd1,Frac16} |
                                {3{(FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format) & FP16FracAll0)}} & {16'd0,Sign,Exp16,Frac16} |
                                {3{(FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format) & ~FP16FracAll0 & Frac16[9])}} & {16'd0,Sign,15'd0} |
                                {3{(FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format) & ~FP16FracAll0 & ~Frac16[9])}} & {16'd0,Sign,15'd0} |
                                {3{~(FP16ExpoAll0 | (FP16ExpoAll1 & (FPCR_AHP == `IEEE_Half_Precision_Format)))}} & {16'd0,Sign,Exp16,Frac16}  ;
assign Exponent_16          = (FP16ExpoAll0 & ~(FP16FracAll0 | FPCR_FZ16)) ? {3'd0,5'd1} : {3'd0,Exp16}                                                                  ;
assign Mantissa_16          = (Fptype_16 == `FPType_Nonzero) ? {1'd1,Frac16,13'd0} : {1'd0,Frac16,13'd0};

assign Fptype_32            = {3{(FP32ExpoAll0 & (FP32FracAll0 | FPCR_FZ | FPCR_FIZ))}} & `FPType_Zero |
                                {3{(FP32ExpoAll0 & ~(FP32FracAll0 | FPCR_FZ | FPCR_FIZ))}} & `FPType_Denormal |
                                {3{(FP32ExpoAll1 & FP32FracAll0)}} & `FPType_Infinity |
                                {3{(FP32ExpoAll1 & ~FP32FracAll0 & Frac32[22])}} & `FPType_QNaN |
                                {3{(FP32ExpoAll1 & ~FP32FracAll0 & ~Frac32[22])}} & `FPType_SNaN | 
                                {3{~(FP32ExpoAll0 | FP32ExpoAll1)}} & `FPType_Nonzero ;
assign Value_32             = {3{(FP32ExpoAll0 & (FP32FracAll0 | FPCR_FZ | FPCR_FIZ))}} & {Sign,31'd0} |
                                {3{(FP32ExpoAll0 & ~(FP32FracAll0 | FPCR_FZ | FPCR_FIZ))}} & {Sign,8'd1,Frac32} |
                                {3{(FP32ExpoAll1 & FP32FracAll0)}} & {Sign,Exp32,Frac32} |
                                {3{(FP32ExpoAll1 & ~FP32FracAll0 & Frac32[22])}} & {Sign,31'd0} |
                                {3{(FP32ExpoAll1 & ~FP32FracAll0 & ~Frac32[22])}} & {Sign,31'd0} | 
                                {3{~(FP32ExpoAll0 | FP32ExpoAll1)}} & {Sign,Exp32,Frac32} ;
assign Exponent_32          = (FP32ExpoAll0 & ~(FP32FracAll0 | FPCR_FZ | FPCR_FIZ)) ? 8'd1 : Exp32 ;
assign Mantissa_32          = (Fptype_32 == `FPType_Nonzero) ? {1'd1,Frac32} : {1'd0,Frac32}    ;


assign o_FP_Number_Sign     = is_32_bits ? FP_Number[31] : FP_Number[15]    ;
assign o_FPType             = is_32_bits ? Fptype_32     : Fptype_16        ;
assign o_FP_Exponent        = is_32_bits ? Exponent_32   : Exponent_16      ;
assign o_FP_Mantissa        = is_32_bits ? Mantissa_32   : Mantissa_16      ;
assign o_FP_Number_Value    = is_32_bits ? Value_32      : Value_16         ;
endmodule