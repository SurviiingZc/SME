module Booth_12x12 (
    input   [11:0]  i_a     ,
    input   [11:0]  i_b     ,
    output  [23:0]  o_sum   , 
    output  [23:0]  o_carry   
);
    wire    [12:0]      T_pp0, T_pp1, T_pp2, T_pp3, T_pp4, T_pp5;
    wire                T_neg0, T_neg1, T_neg2, T_neg3, T_neg4, T_neg5;

    wire [2:0]  group0  = {i_b[1], i_b[0], 1'b0}        ;
    wire [2:0]  group1  = {i_b[3], i_b[2], i_b[1]}      ;
    wire [2:0]  group2  = {i_b[5], i_b[4], i_b[3]}      ;
    wire [2:0]  group3  = {i_b[7], i_b[6], i_b[5]}      ;
    wire [2:0]  group4  = {i_b[9], i_b[8], i_b[7]}      ;
    wire [2:0]  group5  = {i_b[11], i_b[10], i_b[9]}    ;

    booth_pp_generator #(.WIDTH(12)) u_pp0 (.i_a_in(i_a), .i_code_in(group0), .o_pp_out(T_pp0), .o_neg_sig(T_neg0));
    booth_pp_generator #(.WIDTH(12)) u_pp1 (.i_a_in(i_a), .i_code_in(group1), .o_pp_out(T_pp1), .o_neg_sig(T_neg1));
    booth_pp_generator #(.WIDTH(12)) u_pp2 (.i_a_in(i_a), .i_code_in(group2), .o_pp_out(T_pp2), .o_neg_sig(T_neg2));
    booth_pp_generator #(.WIDTH(12)) u_pp3 (.i_a_in(i_a), .i_code_in(group3), .o_pp_out(T_pp3), .o_neg_sig(T_neg3));
    booth_pp_generator #(.WIDTH(12)) u_pp4 (.i_a_in(i_a), .i_code_in(group4), .o_pp_out(T_pp4), .o_neg_sig(T_neg4));
    booth_pp_generator #(.WIDTH(12)) u_pp5 (.i_a_in(i_a), .i_code_in(group5), .o_pp_out(T_pp5), .o_neg_sig(T_neg5));

    wire [23:0] pp0_ext = {{11{T_pp0[12]}}, T_pp0}                              ;
    wire [23:0] pp1_ext = {{9{T_pp1[12]}}, T_pp1, 1'b0, T_neg0}                 ;
    wire [23:0] pp2_ext = {{7{T_pp2[12]}}, T_pp2, 1'b0, T_neg1, 2'b00}          ;
    wire [23:0] pp3_ext = {{5{T_pp3[12]}}, T_pp3, 1'b0, T_neg2, 4'b0000}        ;
    wire [23:0] pp4_ext = {{3{T_pp4[12]}}, T_pp4, 1'b0, T_neg3, 6'b000000}      ;
    wire [23:0] pp5_ext = {T_pp5[12], T_pp5, 1'b0, T_neg4, 8'b00000000}         ;
    
    wire [23:0] neg5_vec = (T_neg5 << 10);

    wire [23:0] s1 = pp0_ext ^ pp1_ext ^ pp2_ext;
    wire [23:0] c1 = (pp0_ext & pp1_ext) | (pp0_ext & pp2_ext) | (pp1_ext & pp2_ext);
    
    wire [23:0] s2 = pp3_ext ^ pp4_ext ^ pp5_ext;
    wire [23:0] c2 = (pp3_ext & pp4_ext) | (pp3_ext & pp5_ext) | (pp4_ext & pp5_ext);

    wire [23:0] c1_sh = {c1[22:0], 1'b0};
    wire [23:0] s3 = s1 ^ c1_sh ^ s2;
    wire [23:0] c3 = (s1 & c1_sh) | (s1 & s2) | (c1_sh & s2);

    wire [23:0] c3_sh = {c3[22:0], 1'b0};
    wire [23:0] c2_sh = {c2[22:0], 1'b0};
    
    wire [23:0] s4 = s3 ^ c3_sh ^ c2_sh;
    wire [23:0] c4 = (s3 & c3_sh) | (s3 & c2_sh) | (c3_sh & c2_sh);

    wire [23:0] c4_sh = {c4[22:0], 1'b0};
    
    assign o_sum   = s4 ^ c4_sh ^ neg5_vec;
    assign o_carry = ((s4 & c4_sh) | (s4 & neg5_vec) | (c4_sh & neg5_vec)) << 1;

endmodule