`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
/*
    Function    : 
    Description : 

    
*/

module C3_ExceptionHandling (
    input  [  2:0]    i_Type1                ,
    input             i_Sign1                ,
    input  [ 31:0]    i_Value1               ,
    input  [ 31:0]    i_Value2               ,
    input  [  2:0]    i_Type2                ,
    input             i_Sign2                ,

    input             i_Compute_Mode         ,
    input             i_Is_Widening          ,
    input  [  1:0]    i_Vector_Group_Num     ,
    input  [  2:0]    i_Compute_Precision    ,
    input  [ 19:0]    i_Exception_Handling   ,
    output [ 31:0]    o_Result               ,
    output            o_is_Exception         ,
    output            BFMOP_Widening_SBF     ,
    output            o_FMLAL                
);

wire            FPData_Width                ;
wire            FPInfinity_Sign             ;
wire            FPInfinity_Data_Width       ;
wire            FPZero_Sign                 ;
wire            FPZero_Data_Width           ;
wire            FPDefaultNaN_Data_Width     ;
wire            T_is_Exception              ;


wire [31:0]     FPDefaultNaN                ;
wire [31:0]     FPProcessNaN                ;
wire [31:0]     FPZero                      ;
wire            FPCR_DN                     ;
wire [31:0]     FPInfinity                  ;
wire            FPCR_EBF                    ;
wire            FPCR_AH                     ;
wire [ 5:0]     FPCR_Enable                 ;
wire            Inf1                        ;
wire            Inf2                        ;
wire            Zero1                       ;
wire            Zero2                       ;
wire            Sign_NaN                    ;
wire            Sign_PInfinity              ;
wire            Sign_Infinity               ;
wire            Sign_NInfinity              ;
wire            Sign_Zero                   ;
wire            Sign_Diff_Zero              ;
wire            Exception_Result            ;
wire            FPNumNaNDone                ;
wire [  1:0]    FPCR_RMode                  ;
// wire            BFMOP_Widening_SBF          ;

assign FPCR_RMode           = i_Exception_Handling[16:15]   ;
assign FPCR_DN              = i_Exception_Handling[18] ;
assign FPCR_AH              = i_Exception_Handling[1]                                     ;
assign FPCR_EBF             = i_Exception_Handling[8]                                     ;
assign Inf1                 = (i_Type1 == `FPType_Infinity)                               ;
assign Inf2                 = (i_Type2 == `FPType_Infinity)                               ;
assign Zero1                = (i_Type1 == `FPType_Zero)                                   ;
assign Zero2                = (i_Type2 == `FPType_Zero)                                   ;
assign FPData_Width         = i_Is_Widening | (((i_Compute_Mode == `Outer_Product & i_Compute_Precision == `FP16 & i_Is_Widening == 0) | ((i_Compute_Mode == `Inner_Product & i_Compute_Precision == `FP16 & i_Is_Widening == 0 & i_Vector_Group_Num == `Single_Vector_Group))) == 1'd1); 
assign Sign_NaN             = Inf1 & Inf2 & (i_Sign1 ^ i_Sign2)                           ;
assign Sign_PInfinity       = (Inf1 & (i_Sign1 == 1'd0)) | (Inf2 & (i_Sign2 == 1'd0))     ;
assign Sign_NInfinity       = (Inf1 & (i_Sign1 == 1'd1)) | (Inf2 & (i_Sign2 == 1'd1))     ;
assign Sign_Infinity        = Sign_PInfinity | Sign_NInfinity                             ;
assign FPInfinity_Sign      = Sign_NInfinity                                              ;
assign FPZero_Sign          = i_Sign1                                                     ;
assign Sign_Zero            = (Zero1 & Zero2 & ~(i_Sign1 ^ i_Sign2))                      ;
assign Sign_Diff_Zero       = (Zero1 & Zero2 & (i_Sign1 ^ i_Sign2))                       ;
assign o_is_Exception       = FPNumNaNDone | Sign_NaN | Sign_Infinity | Sign_Zero | Sign_Diff_Zero                       ;
assign BFMOP_Widening_SBF   = i_Compute_Mode & (i_Compute_Precision == `BF16) & i_Is_Widening & ~FPCR_EBF  ;
assign o_Result             = {32{FPNumNaNDone}} & FPProcessNaN | 
                                {32{Sign_NaN}} & FPDefaultNaN |       
                                {32{~FPNumNaNDone & ~Sign_NaN & Sign_Infinity}} & FPInfinity |      
                                {32{Sign_Zero | Sign_Diff_Zero}} & FPZero                                        ;
assign o_FMLAL              = ~i_Compute_Mode & (i_Compute_Precision == `FP16) & (i_Vector_Group_Num == `Double_Vector_Group) & i_Is_Widening ; 

C3_FPInfinity u_FPInfinity(
    .i_Sign        ( FPInfinity_Sign        ),
    .i_Data_Width  ( FPData_Width           ),
    .o_FPInfinity  ( FPInfinity             )
);

C3_FPDefaultNaN u_FPDefaultNaN(
    .i_FPCR_AH     ( FPCR_AH                    ),
    .i_Data_Width  ( FPData_Width               ),
    .o_DefaultNaN  ( FPDefaultNaN               )
);

C3_FPZero u_FPZero(
    .i_Sign             ( FPZero_Sign        ),
    .i_Data_Width       ( FPData_Width       ),
    .i_DiffSign_Zero    ( Sign_Diff_Zero     ),
    .i_FPCR_RMode       ( FPCR_RMode         ),
    .o_FPZero           ( FPZero             )
);

C3_FPProcessNaNs u_FPProcessNaNs(
    .i_FPCR_AH      ( FPCR_AH                   ),
    .i_FPCR_DN      ( FPCR_DN                   ),
    .i_Type         ( {i_Type2,i_Type1}         ),
    .i_Data_Width   ( {2{FPData_Width}}         ),
    .i_FPNumber     ( {i_Value2,i_Value1}       ),
    .o_FP_Result    ( FPProcessNaN              ),
    .o_Done         ( FPNumNaNDone              )
);

endmodule