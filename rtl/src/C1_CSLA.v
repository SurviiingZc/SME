module CSLA #(parameter W=48, parameter BLK=8)(
    input  [W-1:0] a,
    input  [W-1:0] b,
    output [W-1:0] sum,
    output         co
);
    localparam integer N = W/BLK;

    wire [N:0] c;
    assign c[0] = 1'b0;

    wire [BLK:0] blk0_add = {1'b0, a[0 +: BLK]} + {1'b0, b[0 +: BLK]};
    assign sum[0 +: BLK] = blk0_add[BLK-1:0];
    assign c[1]          = blk0_add[BLK];

    genvar i, j;
    generate
        for (i=1; i<N; i=i+1) begin : g_blk
            wire [BLK:0] add0 = {1'b0, a[i*BLK +: BLK]} + {1'b0, b[i*BLK +: BLK]};
            wire [BLK-1:0] s0 = add0[BLK-1:0];
            wire c0 = add0[BLK];

            wire [BLK-1:0] s1;
            wire [BLK:0] carry_bec;
            assign carry_bec[0] = 1'b1;
            for (j=0; j<BLK; j=j+1) begin : g_bec
                assign s1[j]        = s0[j] ^ carry_bec[j];
                assign carry_bec[j+1] = s0[j] & carry_bec[j];
            end

            wire all1 = &s0;
            wire c1   = c0 | all1; 

            assign sum[i*BLK +: BLK] = c[i] ? s1 : s0;
            assign c[i+1]            = c[i] ? c1 : c0;
        end
    endgenerate

    assign co = c[N];
endmodule
