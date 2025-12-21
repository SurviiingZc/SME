module C1_Mult_ALL (
    // ---------- shared operands ----------
    input  [31:0]  i_operand1,              // = i_Operand_A
    input  [31:0]  i_operand2,              // = i_Operand_B

    // ---------- int controls ----------
    input          i_ZmIsSigned,
    input          i_ZnIsSigned,
    input  [3:0]   i_Active_Element_A,
    input  [3:0]   i_Active_Element_B,

    // ---------- fp controls ----------
    input          FMOP_FP16_Non_Widening,

    // ---------- unified mode ----------
    input  [2:0]   i_Mode,                  // covers FP32/FP16/BF16/FP8/INT8/INT16

    output [31:0]  o_AddZA,
    output [63:0]  o_Product,
    output [191:0] o_Mant
);

    wire mode_in_fp16  = (i_Mode == `FP16);

    // wire [2:0] mode_eff = (mode_in_fp16 & FMOP_FP16_Non_Widening) ? `FP16_4 : i_Mode;
    wire [2:0] mode_eff = (mode_in_fp16) ? `FP16_4 : i_Mode;

    wire is_int8  = (mode_eff == `INT8);
    wire is_int16 = (mode_eff == `INT16);
    wire is_int   = is_int8 | is_int16;

    wire is_fp32  = (mode_eff == `FP32);
    wire is_fp16  = (mode_eff == `FP16);
    wire is_fp164 = (mode_eff == `FP16_4);
    wire is_bf16  = (mode_eff == `BF16);
    wire is_fp8   = (mode_eff == `FP8);
    wire is_fp    = is_fp32 | is_fp16 | is_fp164 | is_bf16 | is_fp8;

    assign o_AddZA = is_int ? (i_Active_Element_A[0] ? 32'd0 : i_operand1) : 32'd0;

    wire [31:0] operand1_int8 = i_operand1 & {
        {8{i_Active_Element_A[3]}},
        {8{i_Active_Element_A[2]}},
        {8{i_Active_Element_A[1]}},
        {8{i_Active_Element_A[0]}}
    };

    wire [31:0] operand2_int8 = i_operand2 & {
        {8{i_Active_Element_B[3]}},
        {8{i_Active_Element_B[2]}},
        {8{i_Active_Element_B[1]}},
        {8{i_Active_Element_B[0]}}
    };

    wire [31:0] operand1_int16 = i_operand1 & {
        {16{i_Active_Element_A[2]}},
        {16{i_Active_Element_A[0]}}
    };

    wire [31:0] operand2_int16 = i_operand2 & {
        {16{i_Active_Element_B[2]}},
        {16{i_Active_Element_B[0]}}
    };

    wire [31:0] int_iA = is_int16 ? operand1_int16 : operand1_int8;
    wire [31:0] int_iB = is_int16 ? operand2_int16 : operand2_int8;

    wire [7:0]  exp32A  = i_operand1[30:23];
    wire [7:0]  exp32B  = i_operand2[30:23];
    wire        hid32A  = (|exp32A) & (~&exp32A);
    wire        hid32B  = (|exp32B) & (~&exp32B);
    wire [23:0] frac32A = {hid32A, i_operand1[22:0]};
    wire [23:0] frac32B = {hid32B, i_operand2[22:0]};

    wire [4:0]  exp16A0 = i_operand1[14:10];
    wire [4:0]  exp16A1 = i_operand1[30:26];
    wire [4:0]  exp16B0 = i_operand2[14:10];
    wire [4:0]  exp16B1 = i_operand2[30:26];

    wire        hid16A0 = (|exp16A0) & (~&exp16A0);
    wire        hid16A1 = (|exp16A1) & (~&exp16A1);
    wire        hid16B0 = (|exp16B0) & (~&exp16B0);
    wire        hid16B1 = (|exp16B1) & (~&exp16B1);

    wire [10:0] frac16A0 = {hid16A0, i_operand1[ 9: 0]};
    wire [10:0] frac16A1 = {hid16A1, i_operand1[25:16]};
    wire [10:0] frac16B0 = {hid16B0, i_operand2[ 9: 0]};
    wire [10:0] frac16B1 = {hid16B1, i_operand2[25:16]};

    wire [7:0]  expbfA0 = i_operand1[14:7];
    wire [7:0]  expbfA1 = i_operand1[30:23];
    wire [7:0]  expbfB0 = i_operand2[14:7];
    wire [7:0]  expbfB1 = i_operand2[30:23];

    wire        hidbfA0 = (|expbfA0) & (~&expbfA0);
    wire        hidbfA1 = (|expbfA1) & (~&expbfA1);
    wire        hidbfB0 = (|expbfB0) & (~&expbfB0);
    wire        hidbfB1 = (|expbfB1) & (~&expbfB1);

    wire [7:0]  fracbfA0 = {hidbfA0, i_operand1[ 6: 0]};
    wire [7:0]  fracbfA1 = {hidbfA1, i_operand1[22:16]};
    wire [7:0]  fracbfB0 = {hidbfB0, i_operand2[ 6: 0]};
    wire [7:0]  fracbfB1 = {hidbfB1, i_operand2[22:16]};

    wire [31:0] packA_fp32 = {8'd0, frac32A};
    wire [31:0] packB_fp32 = {8'd0, frac32B};

    wire [31:0] packA_fp16 = {5'd0, frac16A1, 5'd0, frac16A0};
    wire [31:0] packB_fp16 = {5'd0, frac16B1, 5'd0, frac16B0};

    wire [31:0] packA_bf16 = {8'd0, fracbfA1, 8'd0, fracbfA0};
    wire [31:0] packB_bf16 = {8'd0, fracbfB1, 8'd0, fracbfB0};

    wire [31:0] packA_fp8  = i_operand1;
    wire [31:0] packB_fp8  = i_operand2;
    wire [31:0] fp_iA =
          ({32{is_fp32 }} & packA_fp32)
        | ({32{is_fp16 }} & packA_fp16)
        | ({32{is_fp164}} & packA_fp16)
        | ({32{is_bf16 }} & packA_bf16)
        | ({32{is_fp8  }} & packA_fp8 );

    wire [31:0] fp_iB =
          ({32{is_fp32 }} & packB_fp32)
        | ({32{is_fp16 }} & packB_fp16)
        | ({32{is_fp164}} & packB_fp16)
        | ({32{is_bf16 }} & packB_bf16)
        | ({32{is_fp8  }} & packB_fp8 );

    wire [31:0] core_iA = ({32{is_fp }} & fp_iA) | ({32{is_int}} & int_iA);
    wire [31:0] core_iB = ({32{is_fp }} & fp_iB) | ({32{is_int}} & int_iB);

    wire core_signedA = is_int ? i_ZmIsSigned : 1'b0;
    wire core_signedB = is_int ? i_ZnIsSigned : 1'b0;

    wire [127:0] core_oP;

    C1_Booth_ALL u_mul_core (
        .mode      ( mode_eff     ),
        .i_SignedA ( core_signedA ),
        .i_SignedB ( core_signedB ),
        .i_A       ( core_iA      ),
        .i_B       ( core_iB      ),
        .o_P       ( core_oP      )
    );

    assign o_Product = is_int ? core_oP[63:0] : 64'd0;

    wire [31:0] w0 = core_oP[ 31:  0];
    wire [31:0] w1 = core_oP[ 63: 32];
    wire [31:0] w2 = core_oP[ 95: 64];
    wire [31:0] w3 = core_oP[127: 96];

    wire [23:0] p0_24 = w0[23:0];
    wire [23:0] p1_24 = w1[23:0];
    wire [23:0] p2_24 = w2[23:0];
    wire [23:0] p3_24 = w3[23:0];

    wire [47:0] fp32_prod48 = core_oP[47:0];

    wire [47:0] fp16_m00  = {24'd0, p0_24};
    wire [47:0] fp16_m01  = 48'd0;
    wire [47:0] fp16_m10  = 48'd0;
    wire [47:0] fp16_m11  = {24'd0, p1_24};

    wire [47:0] fp164_m00 = {24'd0, p0_24};
    wire [47:0] fp164_m01 = {24'd0, p1_24};
    wire [47:0] fp164_m10 = {24'd0, p2_24};
    wire [47:0] fp164_m11 = {24'd0, p3_24};

    wire [15:0] bf16_r0   = p0_24[15:0];
    wire [15:0] bf16_r1   = p1_24[15:0];
    wire [47:0] bf16_m00  = {bf16_r0, 32'd0};
    wire [47:0] bf16_m01  = 48'd0;
    wire [47:0] bf16_m10  = 48'd0;
    wire [47:0] bf16_m11  = {bf16_r1, 32'd0};

    wire [47:0] fp8_m00   = {38'd0, w0[9:0]};
    wire [47:0] fp8_m01   = {38'd0, w1[9:0]};
    wire [47:0] fp8_m10   = {38'd0, w2[9:0]};
    wire [47:0] fp8_m11   = {38'd0, w3[9:0]};

    wire [47:0] T_Mant00 =
          ({48{is_fp32 }} & fp32_prod48)
        | ({48{is_fp16 }} & fp16_m00   )
        | ({48{is_fp164}} & fp164_m00  )
        | ({48{is_bf16 }} & bf16_m00   )
        | ({48{is_fp8  }} & fp8_m00    );

    wire [47:0] T_Mant01 =
          ({48{is_fp32 }} & fp32_prod48)
        | ({48{is_fp16 }} & fp16_m01   )
        | ({48{is_fp164}} & fp164_m01  )
        | ({48{is_bf16 }} & bf16_m01   )
        | ({48{is_fp8  }} & fp8_m01    );

    wire [47:0] T_Mant10 =
          ({48{is_fp32 }} & fp32_prod48)
        | ({48{is_fp16 }} & fp16_m10   )
        | ({48{is_fp164}} & fp164_m10  )
        | ({48{is_bf16 }} & bf16_m10   )
        | ({48{is_fp8  }} & fp8_m10    );

    wire [47:0] T_Mant11 =
          ({48{is_fp32 }} & fp32_prod48)
        | ({48{is_fp16 }} & fp16_m11   )
        | ({48{is_fp164}} & fp164_m11  )
        | ({48{is_bf16 }} & bf16_m11   )
        | ({48{is_fp8  }} & fp8_m11    );

    assign o_Mant = is_fp ? {T_Mant11, T_Mant10, T_Mant01, T_Mant00} : 192'd0;

endmodule
