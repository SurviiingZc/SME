//`include "D:/ZhuXingyu/Desktop/FP_Mul_Compare/Macro_Definition.v"
/*
Verision: 20250810
Added control signal
*/
module C4_BFRound #(
    parameter IN_WIDTH   = 48 ,
    parameter EXP_WIDTH  = 9         
)(
    input                                               i_sign                      ,
    input                                               i_N                         ,  // 1 > 32 0 > 16
    input      signed   [EXP_WIDTH-1:0]                 biased_exp                  ,
    input      signed   [EXP_WIDTH-1:0]                 exponent                    ,
    input                                               i_sticky_bit                ,
    input               [IN_WIDTH-1:0]                  adjusted_mantissa           ,
    output              [31:0]                          o_round_result            
);
    localparam E = 8                                             ;   // Exponent bits
    localparam F = 23                                            ;   // Fraction bits
    localparam minimum_exp = -126                                ;   // Minimum exponent value
    localparam BF16_IDX_HI = IN_WIDTH - 1                        ;
    localparam BF16_IDX_LO = IN_WIDTH - F-1                      ;
    wire                   S_bit                        ;
    wire                   L_bit                        ;
    wire        [31:0]     normal_Result                ;
    reg         [31:0]     round_result                 ;
    wire        [F-1:0]    int_mant                     ;
    wire        [F-1:0]    int_mant_roundup             ;
    wire        [F-1:0]    int_mant_round               ;
    wire                   flush_zero_condition         ;

    assign      int_mant                 = adjusted_mantissa[BF16_IDX_HI:BF16_IDX_LO]       ;
    assign      S_bit                    = |adjusted_mantissa[BF16_IDX_LO:0] | i_sticky_bit ;
    assign      L_bit                    = ~int_mant[0]                                     ;
    assign      int_mant_roundup         = int_mant + 1'b1                                  ;
    assign      int_mant_round           = ( S_bit && L_bit) ? (int_mant_roundup) : int_mant;   
    assign      flush_zero_condition     = (exponent < minimum_exp) ? 1'b1 : 1'b0           ;
    assign      normal_Result            = {i_sign,biased_exp[7:0],int_mant_round[22:0]}    ;
    assign      o_round_result           = round_result                                     ;
    always @(*) begin
        if (flush_zero_condition) begin
            round_result = {i_sign,31'd0};
        end else begin
            if (biased_exp >= 8'hFF ) begin
                round_result = {i_sign,8'hFF,23'd0};
            end else begin
                round_result = normal_Result;
            end
        end
    end
endmodule