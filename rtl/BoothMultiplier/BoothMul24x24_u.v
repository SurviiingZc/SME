module BoothMul24x24_u (
    input  [23:0] a,
    input  [23:0] b,
    output [47:0] p
);
    Multiplier_24bits_24bits u_mul (
        .i_Numerical_Precision (2'b11),
        .A_NUM                  (a),
        .B_NUM                  (b),
        .C_NUM                  (p)
    );
endmodule