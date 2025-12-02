//`include "D:/ZhuXingyu/Desktop/FP_Mul_Compare/Macro_Definition.v"
/*
Verision: 20250810
Added control signal
*/
`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
module C2_Round #(
    parameter IN_WIDTH   = 48 ,
    parameter EXP_WIDTH  = 9         
)(
    input       [IN_WIDTH-1:0]   i_op                  ,
    input                        i_sign                ,
    input       [EXP_WIDTH-1:0]  i_exp                 ,
    input       [19:0]           i_Exception_Handling  ,
    input                        i_N                   ,  // 1 > 32 0 > 16
    input                        i_isbfloat16          ,
    //input                        i_is_Multiplier       ,
    output                       o_sign                ,
    output reg  [31:0]           o_round_result        ,
    output      [IN_WIDTH-1:0]   o_normal_mantissa     ,
    output      [EXP_WIDTH :0]   o_normal_exp          
);

    localparam E = 8                                             ;   // Exponent bits
    localparam F = 23                                            ;   // Fraction bits
    localparam minimum_exp = -126                                ;   // Minimum exponent value
    localparam BF16_IDX_HI = IN_WIDTH - 1                        ;
    localparam BF16_IDX_LO = IN_WIDTH - F-1                      ;
    wire signed [EXP_WIDTH:0]       biased_exp                   ;
    //wire signed [EXP_WIDTH:0]       biased_exp_unconstrained     ;
    //wire signed [EXP_WIDTH:0]       i_exp_true                   ;
    wire signed [EXP_WIDTH:0]       exponent                     ;
    //wire        [IN_WIDTH-1 :0]     mantissa                     ;
    wire        [IN_WIDTH-1 :0]     adjusted_mantissa            ;
    wire        [31         :0]     o_Normal_Result              ;
    wire        [31         :0]     o_FPZero                     ;
    wire        [31         :0]     o_FPInfinity                 ;
    wire        EBF                                              = i_Exception_Handling[8]                                                          ;
    wire        [BF16_IDX_HI:BF16_IDX_LO] int_mant               = adjusted_mantissa[BF16_IDX_HI:BF16_IDX_LO]                                       ;
    wire        [BF16_IDX_LO:0]           error                  = adjusted_mantissa[BF16_IDX_LO:0]                                                 ;
    wire        [F:0]                     int_mant_round         = ( error != 0 && int_mant[BF16_IDX_LO] == 1'b0) ? (int_mant + 1'b1) : int_mant    ;   
    wire                                  flush_zero_condition   = (exponent < minimum_exp) ? 1'b1 : 1'b0                         ;
    wire        [31         :0]           Normal_Result          = {i_sign,biased_exp[7:0],int_mant_round[22:0]}                                    ;
    wire        is_bf16                     = (i_N == 1) & i_isbfloat16                                                                             ;
    wire        is_fp16                     = (i_N == 0)                                                                                            ;
    wire        is_fp32                     = (i_N == 1) & !i_isbfloat16                                                                            ;
    wire [1:0]  i_Data_Width                                                                                                                        ;
    assign      i_Data_Width[1]             = is_bf16                                                                                               ;
    assign      i_Data_Width[0]             = is_fp32                                                                                               ;
    assign      o_normal_mantissa           = adjusted_mantissa                                                                                     ;
    assign      o_normal_exp                = biased_exp                                                                                            ;
    always @(*) begin
        if (flush_zero_condition) begin
            o_round_result = o_FPZero;
        end else begin
            if (biased_exp == 8'hFF ) begin
                o_round_result = o_FPInfinity;
            end else begin
                o_round_result = Normal_Result;
            end
        end
    end

    C2_NormalizeReal#(
        .IN_WIDTH                  ( IN_WIDTH ),
        .OUT_WIDTH                 ( IN_WIDTH ),
        .EXP_WIDTH                 ( EXP_WIDTH )
    )u_NormalizeReal(
        .i_sign                    ( i_sign                    ),
        .i_exp                     ( i_exp                     ),
        .i_mantissa_in             ( i_op                      ),
        .i_Data_Width              ( i_Data_Width              ),
        //.i_is_Multiplier           ( i_is_Multiplier           ),
        .o_sign                    ( o_sign                    ),
        .biased_exp                ( biased_exp                ),
        //.biased_exp_unconstrained  ( biased_exp_unconstrained  ),
        //.i_exp_true                ( i_exp_true                ),
        .exponent                  ( exponent                  ),
        .adjusted_mantissa         ( adjusted_mantissa         )
        //.mantissa                  ( mantissa                  )
    );


    C2_FPInfinity u_FPInfinity_BFRound(
        .i_Sign        ( i_sign        ),
        .i_Data_Width  ( i_N           ),
        .o_FPInfinity  ( o_FPInfinity  )
    );

    C2_FPZero u_FPZero_BFRound(
    .i_Sign        ( i_sign        ),
    .i_Data_Width  ( i_N           ),
    .o_FPZero      ( o_FPZero      )
    );



endmodule