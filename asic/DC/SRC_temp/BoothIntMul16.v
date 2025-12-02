module BoothIntMul16 (
    input  [15:0] a,
    input  [15:0] b,
    input         signedA,
    input         signedB,
    output [31:0] p
);
    wire signed [16:0] a_ext;
    wire signed [16:0] b_ext;

    assign a_ext = (signedA == `Zm_Is_Unsigned) ? {1'b0, a} : {a[15], a};
    assign b_ext = (signedB == `Zm_Is_Unsigned) ? {1'b0, b} : {b[15], b};

    wire [23:0] booth_a = {7'd0, a_ext[15:0]};  // pad 到 24bit
    wire [23:0] booth_b = {7'd0, b_ext[15:0]};
    wire [47:0] p48;

    Multiplier_24bits_24bits u_booth24 (
        .i_Numerical_Precision (2'b11),
        .A_NUM (booth_a),
        .B_NUM (booth_b),
        .C_NUM (p48)
    );

    assign p = p48[31:0];
endmodule
