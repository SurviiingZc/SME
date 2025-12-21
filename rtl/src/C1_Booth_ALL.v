module C1_Booth_ALL (
    input       [2:0]   mode,
    input               i_SignedA,
    input               i_SignedB,
    input       [31:0]  i_A,
    input       [31:0]  i_B,
    output reg  [127:0] o_P
);

    wire mode_is_fp32   = (mode == `FP32);
    wire mode_is_fp16   = (mode == `FP16);
    wire mode_is_bf16   = (mode == `BF16);
    wire mode_is_fp16_4 = (mode == `FP16_4);
    wire mode_is_fp8    = (mode == `FP8);

    wire mode_is_int8   = (mode == `INT8);
    wire mode_is_int16  = (mode == `INT16);

    wire mode_is_fp = mode_is_fp32 | mode_is_fp16 | mode_is_bf16 | mode_is_fp16_4 | mode_is_fp8;
    wire mode_is_int = mode_is_int8 | mode_is_int16;

    reg [11:0]  u12_0_a, u12_0_b;
    reg [11:0]  u12_1_a, u12_1_b;
    reg [7:0]   u8_0_a,  u8_0_b;
    reg [7:0]   u8_1_a,  u8_1_b;
    reg [3:0]   u4_0_a [0:4], u4_0_b [0:4];
    reg [3:0]   u4_1_a [0:4], u4_1_b [0:4];

    reg [10:0]  a1_m, a2_m, b1_m, b2_m;

    wire s8_0  = i_SignedA & i_A[7];
    wire s8_1  = i_SignedB & i_B[7];
    wire s8_2  = i_SignedA & i_A[23];
    wire s8_3  = i_SignedB & i_B[23];

    wire s16_0 = i_SignedA & i_A[15];
    wire s16_1 = i_SignedA & i_A[31];

    integer k;
    always @(*) begin
        u12_0_a = 12'd0; u12_0_b = 12'd0;
        u12_1_a = 12'd0; u12_1_b = 12'd0;
        u8_0_a  = 8'd0;  u8_0_b  = 8'd0;
        u8_1_a  = 8'd0;  u8_1_b  = 8'd0;

        a1_m    = 11'd0; a2_m    = 11'd0;
        b1_m    = 11'd0; b2_m    = 11'd0;

        for (k=0; k<5; k=k+1) begin
            u4_0_a[k] = 4'd0; u4_0_b[k] = 4'd0;
            u4_1_a[k] = 4'd0; u4_1_b[k] = 4'd0;
        end

        case (mode)
            `FP32: begin
                u12_0_a = i_A[23:12]; u12_0_b = i_B[23:12];
                u12_1_a = i_A[11:0];  u12_1_b = i_B[11:0];

                u8_0_a  = i_A[23:16]; u8_0_b  = i_B[11:4];
                u8_1_a  = i_A[11:4];  u8_1_b  = i_B[23:16];

                u4_0_a[0] = i_A[15:12]; u4_0_b[0] = i_B[3:0];
                u4_0_a[1] = i_A[19:16]; u4_0_b[1] = i_B[3:0];
                u4_0_a[2] = i_A[23:20]; u4_0_b[2] = i_B[3:0];
                u4_0_a[3] = i_A[15:12]; u4_0_b[3] = i_B[7:4];
                u4_0_a[4] = i_A[15:12]; u4_0_b[4] = i_B[11:8];

                u4_1_a[0] = i_A[3:0];   u4_1_b[0] = i_B[15:12];
                u4_1_a[1] = i_A[7:4];   u4_1_b[1] = i_B[15:12];
                u4_1_a[2] = i_A[11:8];  u4_1_b[2] = i_B[15:12];
                u4_1_a[3] = i_A[3:0];   u4_1_b[3] = i_B[19:16];
                u4_1_a[4] = i_A[3:0];   u4_1_b[4] = i_B[23:20];
            end

            `FP16: begin
                u12_0_a = {1'b0, i_A[10:0]};
                u12_0_b = {1'b0, i_B[10:0]};
                u12_1_a = {1'b0, i_A[26:16]};
                u12_1_b = {1'b0, i_B[26:16]};
            end

            `BF16: begin
                u12_0_a = {4'b0, i_A[7:0]};
                u12_0_b = {4'b0, i_B[7:0]};
                u12_1_a = {4'b0, i_A[23:16]};
                u12_1_b = {4'b0, i_B[23:16]};
            end

            `FP16_4: begin
                a1_m = i_A[10:0]; a2_m = i_A[26:16];
                b1_m = i_B[10:0]; b2_m = i_B[26:16];

                u12_0_a = {1'b0, a1_m}; u12_0_b = {1'b0, b1_m};
                u12_1_a = {1'b0, a2_m}; u12_1_b = {1'b0, b2_m};

                u8_0_a  = a1_m[10:3]; u8_0_b = b2_m[10:3];
                u8_1_a  = a2_m[10:3]; u8_1_b = b1_m[10:3];

                u4_0_a[0] = {1'b0, a1_m[2:0]};   u4_0_b[0] = {1'b0, b2_m[2:0]};
                u4_0_a[1] = a1_m[6:3];           u4_0_b[1] = {1'b0, b2_m[2:0]};
                u4_0_a[2] = a1_m[10:7];          u4_0_b[2] = {1'b0, b2_m[2:0]};
                u4_0_a[3] = {1'b0, a1_m[2:0]};   u4_0_b[3] = b2_m[6:3];
                u4_0_a[4] = {1'b0, a1_m[2:0]};   u4_0_b[4] = b2_m[10:7];

                u4_1_a[0] = {1'b0, a2_m[2:0]};   u4_1_b[0] = {1'b0, b1_m[2:0]};
                u4_1_a[1] = a2_m[6:3];           u4_1_b[1] = {1'b0, b1_m[2:0]};
                u4_1_a[2] = a2_m[10:7];          u4_1_b[2] = {1'b0, b1_m[2:0]};
                u4_1_a[3] = {1'b0, a2_m[2:0]};   u4_1_b[3] = b1_m[6:3];
                u4_1_a[4] = {1'b0, a2_m[2:0]};   u4_1_b[4] = b1_m[10:7];
            end

            `FP8: begin
                u4_0_a[0] = i_A[3:0];   u4_0_b[0] = i_B[3:0];
                u4_0_a[1] = i_A[11:8];  u4_0_b[1] = i_B[11:8];
                u4_1_a[0] = i_A[19:16]; u4_1_b[0] = i_B[19:16];
                u4_1_a[1] = i_A[27:24]; u4_1_b[1] = i_B[27:24];
            end

            `INT8: begin
                u12_0_a = {{4{s8_0}}, i_A[7:0]};
                u12_0_b = {{4{s8_1}}, i_B[7:0]};
                u12_1_a = {{4{s8_2}}, i_A[23:16]};
                u12_1_b = {{4{s8_3}}, i_B[23:16]};

                u8_0_a  = i_A[15:8];
                u8_0_b  = i_B[15:8];
                u8_1_a  = i_A[31:24];
                u8_1_b  = i_B[31:24];
            end

            `INT16: begin
                u12_0_a = i_A[11:0];
                u12_0_b = i_B[11:0];
                u12_1_a = i_A[27:16];
                u12_1_b = i_B[27:16];

                u8_0_a  = {{4{s16_0}}, i_A[15:12]};
                u8_0_b  = i_B[15:8];
                u8_1_a  = {{4{s16_1}}, i_A[31:28]};
                u8_1_b  = i_B[31:24];

                u4_0_a[0] = i_A[15:12]; u4_0_b[0] = i_B[3:0];
                u4_0_a[1] = i_A[15:12]; u4_0_b[1] = i_B[7:4];
                u4_0_a[2] = i_A[3:0];   u4_0_b[2] = i_B[15:12];
                u4_0_a[3] = i_A[7:4];   u4_0_b[3] = i_B[15:12];
                u4_0_a[4] = i_A[11:8];  u4_0_b[4] = i_B[15:12];

                u4_1_a[0] = i_A[31:28]; u4_1_b[0] = i_B[19:16];
                u4_1_a[1] = i_A[31:28]; u4_1_b[1] = i_B[23:20];
                u4_1_a[2] = i_A[19:16]; u4_1_b[2] = i_B[31:28];
                u4_1_a[3] = i_A[23:20]; u4_1_b[3] = i_B[31:28];
                u4_1_a[4] = i_A[27:24]; u4_1_b[4] = i_B[31:28];
            end

            default: begin end
        endcase
    end

    wire u12_a_is_uns = mode_is_int8  ? ~i_SignedA :
                        mode_is_int16 ? 1'b1 :
                        1'b1; 

    wire u12_b_is_uns = mode_is_int8  ? ~i_SignedB :
                        mode_is_int16 ? 1'b1 :
                        1'b1;

    wire u8_a_is_uns  = mode_is_int8  ? ~i_SignedA :
                        mode_is_int16 ? ~i_SignedA :
                        1'b1;

    wire u8_b_is_uns  = mode_is_int8  ? ~i_SignedB :
                        mode_is_int16 ? ~i_SignedB :
                        1'b1;

    wire [4:0] u4_a_is_uns = mode_is_int16 ? {3'b111, ~i_SignedA, ~i_SignedA} : 5'b11111;
    wire [4:0] u4_b_is_uns = mode_is_int16 ? {~i_SignedB, ~i_SignedB, ~i_SignedB, 2'b11} : 5'b11111;

    wire [23:0] cmp_u12_0 =
        ((u12_a_is_uns & u12_0_a[11]) ? {u12_0_b, 12'd0} : 24'd0) +
        ((u12_b_is_uns & u12_0_b[11]) ? {u12_0_a, 12'd0} : 24'd0);

    wire [23:0] cmp_u12_1 =
        ((u12_a_is_uns & u12_1_a[11]) ? {u12_1_b, 12'd0} : 24'd0) +
        ((u12_b_is_uns & u12_1_b[11]) ? {u12_1_a, 12'd0} : 24'd0);

    wire [15:0] cmp_u8_0 =
        ((u8_a_is_uns & u8_0_a[7]) ? {u8_0_b, 8'd0} : 16'd0) +
        ((u8_b_is_uns & u8_0_b[7]) ? {u8_0_a, 8'd0} : 16'd0);

    wire [15:0] cmp_u8_1 =
        ((u8_a_is_uns & u8_1_a[7]) ? {u8_1_b, 8'd0} : 16'd0) +
        ((u8_b_is_uns & u8_1_b[7]) ? {u8_1_a, 8'd0} : 16'd0);

    wire [8:0] cmp_u4_0 [0:4];
    wire [8:0] cmp_u4_1 [0:4];
    genvar n;
    generate
        for(n=0; n<5; n=n+1) begin : gen_cmp4
            assign cmp_u4_0[n] =
                ((u4_a_is_uns[n] & u4_0_a[n][3]) ? {u4_0_b[n], 4'd0} : 9'd0) +
                ((u4_b_is_uns[n] & u4_0_b[n][3]) ? {u4_0_a[n], 4'd0} : 9'd0);

            assign cmp_u4_1[n] =
                ((u4_a_is_uns[n] & u4_1_a[n][3]) ? {u4_1_b[n], 4'd0} : 9'd0) +
                ((u4_b_is_uns[n] & u4_1_b[n][3]) ? {u4_1_a[n], 4'd0} : 9'd0);
        end
    endgenerate

    wire [23:0] u12_0_s, u12_0_c, u12_1_s, u12_1_c;
    wire [23:0] u12_0_s_vec, u12_0_c_vec, u12_1_s_vec, u12_1_c_vec;

    Booth_12x12 i_u12_0 (.i_a(u12_0_a), .i_b(u12_0_b), .o_sum(u12_0_s), .o_carry(u12_0_c));
    Booth_12x12 i_u12_1 (.i_a(u12_1_a), .i_b(u12_1_b), .o_sum(u12_1_s), .o_carry(u12_1_c));

    Compress_3to2 #(24) csa_u12_0 (.in_a(u12_0_s), .in_b(u12_0_c), .in_c(cmp_u12_0), .out_sum(u12_0_s_vec), .out_carry(u12_0_c_vec));
    Compress_3to2 #(24) csa_u12_1 (.in_a(u12_1_s), .in_b(u12_1_c), .in_c(cmp_u12_1), .out_sum(u12_1_s_vec), .out_carry(u12_1_c_vec));

    wire [15:0] u8_0_s, u8_0_c, u8_1_s, u8_1_c;
    wire [15:0] u8_0_s_vec, u8_0_c_vec, u8_1_s_vec, u8_1_c_vec;

    Booth_8x8 i_u8_0 (.i_a(u8_0_a), .i_b(u8_0_b), .o_sum(u8_0_s), .o_carry(u8_0_c));
    Booth_8x8 i_u8_1 (.i_a(u8_1_a), .i_b(u8_1_b), .o_sum(u8_1_s), .o_carry(u8_1_c));

    Compress_3to2 #(16) csa_u8_0 (.in_a(u8_0_s), .in_b(u8_0_c), .in_c(cmp_u8_0), .out_sum(u8_0_s_vec), .out_carry(u8_0_c_vec));
    Compress_3to2 #(16) csa_u8_1 (.in_a(u8_1_s), .in_b(u8_1_c), .in_c(cmp_u8_1), .out_sum(u8_1_s_vec), .out_carry(u8_1_c_vec));

    wire [8:0] u4_0_p [0:4];
    wire [8:0] u4_1_p [0:4];
    genvar i;
    generate
        for(i=0; i<5; i=i+1) begin : gen_u4
            Booth_4x4 u0 (.i_a(u4_0_a[i]), .i_b(u4_0_b[i]), .o_p(u4_0_p[i]));
            Booth_4x4 u1 (.i_a(u4_1_a[i]), .i_b(u4_1_b[i]), .o_p(u4_1_p[i]));
        end
    endgenerate

    wire [9:0]  w_mix_0_10b  [0:4];
    wire [9:0]  w_mix_1_10b  [0:4];
    wire [47:0] w_mix_0_long [0:4];
    wire [47:0] w_mix_1_long [0:4];

    genvar m;
    generate
        for(m=0; m<5; m=m+1) begin : gen_mix
            wire [9:0] raw0 = u4_0_p[m] + cmp_u4_0[m];
            wire [9:0] raw1 = u4_1_p[m] + cmp_u4_1[m];
            assign w_mix_0_10b[m] = raw0;
            assign w_mix_1_10b[m] = raw1;

            wire [7:0] t0 = raw0[7:0];
            wire [7:0] t1 = raw1[7:0];

            wire ext0 = ~(u4_a_is_uns[m] & u4_b_is_uns[m]);
            wire ext1 = ~(u4_a_is_uns[m] & u4_b_is_uns[m]);

            assign w_mix_0_long[m] = ext0 ? {{40{t0[7]}}, t0} : {40'd0, t0};
            assign w_mix_1_long[m] = ext1 ? {{40{t1[7]}}, t1} : {40'd0, t1};
        end
    endgenerate

    wire [47:0] t_mix0_0_48 = {w_mix_0_long[0][35:0], 12'd0};
    wire [47:0] t_mix1_0_48 = {w_mix_1_long[0][35:0], 12'd0};

    wire [47:0] t_mix0_1_48 = {w_mix_0_long[1][31:0], 16'd0};
    wire [47:0] t_mix1_1_48 = {w_mix_1_long[1][31:0], 16'd0};

    wire [47:0] t_mix0_2_48_i16 = {w_mix_0_long[2][35:0], 12'd0};
    wire [47:0] t_mix1_2_48_i16 = {w_mix_1_long[2][35:0], 12'd0};
    wire [47:0] t_mix0_2_48_fp  = {w_mix_0_long[2][27:0], 20'd0};
    wire [47:0] t_mix1_2_48_fp  = {w_mix_1_long[2][27:0], 20'd0};

    wire [47:0] t_mix0_2_48 = mode_is_int16 ? t_mix0_2_48_i16 : t_mix0_2_48_fp;
    wire [47:0] t_mix1_2_48 = mode_is_int16 ? t_mix1_2_48_i16 : t_mix1_2_48_fp;

    wire [47:0] t_mix0_3_48 = {w_mix_0_long[3][31:0], 16'd0};
    wire [47:0] t_mix1_3_48 = {w_mix_1_long[3][31:0], 16'd0};

    wire [47:0] t_mix0_4_48 = {w_mix_0_long[4][27:0], 20'd0};
    wire [47:0] t_mix1_4_48 = {w_mix_1_long[4][27:0], 20'd0};

    wire [47:0] mix0_s0_48, mix0_c0_48, mix0_s1_48, mix0_c1_48, mix0_final_s_48, mix0_final_c_48;
    Compress_3to2 #(48) mix0_csa0 (.in_a(t_mix0_0_48), .in_b(t_mix0_1_48), .in_c(t_mix0_2_48), .out_sum(mix0_s0_48), .out_carry(mix0_c0_48));
    Compress_3to2 #(48) mix0_csa1 (.in_a(mix0_s0_48), .in_b({mix0_c0_48[46:0],1'b0}), .in_c(t_mix0_3_48), .out_sum(mix0_s1_48), .out_carry(mix0_c1_48));
    Compress_3to2 #(48) mix0_csa2 (.in_a(mix0_s1_48), .in_b({mix0_c1_48[46:0],1'b0}), .in_c(t_mix0_4_48), .out_sum(mix0_final_s_48), .out_carry(mix0_final_c_48));

    wire [47:0] mix1_s0_48, mix1_c0_48, mix1_s1_48, mix1_c1_48, mix1_final_s_48, mix1_final_c_48;
    Compress_3to2 #(48) mix1_csa0 (.in_a(t_mix1_0_48), .in_b(t_mix1_1_48), .in_c(t_mix1_2_48), .out_sum(mix1_s0_48), .out_carry(mix1_c0_48));
    Compress_3to2 #(48) mix1_csa1 (.in_a(mix1_s0_48), .in_b({mix1_c0_48[46:0],1'b0}), .in_c(t_mix1_3_48), .out_sum(mix1_s1_48), .out_carry(mix1_c1_48));
    Compress_3to2 #(48) mix1_csa2 (.in_a(mix1_s1_48), .in_b({mix1_c1_48[46:0],1'b0}), .in_c(t_mix1_4_48), .out_sum(mix1_final_s_48), .out_carry(mix1_final_c_48));

    wire [15:0] u8_0_res_fast, u8_1_res_fast;
    CSLA #(.W(16), .BLK(4)) u_u8_0_add ( .a(u8_0_s_vec), .b({u8_0_c_vec[14:0],1'b0}), .sum(u8_0_res_fast), .co() );
    CSLA #(.W(16), .BLK(4)) u_u8_1_add ( .a(u8_1_s_vec), .b({u8_1_c_vec[14:0],1'b0}), .sum(u8_1_res_fast), .co() );

    wire [23:0] u12_0_simple, u12_1_simple;
    CSLA #(.W(24), .BLK(4)) u_u12_0_add ( .a(u12_0_s_vec), .b({u12_0_c_vec[22:0],1'b0}), .sum(u12_0_simple), .co() );
    CSLA #(.W(24), .BLK(4)) u_u12_1_add ( .a(u12_1_s_vec), .b({u12_1_c_vec[22:0],1'b0}), .sum(u12_1_simple), .co() );

    wire [23:0] mix0_t0 = (u8_0_res_fast << 6);
    wire [23:0] mix0_t1 = ({16'd0, w_mix_0_10b[0][7:0]} << 0);
    wire [23:0] mix0_t2 = ({16'd0, w_mix_0_10b[1][7:0]} << 3);
    wire [23:0] mix0_t3 = ({16'd0, w_mix_0_10b[2][7:0]} << 7);
    wire [23:0] mix0_t4 = ({16'd0, w_mix_0_10b[3][7:0]} << 3);
    wire [23:0] mix0_t5 = ({16'd0, w_mix_0_10b[4][7:0]} << 7);

    wire [23:0] p_fp16_4_mix0 = ((mix0_t0 + mix0_t1) + (mix0_t2 + mix0_t3)) + (mix0_t4 + mix0_t5);

    wire [23:0] mix1_t0 = (u8_1_res_fast << 6);
    wire [23:0] mix1_t1 = ({16'd0, w_mix_1_10b[0][7:0]} << 0);
    wire [23:0] mix1_t2 = ({16'd0, w_mix_1_10b[1][7:0]} << 3);
    wire [23:0] mix1_t3 = ({16'd0, w_mix_1_10b[2][7:0]} << 7);
    wire [23:0] mix1_t4 = ({16'd0, w_mix_1_10b[3][7:0]} << 3);
    wire [23:0] mix1_t5 = ({16'd0, w_mix_1_10b[4][7:0]} << 7);

    wire [23:0] p_fp16_4_mix1 = ((mix1_t0 + mix1_t1) + (mix1_t2 + mix1_t3)) + (mix1_t4 + mix1_t5);

    wire [47:0] val_u8_0_s   = {12'd0, u8_0_res_fast, 20'd0};
    wire [47:0] val_u8_1_s   = {12'd0, u8_1_res_fast, 20'd0};
    wire [47:0] val_u12_0_s  = {u12_0_s_vec, 24'd0};
    wire [47:0] val_u12_0_c  = {u12_0_c_vec[22:0], 1'b0, 24'd0};
    wire [47:0] val_u12_1_tr = {24'd0, u12_1_simple};

    wire [47:0] mix1_total_48;
    wire        mix1_co_unused;
    Ks48add u_mix1_add (
        .a   (mix1_final_s_48),
        .b   ({mix1_final_c_48[46:0],1'b0}),
        .sum (mix1_total_48),
        .co  (mix1_co_unused)
    );

    wire [47:0] op0 = val_u12_0_s;
    wire [47:0] op1 = val_u12_0_c;
    wire [47:0] op2 = val_u12_1_tr;
    wire [47:0] op3 = val_u8_0_s;
    wire [47:0] op4 = val_u8_1_s;
    wire [47:0] op5 = mix0_final_s_48;
    wire [47:0] op6 = {mix0_final_c_48[46:0],1'b0};
    wire [47:0] op7 = mix1_total_48;

    wire [47:0] s1,c1,s2,c2,s3,c3;
    Compress_3to2 #(48) csa1 (.in_a(op0), .in_b(op1), .in_c(op2), .out_sum(s1), .out_carry(c1));
    Compress_3to2 #(48) csa2 (.in_a(op3), .in_b(op4), .in_c(op5), .out_sum(s2), .out_carry(c2));
    Compress_3to2 #(48) csa3 (.in_a(op6), .in_b(op7), .in_c(48'd0), .out_sum(s3), .out_carry(c3));

    wire [47:0] s4,c4,s5,c5;
    Compress_3to2 #(48) csa4 (.in_a(s1), .in_b({c1[46:0],1'b0}), .in_c(s2), .out_sum(s4), .out_carry(c4));
    Compress_3to2 #(48) csa5 (.in_a({c2[46:0],1'b0}), .in_b(s3), .in_c({c3[46:0],1'b0}), .out_sum(s5), .out_carry(c5));

    wire [47:0] s6,c6;
    Compress_3to2 #(48) csa6 (.in_a(s4), .in_b({c4[46:0],1'b0}), .in_c(s5), .out_sum(s6), .out_carry(c6));

    wire [47:0] s7,c7;
    Compress_3to2 #(48) csa7 (.in_a(s6), .in_b({c6[46:0],1'b0}), .in_c({c5[46:0],1'b0}), .out_sum(s7), .out_carry(c7));

    wire [47:0] fp32_sum48_fast;
    wire        fp32_co_unused;
    Ks48add u_fp32_add_stage2 (
        .a   (s7),
        .b   ({c7[46:0],1'b0}),
        .sum (fp32_sum48_fast),
        .co  (fp32_co_unused)
    );

    wire [31:0] int16_l_a0 = {8'd0, u12_0_simple};
    wire [31:0] int16_l_a1 = mix0_final_s_48[31:0];
    wire [31:0] int16_l_a2 = {mix0_final_c_48[30:0], 1'b0};
    wire [31:0] int16_l_a3 = {u8_0_res_fast[11:0], 20'd0};

    wire [31:0] int16_h_a0 = {8'd0, u12_1_simple};
    wire [31:0] int16_h_a1 = mix1_final_s_48[31:0];
    wire [31:0] int16_h_a2 = {mix1_final_c_48[30:0], 1'b0};
    wire [31:0] int16_h_a3 = {u8_1_res_fast[11:0], 20'd0};

    wire [31:0] int16_l_s1, int16_l_c1;
    Compress_3to2 #(32) u_int16_l_csa1 (
        .in_a(int16_l_a0), .in_b(int16_l_a1), .in_c(int16_l_a2),
        .out_sum(int16_l_s1), .out_carry(int16_l_c1)
    );

    wire [31:0] int16_l_s2, int16_l_c2;
    Compress_3to2 #(32) u_int16_l_csa2 (
        .in_a(int16_l_s1), .in_b({int16_l_c1[30:0],1'b0}), .in_c(int16_l_a3),
        .out_sum(int16_l_s2), .out_carry(int16_l_c2)
    );

    wire [31:0] int16_h_s1, int16_h_c1;
    Compress_3to2 #(32) u_int16_h_csa1 (
        .in_a(int16_h_a0), .in_b(int16_h_a1), .in_c(int16_h_a2),
        .out_sum(int16_h_s1), .out_carry(int16_h_c1)
    );

    wire [31:0] int16_h_s2, int16_h_c2;
    Compress_3to2 #(32) u_int16_h_csa2 (
        .in_a(int16_h_s1), .in_b({int16_h_c1[30:0],1'b0}), .in_c(int16_h_a3),
        .out_sum(int16_h_s2), .out_carry(int16_h_c2)
    );

    wire [31:0] int16_l_sum;
    CSLA #(.W(32), .BLK(4)) u_int16_l_csla (
        .a  (int16_l_s2),
        .b  ({int16_l_c2[30:0],1'b0}),
        .sum(int16_l_sum),
        .co ()
    );

    wire [31:0] int16_h_sum;
    CSLA #(.W(32), .BLK(4)) u_int16_h_csla (
        .a  (int16_h_s2),
        .b  ({int16_h_c2[30:0],1'b0}),
        .sum(int16_h_sum),
        .co ()
    );

    reg [63:0] int_out64;
    always @(*) begin
        int_out64 = 64'd0;
        case (mode)
            `INT16: int_out64 = {int16_h_sum, int16_l_sum};
            `INT8:  int_out64 = { u8_1_res_fast, u12_1_simple[15:0], u8_0_res_fast, u12_0_simple[15:0] };
            default: int_out64 = 64'd0;
        endcase
    end

    always @(*) begin
        o_P = 128'd0;
        case (mode)
            `FP32:   o_P = {80'd0, fp32_sum48_fast};

            `FP16,
            `BF16:   o_P = {64'd0, 8'd0, u12_1_simple, 8'd0, u12_0_simple};

            `FP16_4: o_P = { 8'd0, u12_1_simple,
                             8'd0, p_fp16_4_mix1,
                             8'd0, p_fp16_4_mix0,
                             8'd0, u12_0_simple };

            `FP8:    o_P = {22'd0, w_mix_1_10b[1], 22'd0, w_mix_1_10b[0],
                            22'd0, w_mix_0_10b[1], 22'd0, w_mix_0_10b[0]};
            `INT8,
            `INT16:  o_P = {64'd0, int_out64};

            default: o_P = 128'd0;
        endcase
    end

endmodule
