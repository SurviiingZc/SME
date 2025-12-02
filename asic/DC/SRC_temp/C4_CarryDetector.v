module C4_CarryDetector #(
    parameter WIDTH = 7,
    parameter DENOR = 8'h10
)(
    input  [WIDTH:0]    mantissa,
    output              carry,
    output              round_deor2nor,
    output [WIDTH-1:0]  rounded_mantissa
);
    wire [WIDTH+1:0] mantissa_ext  = mantissa + 1'b1;
    assign carry = mantissa_ext[WIDTH+1];  
    assign round_deor2nor = (mantissa_ext == DENOR);
    assign rounded_mantissa = carry ? 
                             mantissa_ext[WIDTH:1] :  // DIV2
                             mantissa_ext[WIDTH:0]; 
endmodule