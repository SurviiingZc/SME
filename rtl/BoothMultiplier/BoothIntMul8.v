module BoothIntMul8 (
    input  [7:0] a,
    input  [7:0] b,
    input        signedA,
    input        signedB,
    output [15:0] p
);
    wire signed [8:0] a_ext;
    wire signed [8:0] b_ext;

    assign a_ext = (signedA == 'Zm_Is_Unsigned) ? {1'b0, a} : {a[7], a};
    assign b_ext = (signedB == 'Zm_Is_Unsigned) ? {1'b0, b} : {b[7], b};

    wire [15:0] p_unsigned;
    Multiplier_8bits_8bits u_booth8 (
        .A_NUM (a_ext[7:0]),  
        .B_NUM (b_ext[7:0]),
        .C_NUM (p_unsigned)
    );

    wire signed [15:0] signed_result = 
        $signed({{7{a_ext[8]}}, a_ext[7:0]}) * $signed({{7{b_ext[8]}}, b_ext[7:0]});

    assign p = (signedA || signedB) ? signed_result : p_unsigned;
endmodule
