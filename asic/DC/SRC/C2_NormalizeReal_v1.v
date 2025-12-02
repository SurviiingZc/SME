/*
Verision: 20250926
*/
module C2_NormalizeReal #(
    parameter IN_WIDTH  = 48,
    parameter OUT_WIDTH = 48,
    parameter EXP_WIDTH = 9
)(
    input                                   i_sign,
    input        [EXP_WIDTH-1:0]            i_exp,
    input  wire  [IN_WIDTH-1:0]             i_mantissa_in,
    input        [1:0]                      i_Data_Width,
    input                                   i_is_Multiplier,

    output                                  o_sign,
    output reg   signed [EXP_WIDTH:0]       biased_exp,
    output       signed [EXP_WIDTH:0]       biased_exp_unconstrained,
    output       signed [EXP_WIDTH:0]       i_exp_true,
    output       signed [EXP_WIDTH:0]       exponent,
    output reg          [OUT_WIDTH-1:0]     adjusted_mantissa,
    output reg   signed [EXP_WIDTH:0]       minimum_exp,
    output reg          [OUT_WIDTH-1:0]     mantissa
);

    wire is1_fp16 = (i_Data_Width==2'b00);
    wire is1_fp32 = (i_Data_Width==2'b01);
    wire is1_bf16 = (i_Data_Width==2'b10);

    wire [5:0] adj_exp_w =
        ({6{is1_fp16}} & 6'd26) |
        ({6{is1_fp32}} & 6'd0 ) |
        ({6{is1_bf16}} & 6'd32) |
        ({6{~(is1_fp16|is1_fp32|is1_bf16)}} & 6'd0); // default: 0

    wire signed [EXP_WIDTH:0] minimum_exp_w =
        ({(EXP_WIDTH+1){is1_fp16}} & $signed(-14))  |
        ({(EXP_WIDTH+1){is1_fp32}} & $signed(-126)) |
        ({(EXP_WIDTH+1){is1_bf16}} & $signed(-126)) |
        ({(EXP_WIDTH+1){~(is1_fp16|is1_fp32|is1_bf16)}} & $signed(-126));

    wire [5:0] adj_exp = adj_exp_w;

    
    wire signed [5:0] lzc_shift_amt;
    C2_LZC_round #(.WIDTH(IN_WIDTH)) lzc_inst (
        .in      (i_mantissa_in ),
        .o_count (lzc_shift_amt )
    );

    wire cond_zero  = ~(|i_mantissa_in);
    wire cond_lzc0  = (lzc_shift_amt==6'd0);
    wire cond_else  = ~(cond_zero | cond_lzc0);

    wire [5:0] shift_zero = 6'd0;
    wire [5:0] shift_lzc0 = 6'd1;
    wire [5:0] shift_else = lzc_shift_amt;

    wire [5:0] shift_amt_w =
        ({6{cond_zero}} & shift_zero) |
        ({6{~cond_zero & cond_lzc0}} & shift_lzc0) |
        ({6{cond_else}} & shift_else);

    wire [OUT_WIDTH-1:0] mantissa_zero = {OUT_WIDTH{1'b0}};     // 初始化为0
    wire [OUT_WIDTH-1:0] mantissa_lzc0 = {OUT_WIDTH{1'b0}};     // 未移位
    wire [OUT_WIDTH-1:0] mantissa_else = i_mantissa_in << shift_else; // mantissa = i_mantissa_in << shift_amt;

    wire [OUT_WIDTH-1:0] mantissa_w =
        ({OUT_WIDTH{cond_zero}}               & mantissa_zero) |
        ({OUT_WIDTH{~cond_zero & cond_lzc0}}  & mantissa_lzc0) |
        ({OUT_WIDTH{cond_else}}               & mantissa_else);

    wire signed [EXP_WIDTH:0] exponent_adj_zero  = $signed(adj_exp) + $signed(9'd1);
    wire signed [EXP_WIDTH:0] exponent_adj_lzc0  = $signed(lzc_shift_amt) + $signed(adj_exp);
    wire signed [EXP_WIDTH:0] exponent_adj_else  = -$signed(shift_else) + $signed(adj_exp) + $signed(9'd1);

    wire signed [EXP_WIDTH:0] exponent_adj_w =
        ({(EXP_WIDTH+1){cond_zero}}              & exponent_adj_zero) |
        ({(EXP_WIDTH+1){~cond_zero & cond_lzc0}} & exponent_adj_lzc0) |
        ({(EXP_WIDTH+1){cond_else}}              & exponent_adj_else);

    assign o_sign = i_sign;

    wire signed [EXP_WIDTH:0] minimum_exp_minus1 = minimum_exp_w - $signed(1);
    assign exponent                 = $signed({1'b0,i_exp}) + exponent_adj_w + minimum_exp_minus1;
    assign i_exp_true               = $signed({1'b0,i_exp}) + minimum_exp_minus1;
    assign biased_exp_unconstrained = exponent - minimum_exp_minus1;

    wire is_denormal = (exponent <= 0);

    wire cond_denorm      = is_denormal;
    wire cond_denorm_zero = is_denormal & (i_exp_true==0);
    wire cond_denorm_else = is_denormal & (i_exp_true!=0);
    wire cond_norm        = ~is_denormal;

    wire [OUT_WIDTH-1:0] adjm_denorm_zero = i_mantissa_in;                 
    wire [OUT_WIDTH-1:0] adjm_denorm_else = i_mantissa_in >> (-i_exp_true);
    wire [OUT_WIDTH-1:0] adjm_norm        = mantissa_w;                    

    wire [OUT_WIDTH-1:0] adjusted_mantissa_w =
        ({OUT_WIDTH{cond_denorm_zero}} & adjm_denorm_zero) |
        ({OUT_WIDTH{cond_denorm_else}} & adjm_denorm_else) |
        ({OUT_WIDTH{cond_norm}}        & adjm_norm);

    wire signed [EXP_WIDTH:0] biased_exp_w =
        ({(EXP_WIDTH+1){cond_denorm}} & $signed({(EXP_WIDTH+1){1'b0}})) |
        ({(EXP_WIDTH+1){cond_norm}}   & exponent);


    always @(*) begin
        mantissa          = mantissa_w;         
        minimum_exp       = minimum_exp_w;      
        adjusted_mantissa = adjusted_mantissa_w;
        biased_exp        = biased_exp_w;       
    end

endmodule
