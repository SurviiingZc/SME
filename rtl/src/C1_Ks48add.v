module Ks48add (
    input  [47:0] a,
    input  [47:0] b,
    output [47:0] sum,
    output        co
);
    wire [47:0] p0, g0;
    assign p0 = a ^ b;
    assign g0 = a & b;

    wire [47:0] p1, g1;
    wire [47:0] p2, g2;
    wire [47:0] p3, g3;
    wire [47:0] p4, g4;
    wire [47:0] p5, g5;
    wire [47:0] p6, g6;

    genvar i;

    generate
        for (i=0; i<48; i=i+1) begin: ST1
            if (i>=1) begin
                assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
                assign p1[i] = p0[i] & p0[i-1];
            end else begin
                assign g1[i] = g0[i];
                assign p1[i] = p0[i];
            end
        end
    endgenerate

    generate
        for (i=0; i<48; i=i+1) begin: ST2
            if (i>=2) begin
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
                assign p2[i] = p1[i] & p1[i-2];
            end else begin
                assign g2[i] = g1[i];
                assign p2[i] = p1[i];
            end
        end
    endgenerate

    generate
        for (i=0; i<48; i=i+1) begin: ST3
            if (i>=4) begin
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
                assign p3[i] = p2[i] & p2[i-4];
            end else begin
                assign g3[i] = g2[i];
                assign p3[i] = p2[i];
            end
        end
    endgenerate

    generate
        for (i=0; i<48; i=i+1) begin: ST4
            if (i>=8) begin
                assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
                assign p4[i] = p3[i] & p3[i-8];
            end else begin
                assign g4[i] = g3[i];
                assign p4[i] = p3[i];
            end
        end
    endgenerate

    generate
        for (i=0; i<48; i=i+1) begin: ST5
            if (i>=16) begin
                assign g5[i] = g4[i] | (p4[i] & g4[i-16]);
                assign p5[i] = p4[i] & p4[i-16];
            end else begin
                assign g5[i] = g4[i];
                assign p5[i] = p4[i];
            end
        end
    endgenerate

    generate
        for (i=0; i<48; i=i+1) begin: ST6
            if (i>=32) begin
                assign g6[i] = g5[i] | (p5[i] & g5[i-32]);
                assign p6[i] = p5[i] & p5[i-32];
            end else begin
                assign g6[i] = g5[i];
                assign p6[i] = p5[i];
            end
        end
    endgenerate

    wire [48:0] c;
    assign c  = {g6, 1'b0};
    assign sum = p0 ^ c[47:0];
    assign co  = c[48];

endmodule