module Booth_8x8 (
    input   [7:0]     i_a   ,
    input   [7:0]     i_b   ,
    output  [15:0]    o_sum ,
    output  [15:0]    o_carry   
);
    wire    [8:0]   T_pp0, T_pp1, T_pp2, T_pp3;
    wire            T_neg0, T_neg1, T_neg2, T_neg3;

    wire [2:0]  group0  = {i_b[1], i_b[0], 1'b0}    ;
    wire [2:0]  group1  = {i_b[3], i_b[2], i_b[1]}  ;
    wire [2:0]  group2  = {i_b[5], i_b[4], i_b[3]}  ;
    wire [2:0]  group3  = {i_b[7], i_b[6], i_b[5]}  ;

    booth_pp_generator #(.WIDTH(8)) u_pp0 (.i_a_in(i_a), .i_code_in(group0), .o_pp_out(T_pp0), .o_neg_sig(T_neg0));
    booth_pp_generator #(.WIDTH(8)) u_pp1 (.i_a_in(i_a), .i_code_in(group1), .o_pp_out(T_pp1), .o_neg_sig(T_neg1));
    booth_pp_generator #(.WIDTH(8)) u_pp2 (.i_a_in(i_a), .i_code_in(group2), .o_pp_out(T_pp2), .o_neg_sig(T_neg2));
    booth_pp_generator #(.WIDTH(8)) u_pp3 (.i_a_in(i_a), .i_code_in(group3), .o_pp_out(T_pp3), .o_neg_sig(T_neg3));

    wire [15:0] pp0_ext, pp1_ext, pp2_ext, pp3_ext;

    assign pp0_ext  = {{7{T_pp0[8]}}, T_pp0}                        ;
    assign pp1_ext  = {{5{T_pp1[8]}}, T_pp1, 1'b0, T_neg0}          ;
    assign pp2_ext  = {{3{T_pp2[8]}}, T_pp2, 1'b0, T_neg1, 2'b00}   ;
    assign pp3_ext  = {T_pp3[8], T_pp3, 1'b0, T_neg2, 4'b0000}      ;

    wire [15:0] neg3_vec = (T_neg3 << 6);

    wire [15:0] s1 = pp0_ext ^ pp1_ext ^ pp2_ext;
    wire [15:0] c1 = (pp0_ext & pp1_ext) | (pp0_ext & pp2_ext) | (pp1_ext & pp2_ext);

    wire [15:0] c1_sh = {c1[14:0], 1'b0};
    
    wire [15:0] s2 = s1 ^ c1_sh ^ pp3_ext;
    wire [15:0] c2 = (s1 & c1_sh) | (s1 & pp3_ext) | (c1_sh & pp3_ext);

    wire [15:0] c2_sh = {c2[14:0], 1'b0};

    assign o_sum   = s2 ^ c2_sh ^ neg3_vec;
    
    assign o_carry = ((s2 & c2_sh) | (s2 & neg3_vec) | (c2_sh & neg3_vec)) << 1;

endmodule