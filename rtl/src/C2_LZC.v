/*
Version: 20250811 — 组合 LZC
说明：WIDTH=49 时采用 9+8×5 分段，覆盖到 bit[48]；WIDTH=48 时采用 6×8 分段。
*/
module C2_LZC_round #(
/*
Verision: 20250809

*/
    parameter WIDTH = 48  
)(
    input  wire [WIDTH-1:0] in,
    output reg  [5:0]       o_count  
);

    reg  [5:0] count;
    wire [8:0] seg0;
    wire [7:0] seg1;
    wire [7:0] seg2;
    wire [7:0] seg3;
    wire [7:0] seg4;
    wire [7:0] seg5;

    wire valid0;
    wire valid1;
    wire valid2;
    wire valid3;
    wire valid4;
    wire valid5;
    
    wire wid_sel;
    assign wid_sel = (WIDTH == 48)? 1'd1 : 1'd0;

    assign seg0 = (wid_sel)? {1'b0,in[7:0]} : in[8:0];
    assign seg1 = (WIDTH > 8)  ? in[15:8]   : 8'b0;
    assign seg2 = (WIDTH > 16) ? in[23:16]  : 8'b0;
    assign seg3 = (WIDTH > 24) ? in[31:24]  : 8'b0;
    assign seg4 = (WIDTH > 32) ? in[39:32]  : 8'b0;
    assign seg5 = (WIDTH > 40) ? in[47:40]  : 8'b0;

    assign valid0 = |seg0;
    assign valid1 = |seg1;
    assign valid2 = |seg2;
    assign valid3 = |seg3;
    assign valid4 = |seg4;
    assign valid5 = |seg5;

    // 8-bit LZC
    function [3:0] lzc8;
        input [7:0] x;
        begin
            casex (x)
                8'b1xxxxxxx: lzc8 = 4'd0;
                8'b01xxxxxx: lzc8 = 4'd1;
                8'b001xxxxx: lzc8 = 4'd2;
                8'b0001xxxx: lzc8 = 4'd3;
                8'b00001xxx: lzc8 = 4'd4;
                8'b000001xx: lzc8 = 4'd5;
                8'b0000001x: lzc8 = 4'd6;
                8'b00000001: lzc8 = 4'd7;
                default:      lzc8 = 4'd8;
            endcase
        end
    endfunction

    // 9-bit LZC
    function [3:0] lzc9;
        input [8:0] x;
        begin
            casex (x)
                9'b1xxxxxxxx: lzc9 = 4'd0;
                9'b01xxxxxxx: lzc9 = 4'd1;
                9'b001xxxxxx: lzc9 = 4'd2;
                9'b0001xxxxx: lzc9 = 4'd3;
                9'b00001xxxx: lzc9 = 4'd4;
                9'b000001xxx: lzc9 = 4'd5;
                9'b0000001xx: lzc9 = 4'd6;
                9'b00000001x: lzc9 = 4'd7;
                9'b000000001: lzc9 = 4'd8;
                default:      lzc9 = 4'd9;
            endcase
        end
    endfunction

    always @(*) begin
            case (wid_sel)
                1'b0 : begin
                        if (valid5) count = 0 + lzc8(seg5);
                    else if (valid4) count = 8 + lzc8(seg4);
                    else if (valid3) count = 16 + lzc8(seg3);
                    else if (valid2) count = 24 + lzc8(seg2);
                    else if (valid1) count = 32 + lzc8(seg1);
                    else if (valid0) count = 40 + lzc9(seg0);
                    else count = 49;
                end
                1'b1 : begin
                        if (valid5) count = 0 + lzc8(seg5);
                    else if (valid4) count = 8 + lzc8(seg4);
                    else if (valid3) count = 16 + lzc8(seg3);
                    else if (valid2) count = 24 + lzc8(seg2);
                    else if (valid1) count = 32 + lzc8(seg1);
                    else if (valid0) count = 40 + lzc8(seg0[7:0]);
                    else count = 48;
                end
                default: count = 49;
            endcase
            //if(count == 0) begin
            //    o_count = 6'd50;
            //end
            //else begin
            //    o_count = count - 6'd1;
            //end
            o_count = count ;
        end

endmodule




