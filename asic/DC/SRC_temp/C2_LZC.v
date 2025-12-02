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

    // 8 位 LZC
    function [3:0] lzc8;
        reg lz_high,lz_low;
        reg [2:0] lz_4;
        input [7:0] x;
        begin
            lz_high = |x[7:4];
            lz_low  = |x[3:0]; 
            if(lz_high) begin
                lz_4 = lzc4(x[7:4]);
                lzc8 = {1'd0,lz_4};
            end else if(lz_low) begin
                lz_4 = lzc4(x[3:0]);
                lzc8 = 4'd4 + {1'd0,lz_4}; 
            end else begin
                lzc8 = 4'd8;
            end
        end
    endfunction

    function [2:0] lzc4;
        reg lz_high,lz_low;
        reg [1:0] lz_2;
        input [3:0] x;
        begin
            lz_high = |x[3:2];
            lz_low  = |x[1:0]; 
            if(lz_high) begin
                lz_2 = lzc2(x[3:2]);
                lzc4 = {1'd0,lz_2};
            end else if(lz_low) begin
                lz_2 = lzc2(x[1:0]);
                lzc4 = 3'd2 + {1'd0,lz_2}; 
            end else begin
                lzc4 = 3'd4;
            end
        end
    endfunction

    function [1:0] lzc2;
        input [1:0] x;
        begin
            lzc2 = x[1] ? 2'd0 : x[0] ? 2'd1 : 2'd2 ;
        end
    endfunction

    // 9 位 LZC
    function [3:0] lzc9;
        input [8:0] x;
        begin
            if(x[8]) begin
                lzc9 = 4'd0 ;
            end else begin
                lzc9 = 4'd1 + lzc8(x[7:0]);
            end
        end
    endfunction

generate
    if (WIDTH == 49) begin : G_WIDTH49
        // 顶段 9 位（MSB..）
        wire [8:0] seg_top = in[48:40];
        wire [7:0] seg4    = in[39:32];
        wire [7:0] seg3    = in[31:24];
        wire [7:0] seg2    = in[23:16];
        wire [7:0] seg1    = in[15:8] ;
        wire [7:0] seg0    = in[7:0]  ;

        wire valid_top = |seg_top;
        wire valid4    = |seg4;
        wire valid3    = |seg3;
        wire valid2    = |seg2;
        wire valid1    = |seg1;
        wire valid0    = |seg0;

        wire v_top     = valid_top ;
        wire v4        = ~valid_top & valid4 ;
        wire v3        = ~valid_top & ~valid4 & valid3;
        wire v2        = ~valid_top & ~valid4 & ~valid3 & valid2;
        wire v1        = ~valid_top & ~valid4 & ~valid3 & ~valid2 & valid1;
        wire v0        = ~valid_top & ~valid4 & ~valid3 & ~valid2 & ~valid1 & valid0;

        wire [5:0]  cnt_top = 6'd0  + lzc9(seg_top);
        wire [5:0]  cnt4    = 6'd9  + lzc9(seg4);
        wire [5:0]  cnt3    = 6'd17 + lzc9(seg3);
        wire [5:0]  cnt2    = 6'd25 + lzc9(seg2);
        wire [5:0]  cnt1    = 6'd33 + lzc9(seg1);
        wire [5:0]  cnt0    = 6'd41 + lzc9(seg0);

        wire any1 = v_top | v4 | v3 | v2 | v1 | v0 ;
        wire [5:0] count = ({6{v_top}} & cnt_top) |
                        ({6{v4}} & cnt4) | 
                        ({6{v3}} & cnt3) |
                        ({6{v2}} & cnt2) |
                        ({6{v1}} & cnt1) |
                        ({6{v0}} & cnt0) ;
        assign o_count = any1 ? count : 6'd49 ; 
    end else begin : G_WIDTH48  // 兼容 48 位输入（6×8）
        wire [7:0] seg5 = in[47:40];
        wire [7:0] seg4 = in[39:32];
        wire [7:0] seg3 = in[31:24];
        wire [7:0] seg2 = in[23:16];
        wire [7:0] seg1 = in[15:8] ;
        wire [7:0] seg0 = in[7:0]  ;

        wire valid5 = |seg5;
        wire valid4 = |seg4;
        wire valid3 = |seg3;
        wire valid2 = |seg2;
        wire valid1 = |seg1;
        wire valid0 = |seg0;

        wire v5        = valid5 ;
        wire v4        = ~valid5 & valid4 ;
        wire v3        = ~valid5 & ~valid4 & valid3;
        wire v2        = ~valid5 & ~valid4 & ~valid3 & valid2;
        wire v1        = ~valid5 & ~valid4 & ~valid3 & ~valid2 & valid1;
        wire v0        = ~valid5 & ~valid4 & ~valid3 & ~valid2 & ~valid1 & valid0;

        wire [5:0]  cnt5    = 6'd0  + lzc8(seg5);
        wire [5:0]  cnt4    = 6'd8  + lzc8(seg4);
        wire [5:0]  cnt3    = 6'd16 + lzc8(seg3);
        wire [5:0]  cnt2    = 6'd24 + lzc8(seg2);
        wire [5:0]  cnt1    = 6'd32 + lzc8(seg1);
        wire [5:0]  cnt0    = 6'd40 + lzc8(seg0);

        wire any1 = v5 | v4 | v3 | v2 | v1 | v0 ;
        wire [5:0] count = ({6{v5}} & cnt5) |
                        ({6{v4}} & cnt4) | 
                        ({6{v3}} & cnt3) |
                        ({6{v2}} & cnt2) |
                        ({6{v1}} & cnt1) |
                        ({6{v0}} & cnt0) ;
        assign o_count = any1 ? count : 6'd48 ; 
    end
endgenerate
endmodule