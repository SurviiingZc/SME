/*
Verision: 20250809

*/
module C2_NormalizeReal #(
    parameter IN_WIDTH  = 48,  
    parameter OUT_WIDTH = 48, 
    parameter EXP_WIDTH = 9
)(
    input                                       i_sign                         ,
    input               [EXP_WIDTH-1:0]         i_exp                          ,
    input  wire         [IN_WIDTH-1:0]          i_mantissa_in                    ,
    input               [1:0]                   i_Data_Width                   , 
    input                                       i_is_Multiplier                ,     
    output                                      o_sign                         ,
    output reg  signed [EXP_WIDTH:0]            biased_exp                     ,
    output      signed [EXP_WIDTH:0]            biased_exp_unconstrained       ,
    output      signed [EXP_WIDTH:0]            i_exp_true                     ,
    output      signed [EXP_WIDTH:0]            exponent                       ,
    output reg         [OUT_WIDTH-1:0]          adjusted_mantissa              ,
    output reg  signed [EXP_WIDTH:0]            minimum_exp                    ,
    output reg                                  sticky_flag                    ,
    output reg         [OUT_WIDTH-1:0]          mantissa 
);


reg         [5:0]                  shift_amt                   ;
reg         [5:0]                  adj_exp                     ;
wire signed [5:0]                  lzc_shift_amt               ;
reg  signed [EXP_WIDTH:0]          exponent_adj                ;

wire                               is_denormal                 ;

wire signed [EXP_WIDTH:0] i_exp_temp = {{1'b0},i_exp};

assign exponent                     = i_exp_temp + exponent_adj + minimum_exp - 1'd1     ;
assign i_exp_true                   = i_exp_temp + minimum_exp - 1'd1                             ;
assign biased_exp_unconstrained     = exponent - minimum_exp - 1'd1                                            ;
assign is_denormal                  = (exponent <= 0)? 1'b1 : 1'b0                                             ;
assign o_sign                       = i_sign                                                                            ;

always @(*) begin
    case (i_Data_Width)
        2'b00: begin
            adj_exp        = 26      ;
            minimum_exp    = -14     ;
        end
        2'b01: begin
            adj_exp        = 0       ;
            minimum_exp    = -126    ;
        end
        2'b10: begin
            adj_exp        = 32      ;
            minimum_exp    = -126    ;
        end
        default: begin
            adj_exp        = 0       ;
            minimum_exp    = -126    ;
        end
        
    endcase
end

always @(*) begin
    shift_amt = 0;
    exponent_adj = 0;
    mantissa = 0;

    if (!(|i_mantissa_in)) begin
        shift_amt     = 0;
        exponent_adj  = 0;
        mantissa = 0;
    end
    else if(lzc_shift_amt == 6'd0)begin
        shift_amt     = 6'd1;
        //mantissa      = i_mantissa_in >> shift_amt;
        mantissa      = i_mantissa_in;
        exponent_adj  = 1;
    end
    else begin
        shift_amt     = lzc_shift_amt;
        mantissa = i_mantissa_in << shift_amt;
        exponent_adj  = -shift_amt + adj_exp +1;
    end   
end

reg     [9:0]   shift_adj;
reg    [47:0]   mask_out_bits;

reg    [47:0]   shifted_out_bits    ;
// reg             sticky_flag ;               //后续写为输出信号

always @(*) begin
    if(is_denormal) begin
        case (i_Data_Width)
        2'b00: begin
            adjusted_mantissa          = ({i_mantissa_in[21:0],26'b0} >> (-(i_exp_true)))  ;
            biased_exp                 = 0                                                          ;
            shift_adj                  = (-(i_exp_true))                                   ;
            mask_out_bits              = (48'd1 << shift_adj) - 1                                   ;
            shifted_out_bits           = ({i_mantissa_in[21:0],26'b0} & mask_out_bits)              ;
            sticky_flag                = |shifted_out_bits                                          ;
        end
        2'b01: begin
            adjusted_mantissa          = (i_mantissa_in >> (-(i_exp_true)))                         ;
            biased_exp                 = 0                                                          ;
            shift_adj                  = -i_exp_true                                                ;
            mask_out_bits              = (48'd1 << shift_adj) - 1                                   ;
            shifted_out_bits           = (i_mantissa_in & mask_out_bits)                            ;
            sticky_flag                = |shifted_out_bits                                          ;
        end
        2'b10: begin
            adjusted_mantissa          = ({i_mantissa_in[15:0],32'b0} >> (-i_exp_true))             ;
            biased_exp                 = 0                                                          ;
            shift_adj                  = -i_exp_true                                                ;
            mask_out_bits              = (48'd1 << shift_adj) - 1                                   ;
            shifted_out_bits           = ({i_mantissa_in[15:0],32'b0} & mask_out_bits)              ;
            sticky_flag                = |shifted_out_bits                                          ;
        end
        default: begin
            adjusted_mantissa          = (i_mantissa_in >> (-i_exp_true))                           ;
            biased_exp                 = 0                                                          ;
            shift_adj                  = -i_exp_true                                                ;
            mask_out_bits              = (48'd1 << shift_adj) - 1                                   ;
            shifted_out_bits           = (i_mantissa_in & mask_out_bits)                            ;
            sticky_flag                = |shifted_out_bits                                          ;
        end  
    endcase
    end
    else begin
        adjusted_mantissa               = mantissa                      ;
        //biased_exp                      = (i_is_Multiplier == 1) ? exponent : biased_exp_unconstrained     ; //乘法选用第一个 加法用第二个
        biased_exp                      = exponent                      ;
        shift_adj                       = 9'd0                          ;
        mask_out_bits                   = (48'd1 << shift_adj) - 1      ;
        shifted_out_bits                = 48'd0                         ;
        sticky_flag                     = 1'b0                                          ;
    end
end


// always @(*) begin
//     if(is_denormal) begin
//         if(i_exp_true == 0) begin
//             adjusted_mantissa           = (i_mantissa_in)  ;
//             biased_exp                  = 0                   ;
//         end
//         else begin
//             adjusted_mantissa          = (i_mantissa_in >> (-1*i_exp_true));
//             biased_exp                 = 0                                   ;
//         end
//     end
//     else begin
//         adjusted_mantissa               = mantissa                      ;
//         biased_exp                      = exponent                      ;
//         //biased_exp                      = (i_is_Multiplier == 1) ? exponent : biased_exp_unconstrained     ; //乘法选用第一个 加法用第二个
//     end
// end

C2_LZC_round #(
    .WIDTH(IN_WIDTH)
) lzc_inst (
    .in     (i_mantissa_in    ),
    .o_count  (lzc_shift_amt  )
);


endmodule
