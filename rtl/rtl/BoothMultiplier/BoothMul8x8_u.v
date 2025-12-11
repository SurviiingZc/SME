module BoothMul8x8_u (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] p
);
    Multiplier_8bits_8bits u_mul (
        .A_NUM (a),
        .B_NUM (b),
        .C_NUM (p)
    );
endmodule