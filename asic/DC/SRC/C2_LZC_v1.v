/*
Version: 20250925 — 组合 LZC（parallel-select with mapping comments）
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
    wire [7:0] seg1, seg2, seg3, seg4, seg5;

    wire valid0, valid1, valid2, valid3, valid4, valid5;

    wire wid_sel = (WIDTH == 48);

    assign seg0 = (wid_sel)? {1'b0,in[7:0]} : in[8:0];
    assign seg1 = (WIDTH > 8 ) ? in[15:8]  : 8'b0;
    assign seg2 = (WIDTH > 16) ? in[23:16] : 8'b0;
    assign seg3 = (WIDTH > 24) ? in[31:24] : 8'b0;
    assign seg4 = (WIDTH > 32) ? in[39:32] : 8'b0;
    assign seg5 = (WIDTH > 40) ? in[47:40] : 8'b0;

    assign valid0 = |seg0;
    assign valid1 = |seg1;
    assign valid2 = |seg2;
    assign valid3 = |seg3;
    assign valid4 = |seg4;
    assign valid5 = |seg5;

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

    wire hit5 =  valid5;
    wire hit4 = ~valid5 & valid4;
    wire hit3 = ~(valid5|valid4) & valid3;
    wire hit2 = ~(valid5|valid4|valid3) & valid2;
    wire hit1 = ~(valid5|valid4|valid3|valid2) & valid1;
    wire hit0 = ~(valid5|valid4|valid3|valid2|valid1) & valid0;
    wire none = ~(valid5|valid4|valid3|valid2|valid1|valid0);

    wire [5:0] count_49 =
          ({6{hit5}} & (6'd0  + lzc8(seg5)))
        | ({6{hit4}} & (6'd8  + lzc8(seg4)))
        | ({6{hit3}} & (6'd16 + lzc8(seg3)))
        | ({6{hit2}} & (6'd24 + lzc8(seg2)))
        | ({6{hit1}} & (6'd32 + lzc8(seg1)))
        | ({6{hit0}} & (6'd40 + lzc9(seg0)))
        | ({6{none}} & 6'd49);

    wire [5:0] count_48 =
          ({6{hit5}} & (6'd0  + lzc8(seg5)))
        | ({6{hit4}} & (6'd8  + lzc8(seg4)))
        | ({6{hit3}} & (6'd16 + lzc8(seg3)))
        | ({6{hit2}} & (6'd24 + lzc8(seg2)))
        | ({6{hit1}} & (6'd32 + lzc8(seg1)))
        | ({6{hit0}} & (6'd40 + lzc8(seg0[7:0])))
        | ({6{none}} & 6'd48);

    wire [5:0] count_w = ({6{~wid_sel}} & count_49) | ({6{wid_sel}} & count_48);

    always @(*) begin
        count   = count_w;   
        o_count = count_w;
    end

endmodule
