module BoothMul11x11_u (
    input  [10:0] a,
    input  [10:0] b,
    output [21:0] p
);
    wire [11:0] a12 = {1'b0, a};
    wire [11:0] b12 = {1'b0, b};
    wire [23:0] p12;

    Multiplier_12bits_12bits u_mul (
        .i_Numerical_Precision (2'b10),
        .A_NUM                  (a12),
        .B_NUM                  (b12),
        .C_NUM                  (p12)
    );
    assign p = p12[21:0];  
endmodule