`timescale 1ns/1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C1_FPMutiArray (
    input  [2:0]   i_Compute_Precision,
    input          FMOP_FP16_Non_Widening,
    input  [31:0]  i_Operand_A,
    input  [31:0]  i_Operand_B,
    output [191:0] o_Mant
);

    // FP32
    wire [7:0] exp32A = i_Operand_A[30:23];
    wire [7:0] exp32B = i_Operand_B[30:23];
    wire       hid32A = (|exp32A) & (~&exp32A);
    wire       hid32B = (|exp32B) & (~&exp32B);
    wire [23:0] frac32A = {hid32A, i_Operand_A[22:0]};
    wire [23:0] frac32B = {hid32B, i_Operand_B[22:0]};

    // FP16 (2 lanes: low16, high16)
    wire [4:0] exp16A0 = i_Operand_A[14:10];
    wire [4:0] exp16A1 = i_Operand_A[30:26];
    wire [4:0] exp16B0 = i_Operand_B[14:10];
    wire [4:0] exp16B1 = i_Operand_B[30:26];

    wire       hid16A0 = (|exp16A0) & (~&exp16A0);
    wire       hid16A1 = (|exp16A1) & (~&exp16A1);
    wire       hid16B0 = (|exp16B0) & (~&exp16B0);
    wire       hid16B1 = (|exp16B1) & (~&exp16B1);

    wire [10:0] frac16A0 = {hid16A0, i_Operand_A[ 9: 0]};
    wire [10:0] frac16A1 = {hid16A1, i_Operand_A[25:16]};
    wire [10:0] frac16B0 = {hid16B0, i_Operand_B[ 9: 0]};
    wire [10:0] frac16B1 = {hid16B1, i_Operand_B[25:16]};

    // BF16 (2 lanes: low16, high16)
    wire [7:0] expbfA0 = i_Operand_A[14:7];
    wire [7:0] expbfA1 = i_Operand_A[30:23];
    wire [7:0] expbfB0 = i_Operand_B[14:7];
    wire [7:0] expbfB1 = i_Operand_B[30:23];

    wire       hidbfA0 = (|expbfA0) & (~&expbfA0);
    wire       hidbfA1 = (|expbfA1) & (~&expbfA1);
    wire       hidbfB0 = (|expbfB0) & (~&expbfB0);
    wire       hidbfB1 = (|expbfB1) & (~&expbfB1);

    wire [7:0] fracbfA0 = {hidbfA0, i_Operand_A[ 6: 0]};
    wire [7:0] fracbfA1 = {hidbfA1, i_Operand_A[22:16]};
    wire [7:0] fracbfB0 = {hidbfB0, i_Operand_B[ 6: 0]};
    wire [7:0] fracbfB1 = {hidbfB1, i_Operand_B[22:16]};

    // FP32：mantissa
    wire [31:0] packA_fp32 = {8'd0, frac32A};
    wire [31:0] packB_fp32 = {8'd0, frac32B};

    wire [31:0] packA_fp16 = {5'd0, frac16A1, 5'd0, frac16A0};
    wire [31:0] packB_fp16 = {5'd0, frac16B1, 5'd0, frac16B0};

    wire [31:0] packA_bf16 = {8'd0, fracbfA1, 8'd0, fracbfA0};
    wire [31:0] packB_bf16 = {8'd0, fracbfB1, 8'd0, fracbfB0};

    wire [31:0] packA_fp8  = i_Operand_A;
    wire [31:0] packB_fp8  = i_Operand_B;

    wire sel_fp32   = (i_Compute_Precision == `FP32);
    wire sel_fp16   = (i_Compute_Precision == `FP16) & (~FMOP_FP16_Non_Widening);
    wire sel_fp16_4 = (i_Compute_Precision == `FP16) & ( FMOP_FP16_Non_Widening);
    wire sel_bf16   = (i_Compute_Precision == `BF16);
    wire sel_fp8    = (i_Compute_Precision == `FP8);

    wire [2:0] fp_mode =
          ({3{sel_fp32   }} & `FP32  )
        | ({3{sel_fp16   }} & `FP16  )
        | ({3{sel_fp16_4 }} & `FP16_4)
        | ({3{sel_bf16   }} & `BF16  )
        | ({3{sel_fp8    }} & `FP8   );

    wire [31:0] fp_iA =
          ({32{sel_fp32   }} & packA_fp32)
        | ({32{sel_fp16   }} & packA_fp16)
        | ({32{sel_fp16_4 }} & packA_fp16)
        | ({32{sel_bf16   }} & packA_bf16)
        | ({32{sel_fp8    }} & packA_fp8 );

    wire [31:0] fp_iB =
          ({32{sel_fp32   }} & packB_fp32)
        | ({32{sel_fp16   }} & packB_fp16)
        | ({32{sel_fp16_4 }} & packB_fp16)
        | ({32{sel_bf16   }} & packB_bf16)
        | ({32{sel_fp8    }} & packB_fp8 );

    wire [127:0] fp_oP;
    Booth_fp_core u_fp_core (
        .mode (fp_mode),
        .i_A  (fp_iA),
        .i_B  (fp_iB),
        .o_P  (fp_oP)
    );

    
    wire [31:0] w0 = fp_oP[ 31:  0];
    wire [31:0] w1 = fp_oP[ 63: 32];
    wire [31:0] w2 = fp_oP[ 95: 64];
    wire [31:0] w3 = fp_oP[127: 96];

    wire [23:0] p0_24 = w0[23:0];
    wire [23:0] p1_24 = w1[23:0];
    wire [23:0] p2_24 = w2[23:0];
    wire [23:0] p3_24 = w3[23:0];

    
    wire [47:0] fp32_prod48 = fp_oP[47:0];

    wire [47:0] fp16_m00 = {24'd0, p0_24};
    wire [47:0] fp16_m01 = 48'd0;
    wire [47:0] fp16_m10 = 48'd0;
    wire [47:0] fp16_m11 = {24'd0, p1_24};

    wire [47:0] fp164_m00 = {24'd0, p0_24};
    wire [47:0] fp164_m01 = {24'd0, p1_24};
    wire [47:0] fp164_m10 = {24'd0, p2_24};
    wire [47:0] fp164_m11 = {24'd0, p3_24};

    wire [15:0] bf16_r0 = p0_24[15:0];
    wire [15:0] bf16_r1 = p1_24[15:0];
    wire [47:0] bf16_m00 = {bf16_r0, 32'd0};
    wire [47:0] bf16_m01 = 48'd0;
    wire [47:0] bf16_m10 = 48'd0;
    wire [47:0] bf16_m11 = {bf16_r1, 32'd0};

    wire [47:0] fp8_m00 = {38'd0, w0[9:0]};
    wire [47:0] fp8_m01 = {38'd0, w1[9:0]};
    wire [47:0] fp8_m10 = {38'd0, w2[9:0]};
    wire [47:0] fp8_m11 = {38'd0, w3[9:0]};

    wire [47:0] T_Mant00 =
          ({48{sel_fp32   }} & fp32_prod48)
        | ({48{sel_fp16   }} & fp16_m00   )
        | ({48{sel_fp16_4 }} & fp164_m00  )
        | ({48{sel_bf16   }} & bf16_m00   )
        | ({48{sel_fp8    }} & fp8_m00    );

    wire [47:0] T_Mant01 =
          ({48{sel_fp32   }} & fp32_prod48)
        | ({48{sel_fp16   }} & fp16_m01   )
        | ({48{sel_fp16_4 }} & fp164_m01  )
        | ({48{sel_bf16   }} & bf16_m01   )
        | ({48{sel_fp8    }} & fp8_m01    );

    wire [47:0] T_Mant10 =
          ({48{sel_fp32   }} & fp32_prod48)
        | ({48{sel_fp16   }} & fp16_m10   )
        | ({48{sel_fp16_4 }} & fp164_m10  )
        | ({48{sel_bf16   }} & bf16_m10   )
        | ({48{sel_fp8    }} & fp8_m10    );

    wire [47:0] T_Mant11 =
          ({48{sel_fp32   }} & fp32_prod48)
        | ({48{sel_fp16   }} & fp16_m11   )
        | ({48{sel_fp16_4 }} & fp164_m11  )
        | ({48{sel_bf16   }} & bf16_m11   )
        | ({48{sel_fp8    }} & fp8_m11    );

    assign o_Mant = {T_Mant11, T_Mant10, T_Mant01, T_Mant00};

endmodule
