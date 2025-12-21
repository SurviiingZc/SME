module Booth_4x4 (
    input       [3:0]   i_a,
    input       [3:0]   i_b,
    output      [8:0]   o_p
);

    wire [2:0]  group0  = {i_b[1], i_b[0], 1'b0}    ;
    wire [2:0]  group1  = {i_b[3], i_b[2], i_b[1]}  ;

    wire [4:0]  T_pp0   ;
    wire        T_neg0  ;

    wire [4:0]  T_pp1   ;
    wire        T_neg1  ;

    booth_pp_generator #(
        .WIDTH      ( 4 )
    ) u_pp0 (
        .i_a_in     ( i_a        ),
        .i_code_in  ( group0     ),
        .o_pp_out   ( T_pp0      ),
        .o_neg_sig  ( T_neg0     )
    );

    booth_pp_generator #(
        .WIDTH      ( 4 )
    ) u_pp1 (
        .i_a_in     ( i_a        ),
        .i_code_in  ( group1     ),
        .o_pp_out   ( T_pp1      ),
        .o_neg_sig  ( T_neg1     )
    );

    wire [7:0]  pp0_ext ;
    wire [7:0]  pp1_ext ;

    assign  pp0_ext = {{3{T_pp0[4]}}, T_pp0}    ;
    assign  pp1_ext = {T_pp1[4], T_pp1, 2'b00}  ;

    assign o_p  = pp0_ext + pp1_ext + T_neg0 + (T_neg1 << 2) ;



endmodule