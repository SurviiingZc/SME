//`include "D:/ZhuXingyu/Desktop/FP_Mul_Compare/Macro_Definition.v"
/*
Verision: 20250810
Added control signal
*/
`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
module C4_FPRoundBase #(
    parameter IN_WIDTH   = 48 ,
    parameter EXP_WIDTH  = 9         
)(
    input                               i_sign                      ,
    input  signed   [EXP_WIDTH-1:0]       i_biased_exp                ,
    input  signed   [EXP_WIDTH-1:0]       i_biased_exp_unconstrained  ,
    input  signed   [EXP_WIDTH-1:0]       i_exp_true                  ,
    input  signed   [EXP_WIDTH-1:0]       i_exponent                  ,
    input           [IN_WIDTH-1:0]      i_adjusted_mantissa         ,
    input  signed   [EXP_WIDTH-1:0]       i_minimum_exp               ,
    input           [IN_WIDTH-1:0]      i_mantissa                  ,
    input                               i_is_bf16                   ,
    input                               i_is_fp16                   ,
    input                               i_is_fp32                   ,
    input           [1:0]               i_Data_Width                ,
    input                               i_N                         ,
    input           [19:0]              i_Exception_Handling        ,
    output reg      [31:0]              o_Rounded_result
);
    // Parameter
    localparam FP32_F = 23                                          ;
    localparam FP16_F = 10                                          ;
    localparam BF16_F = 7                                           ;
    localparam FP16_F_HALF_0 = FP16_F-BF16_F                        ;
    localparam FP32_F_HALF_0 = FP32_F-BF16_F                        ;
    localparam BF16_IDX_HI = IN_WIDTH - 1                           ;
    localparam BF16_IDX_LO = IN_WIDTH - BF16_F-1                    ;
    localparam FP16_IDX_HI = IN_WIDTH - 1                           ;
    localparam FP16_IDX_LO = IN_WIDTH - FP16_F-1                    ;
    localparam FP32_IDX_HI = IN_WIDTH - 1                           ;
    localparam FP32_IDX_LO = IN_WIDTH - FP32_F-1                    ;
    localparam HALF_BF16 = {1'b1 , {(IN_WIDTH - BF16_F-2){1'b0}}}   ;
    localparam HALF_FP16 = {1'b1 , {(IN_WIDTH - FP16_F-2){1'b0}}}   ;
    localparam HALF_FP32 = {1'b1 , {(IN_WIDTH - FP32_F-2){1'b0}}}   ;
    localparam DENOR_BF16 = 8'h80                                   ;
    localparam DENOR_FP16 = 11'b1000_0000_000                       ;
    localparam DENOR_FP32 = 24'h800000                              ;
    // FPCR Control signals
    wire                        FPCR_AH         = i_Exception_Handling[1]       ;
    wire                        EBF             = i_Exception_Handling[8]       ;
    wire                        ALTFP           = `FEAT_AFP && FPCR_AH          ;
    wire                        FPCR_FZ16       = i_Exception_Handling[12]      ;
    wire                        FPCR_FZ         = i_Exception_Handling[17]      ;
    wire                        FPCR_APH        = i_Exception_Handling[19]      ;
    wire [1:0]                  RMODE           = i_Exception_Handling[16:15]   ;
    // carry signals
    wire                        carry_bf16_uncon                    ;
    wire                        carry_fp16_uncon                    ;
    wire                        carry_fp32_uncon                    ;
    wire                        carry_bf16                          ;
    wire                        carry_fp16                          ;
    wire                        carry_fp32                          ;
    wire                        round_deor2nor_bf16                 ;
    wire                        round_deor2nor_fp16                 ;
    wire                        round_deor2nor_fp32                 ;
    // Rounded mantissa 
    wire [BF16_F-1:0]           rounded_bf16_uncon                  ;
    wire [FP16_F-1:0]           rounded_fp16_uncon                  ;
    wire [FP32_F-1:0]           rounded_fp32_uncon                  ;
    wire [BF16_F-1:0]           rounded_bf16                        ;
    wire [FP16_F-1:0]           rounded_fp16                        ;
    wire [FP32_F-1:0]           rounded_fp32                        ;

    // Output   
    wire [31:0]                 o_FPInfinity                        ;
    wire [31:0]                 o_FPMaxNormal                       ;
    wire [31:0]                 o_Normal_Result                     ;
    wire [31:0]                 o_FPZero                            ;
    wire [31:0]                 o_FPZero_op0                        ;
    wire [31:0]                 o_FPNaN                             ;

    // Get int_mant error and half for all prisicion in advance 
    wire [BF16_IDX_HI:BF16_IDX_LO]  mant_bf16_uncon = i_mantissa[BF16_IDX_HI:BF16_IDX_LO]             ;
    wire [BF16_IDX_LO-1:0]          err_bf16_uncon  = i_mantissa[BF16_IDX_LO-1:0]                     ;
    wire [BF16_IDX_HI:BF16_IDX_LO]  mant_bf16       = i_adjusted_mantissa[BF16_IDX_HI:BF16_IDX_LO]    ;
    wire [BF16_IDX_LO-1:0]          err_bf16        = i_adjusted_mantissa[BF16_IDX_LO-1:0]            ;

    wire [FP16_IDX_HI:FP16_IDX_LO]  mant_fp16_uncon = i_mantissa[FP16_IDX_HI:FP16_IDX_LO]             ;
    wire [FP16_IDX_LO-1:0]          err_fp16_uncon  = i_mantissa[FP16_IDX_LO-1:0]                     ;
    wire [FP16_IDX_HI:FP16_IDX_LO]  mant_fp16       = i_adjusted_mantissa[FP16_IDX_HI:FP16_IDX_LO]    ;
    wire [FP16_IDX_LO-1:0]          err_fp16        = i_adjusted_mantissa[FP16_IDX_LO-1:0]            ;

    wire [FP32_IDX_HI:FP32_IDX_LO]  mant_fp32_uncon = i_mantissa[FP32_IDX_HI:FP32_IDX_LO]             ;
    wire [FP32_IDX_LO-1:0]          err_fp32_uncon  = i_mantissa[FP32_IDX_LO-1:0]                     ;
    wire [FP32_IDX_HI:FP32_IDX_LO]  mant_fp32       = i_adjusted_mantissa[FP32_IDX_HI:FP32_IDX_LO]    ;
    wire [FP32_IDX_LO-1:0]          err_fp32        = i_adjusted_mantissa[FP32_IDX_LO-1:0]            ;



    wire [IN_WIDTH-BF16_F-1:0] error_unconstrained = 
        ({IN_WIDTH-BF16_F{i_is_bf16}} & err_bf16_uncon) |
        ({IN_WIDTH-FP16_F{i_is_fp16}} & err_fp16_uncon) |
        ({IN_WIDTH-FP32_F{i_is_fp32}} & err_fp32_uncon);
    
    wire [IN_WIDTH-BF16_F-1:0] error = 
        ({IN_WIDTH-BF16_F{i_is_bf16}} & err_bf16) |
        ({IN_WIDTH-FP16_F{i_is_fp16}} & err_fp16) |
        ({IN_WIDTH-FP32_F{i_is_fp32}} & err_fp32);
    
    wire [IN_WIDTH-BF16_F-1:0] half = 
        ({IN_WIDTH-BF16_F{i_is_bf16}} & HALF_BF16) |
        ({IN_WIDTH-BF16_F{i_is_fp16}} & HALF_FP16) |
        ({IN_WIDTH-BF16_F{i_is_fp32}} & HALF_FP32);

    wire [FP32_F:0] int_mant = 
        ({(FP32_F+1){i_is_bf16}} & mant_bf16) |
        ({(FP16_F+1){i_is_fp16}} & mant_fp16) |
        ({(FP32_F+1){i_is_fp32}} & mant_fp32);

    wire [FP32_F:0] int_mant_unconstrained = 
        ({(FP32_F+1){i_is_bf16}} & mant_bf16_uncon) |
        ({(FP16_F+1){i_is_fp16}} & mant_fp16_uncon) |
        ({(FP32_F+1){i_is_fp32}} & mant_fp32_uncon);

    wire [EXP_WIDTH-1:0]      exponent_max         = (i_is_bf16) ? 9'd255 :(i_is_fp16) ? 9'd31 :9'd255         ;
    wire [EXP_WIDTH-1:0]      exponent_max_plus1   = (i_is_bf16) ? 9'd256 :(i_is_fp16) ? 9'd32 :9'd256         ;
    
    wire                    error_gt_half        = (error > half)                                        ;
    wire                    error_eq_half        = (error == half)                                       ;
    wire                    tie_condition        = error_eq_half && int_mant[0]                          ;
    wire                    error_uncon_gt_half  = (error_unconstrained > half)                          ;
    wire                    error_uncon_eq_half  = (error_unconstrained == half)                         ;
    wire                    tie_condition_uncon  = error_uncon_eq_half && int_mant_unconstrained[0]      ;

    
    // ALTFP Roundup case altfp_rounding[1:0]for ALTFP = 1 ; altfp_rounding[0] for ALTFP = 0
    wire [1:0] altfp_rounding = 
        (RMODE == `Round_to_Nearest_Mode) ? {error_uncon_gt_half | tie_condition_uncon, error_gt_half | tie_condition} :
        (RMODE == `Round_Towards_Plus_Infinity) ? {(error_unconstrained != 0) && !i_sign, (error != 0) && !i_sign} :
        (RMODE == `Round_Towards_Minus_Infinity) ? {(error_unconstrained != 0) && i_sign, (error != 0) && i_sign} :
        2'b00;

    wire round_up_unconstrained = ALTFP ? altfp_rounding[1] : 1'b0;
    wire round_up               = altfp_rounding[0];

    wire overflow_to_inf = 
        (RMODE == `Round_to_Nearest_Mode) ? 1'b1 :
        (RMODE == `Round_Towards_Plus_Infinity) ? !i_sign :
        (RMODE == `Round_Towards_Minus_Infinity) ? i_sign : 
        1'b0;
    
    // Apply Round
    wire carry_uncon = 
        (i_Data_Width == 2'd2) ? carry_bf16_uncon :
        (i_Data_Width == 2'd0) ? carry_fp16_uncon :
        carry_fp32_uncon;
    wire carry_main = 
        (i_Data_Width == 2'd2) ? carry_bf16 :
        (i_Data_Width == 2'd0) ? carry_fp16 :
        carry_fp32;

    wire [FP32_F:0] int_mant_round_uncon =                       
        (i_Data_Width == 2'd2) ? rounded_bf16_uncon :
        (i_Data_Width == 2'd0) ? rounded_fp16_uncon :
        rounded_fp32_uncon;
    wire [FP32_F:0] int_mant_round= 
        (i_Data_Width == 2'd2) ? rounded_bf16 :
        (i_Data_Width == 2'd0) ? rounded_fp16 :
        rounded_fp32;

    wire round_deor2nor = 
        (i_Data_Width == 2'd2) ? round_deor2nor_bf16 :
        (i_Data_Width == 2'd0) ? round_deor2nor_fp16 :
        round_deor2nor_fp32;


    wire signed [EXP_WIDTH:0] biased_exp_round_uncon = i_biased_exp_unconstrained + carry_uncon;
    wire        [FP32_F+1 :0] int_mant_uncon_final     = (round_up_unconstrained) ? (int_mant_round_uncon) : int_mant_unconstrained   ;    
    wire signed [EXP_WIDTH:0] biased_exp_round       = (round_deor2nor)         ?    1'b1                :(carry_main + i_biased_exp );
    wire        [FP32_F+1 :0] int_mant_round_final     = (round_up)               ?  int_mant_round        : int_mant                 ;
    
    
    // UF OF
    wire Is_FZ16               = FPCR_FZ16 && (i_N == 0);
    wire Is_FZ                 = FPCR_FZ   && (i_N == 1); 
    wire Is_exp_lt_mini        = (i_exponent < i_minimum_exp) ? 1'b1 : 1'b0;
    wire Is_flush              = Is_FZ16 | Is_FZ;
    wire IEEE_half             = i_N == 1 | FPCR_APH == 0;
    wire Alter_half            = i_N == 0 && FPCR_APH == 1;
    wire flush_zero_condition1 = !ALTFP && (Is_flush) && (Is_exp_lt_mini); 
    wire flush_zero_condition2 =  ALTFP && (Is_flush) && (biased_exp_round_uncon < 1) && (int_mant_uncon_final != 0) ;
    //wire flush_zero_condition3 = (i_exp_true == 0) && (op == 0);
    
    wire overflow_inf          = (biased_exp_round >= exponent_max) && (IEEE_half) && overflow_to_inf;
    wire overflow_maxnor       = (biased_exp_round >= exponent_max) && (IEEE_half) && (!overflow_to_inf);
    wire overflow_NaN          = (biased_exp_round >= exponent_max_plus1) && (Alter_half);

    always @(*) begin
    case (1'b1)
        // flush_zero_condition3:
        //     o_Rounded_result = o_FPZero_op0;
        flush_zero_condition1: 
            o_Rounded_result = o_FPZero;
        flush_zero_condition2: 
            o_Rounded_result = o_FPZero;
        overflow_inf: 
            o_Rounded_result = o_FPInfinity;
        overflow_maxnor:
            o_Rounded_result = o_FPMaxNormal;
        overflow_NaN: 
            o_Rounded_result = o_FPNaN;
        default: 
            o_Rounded_result = o_Normal_Result;
    endcase
    end

    C4_FPInfinity u_FPInfinity1(
        .i_Sign        ( i_sign             ),
        .i_Data_Width  ( i_Data_Width[0]    ),
        .o_FPInfinity  ( o_FPInfinity       )
    );

    C4_FPMaxNormal u_FPMaxNormal(
        .i_Sign         ( i_sign            ),
        .i_Data_Width   ( i_Data_Width[0]   ),
        .o_FPMaxNormal  ( o_FPMaxNormal     )
    );

    C4_Normal_Result#(
        .IN_WIDTH         ( IN_WIDTH ),
        .EXP_WIDTH        ( EXP_WIDTH )
    )u_Normal_Result(
        .i_Sign           ( i_sign           ),
        .biased_exp_round ( biased_exp_round ),
        .int_mant_round   ( int_mant_round_final   ),
        .i_Data_Width     ( i_Data_Width     ),
        .o_Normal_Result  ( o_Normal_Result  )
    );

    C4_FPNaN FPNaN(
        .i_Sign        ( i_sign             ),
        .i_Data_Width  ( i_Data_Width[0]    ),
        .o_FPNaN       ( o_FPNaN            )
    );

    C4_FPZero u_FPZero1(
        .i_Sign        ( i_sign             ),
        .i_Data_Width  ( i_Data_Width[0]    ),
        .o_FPZero      ( o_FPZero           )
    );
    // FPZero u_FPZero_op0(
    //     .i_Sign        ( i_sign             ),
    //     .i_Data_Width  ( i_Data_Width[0]    ),
    //     .o_FPZero      ( o_FPZero_op0       )
    // );

    C4_CarryDetector #(.WIDTH(BF16_F),.DENOR(DENOR_BF16)) bf16_detector_uncon (
        .mantissa(mant_bf16_uncon),
        .carry(carry_bf16_uncon),
        .rounded_mantissa(rounded_bf16_uncon)
    );
    C4_CarryDetector #(.WIDTH(FP16_F),.DENOR(DENOR_FP16)) fp16_detector_uncon (
        .mantissa(mant_fp16_uncon),
        .carry(carry_fp16_uncon),
        .rounded_mantissa(rounded_fp16_uncon)
    );
    C4_CarryDetector #(.WIDTH(FP32_F),.DENOR(DENOR_FP32)) fp32_detector_uncon (
        .mantissa(mant_fp32_uncon),
        .carry(carry_fp32_uncon),
        .rounded_mantissa(rounded_fp32_uncon)
    );

    C4_CarryDetector #(.WIDTH(BF16_F),.DENOR(DENOR_BF16)) bf16_detector_main (
        .mantissa(mant_bf16),
        .carry(carry_bf16),
        .round_deor2nor(round_deor2nor_bf16),
        .rounded_mantissa(rounded_bf16)
    );
    C4_CarryDetector #(.WIDTH(FP16_F),.DENOR(DENOR_FP16)) fp16_detector_main (
        .mantissa(mant_fp16),
        .round_deor2nor(round_deor2nor_fp16),
        .carry(carry_fp16),
        .rounded_mantissa(rounded_fp16)
    );
    C4_CarryDetector #(.WIDTH(FP32_F),.DENOR(DENOR_FP32)) fp32_detector_main (
        .mantissa(mant_fp32),
        .round_deor2nor(round_deor2nor_fp32),
        .carry(carry_fp32),
        .rounded_mantissa(rounded_fp32)
    );
endmodule