/*
Version: 20251016
*/
module C4_LZC_round #(
    parameter WIDTH = 49
)(   
    input       [WIDTH-1:0] in,       
    output reg  [5:0]       o_count   
);

    function [1:0] lzc2;
        input [1:0] x;
        begin
            lzc2 = x[1] ? 2'd0 : x[0] ? 2'd1 : 2'd2 ;
        end
    endfunction

    function [2:0] lzc4;
        reg lz_high,lz_low;
        reg [1:0] lz_2;
        input [3:0] x;
        begin
            lz_high = |x[3:2];
            lz_low  = |x[1:0];
            if (lz_high) begin
                lz_2 = lzc2(x[3:2]);
                lzc4 = {1'd0,lz_2};
            end else if (lz_low) begin
                lz_2 = lzc2(x[1:0]);
                lzc4 = 3'd2 + {1'd0,lz_2};
            end else begin
                lzc4 = 3'd4;
            end
        end
    endfunction


    // 8 位 LZC
    function [3:0] lzc8;
        reg lz_high,lz_low;
        reg [2:0] lz_4;
        input [7:0] x;
        begin
            lz_high = |x[7:4];
            lz_low  = |x[3:0];
            if (lz_high) begin
                lz_4 = lzc4(x[7:4]);
                lzc8 = {1'd0,lz_4};
            end else if (lz_low) begin
                lz_4 = lzc4(x[3:0]);
                lzc8 = 4'd4 + {1'd0,lz_4};
            end else begin
                lzc8 = 4'd8;
            end
        end
    endfunction

    function [4:0] lzc16;
        input [15:0] x;
        reg lz_high,lz_low;
        reg [3:0] lz_8;
        begin
        lz_high = |x[15:8];
        lz_low  = |x[7:0];
        if (lz_high) begin
            lz_8 = lzc8(x[15:8]);
            lzc16 = {1'd0,lz_8};
        end else if (lz_low) begin
            lz_8 = lzc8(x[7:0]);
            lzc16 = 5'd8 + {1'd0,lz_8};
        end else begin
            lzc16 = 5'd16;
        end
        end  
    endfunction

    function [4:0] lzc17;
        input [16:0] x;
        begin
            if (x[16]) begin
                lzc17 = 5'd0 ;
            end else begin
                lzc17 = 5'd1 + lzc16(x[15:0]);
            end
        end
    endfunction

    function [5:0] lzc32;
        input [31:0] x;
        reg lz_high,lz_low;
        reg [4:0] lz_16;
        begin
        lz_high = |x[31:16];
        lz_low  = |x[15:0];
        if (lz_high) begin
            lz_16 = lzc16(x[31:16]);
            lzc32 = {1'd0,lz_16};
        end else if (lz_low) begin
            lz_16 = lzc16(x[15:0]);
            lzc32 = 6'd16 + {1'd0,lz_16};
        end else begin
            lzc32 = 6'd32;
        end  
        end
    endfunction


generate
    if (WIDTH == 49) begin : G_WIDTH49
        wire zero_detect = ~(|in);
        wire [31:0] hi32 = in[48:17];
        wire [16:0] lo17 = in[16:0];

        wire hi_nz = |hi32;
        wire lo_nz = |lo17;

        wire [5:0] cnt_hi32 = lzc32(hi32);                 
        wire [5:0] cnt_lo17 = 6'd32 + {1'b0, lzc17(lo17)}; 

        assign o_count = zero_detect ? 6'd49 :
                         (hi_nz ? cnt_hi32 : cnt_lo17);

    end else begin : G_WIDTH48
        wire zero_detect = ~(|in);
        wire [31:0] hi32 = in[47:16];
        wire [15:0] lo16 = in[15:0];

        wire hi_nz = |hi32;
        wire lo_nz = |lo16;

        wire [5:0] cnt_hi32 = lzc32(hi32);                 
        wire [5:0] cnt_lo16 = 6'd32 + {1'b0, lzc16(lo16)}; 

        assign o_count = zero_detect ? 6'd48 :
                         (hi_nz ? cnt_hi32 : cnt_lo16);
    end
endgenerate


endmodule
