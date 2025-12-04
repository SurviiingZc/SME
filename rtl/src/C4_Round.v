`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
module C4_Round #(
    parameter IN_WIDTH  = 49,  
    parameter EXP_WIDTH = 9
)(
    input       [IN_WIDTH-1:0]  i_op                        ,
    input       [EXP_WIDTH-1:0] i_exp                       ,    
    input                       i_sign                      ,                         
    input       [19:0]          i_Exception_Handling        ,     // FPCR register  
    input                       i_N                         ,     // 1 > 32 0 > 16
    input                       i_isbfloat16                ,     // bfloat16 flag 
    input                       i_sticky_bit                ,
    output                      o_sign                      ,
    output      [IN_WIDTH-1:0]  o_normal_mantissa           ,    
    output      [EXP_WIDTH :0]  o_normal_exp                , 
    output      [31:0]          o_rounded_result                  // Rounded result
);


    wire  signed   [EXP_WIDTH-1:0]       i_biased_exp                ;
    wire  signed   [EXP_WIDTH-1:0]       i_biased_exp_unconstrained  ;
    wire  signed   [EXP_WIDTH-1:0]       i_exp_true                  ;
    wire  signed   [EXP_WIDTH-1:0]       i_exponent                  ;
    wire           [IN_WIDTH-1:0]        i_adjusted_mantissa         ;
    wire  signed   [EXP_WIDTH-1:0]       i_minimum_exp               ;
    wire           [IN_WIDTH-1:0]        i_mantissa                  ;
    wire           [31:0]                FPRoundBase_result          ;
    wire           [31:0]                BFRound_result              ;
    wire                                 o_sign                      ;

    wire        is_bf16         = (i_N == 1) & i_isbfloat16                                         ;
    wire        is_fp16         = (i_N == 0)                                                        ;
    wire        is_fp32         = (i_N == 1) & !i_isbfloat16                                        ;
    wire [1:0]  i_Data_Width    = (is_bf16) ? 2'd2 : (is_fp16) ? 2'd0 : (is_fp32) ? 2'd1 : 2'b0     ;
    wire        EBF             = i_Exception_Handling[8]                                           ;

    //assign o_rounded_result     = (EBF == 0 | !`FEAT_EBF16 ) ? BFRound_result : FPRoundBase_result ;
    //1102改
    reg [31:0] result;
    always @(*) begin
        if (is_bf16) begin
            result = (EBF == 0 | !`FEAT_EBF16 ) ? BFRound_result : FPRoundBase_result;
        end else begin
            result = FPRoundBase_result;
        end
    end
    assign o_rounded_result = result;
    assign o_normal_exp         = i_biased_exp                                                      ;
    assign o_normal_mantissa    = i_adjusted_mantissa                                               ;

    C4_BFRound#(
        .IN_WIDTH           ( IN_WIDTH ),
        .EXP_WIDTH          ( EXP_WIDTH )
    )u_C4_BFRound(
        .i_sign             ( i_sign             ),
        .i_N                ( i_N                ),
        .biased_exp         ( i_biased_exp         ),
        .exponent           ( i_exponent           ),
        .adjusted_mantissa  ( i_adjusted_mantissa  ),
        .i_sticky_bit       ( i_sticky_bit         ),
        .o_Rounded_result   ( BFRound_result       )
    );

    C4_FPRoundBase#(
    .IN_WIDTH                    ( IN_WIDTH ),
    .EXP_WIDTH                   ( EXP_WIDTH )
)u_C4_FPRoundBase(
    .i_sign                      ( i_sign                      ),
    .i_biased_exp                ( i_biased_exp                ),
    .i_biased_exp_unconstrained  ( i_biased_exp_unconstrained  ),
    .i_exp_true                  ( i_exp_true                  ),
    .i_exponent                  ( i_exponent                  ),
    .i_adjusted_mantissa         ( i_adjusted_mantissa         ),
    .i_minimum_exp               ( i_minimum_exp               ),
    .i_mantissa                  ( i_mantissa                  ),
    .i_sticky_bit                ( i_sticky_bit                ),
    .i_is_bf16                   ( is_bf16                     ),
    .i_is_fp16                   ( is_fp16                     ),
    .i_is_fp32                   ( is_fp32                     ),
    .i_Data_Width                ( i_Data_Width                ),
    .i_N                         ( i_N                         ),
    .i_Exception_Handling        ( i_Exception_Handling        ),
    .o_Rounded_result            ( FPRoundBase_result          )
);

    C4_NormalizeReal#(
    .IN_WIDTH                  ( IN_WIDTH ),
    .OUT_WIDTH                 ( IN_WIDTH ),
    .EXP_WIDTH                 ( EXP_WIDTH )
)u_C4_NormalizeReal(
    .i_sign                    ( i_sign                    ),
    .i_exp                     ( i_exp                     ),
    .i_mantissa_in             ( i_op                      ),
    .i_Data_Width              ( i_Data_Width              ), 
    .o_sign                    ( o_sign                    ),
    .biased_exp                ( i_biased_exp              ),
    .biased_exp_unconstrained  ( i_biased_exp_unconstrained),
    .i_exp_true                ( i_exp_true                ),
    .exponent                  ( i_exponent                ),
    .adjusted_mantissa         ( i_adjusted_mantissa       ),
    .minimum_exp               ( i_minimum_exp             ),
    .mantissa                  ( i_mantissa                )
);

endmodule