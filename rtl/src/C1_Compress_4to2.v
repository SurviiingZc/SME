module Compress_4to2 (
    input   x0      ,
    input   x1      ,
    input   x2      ,
    input   x3      ,
    input   Cin     ,
    output  Sum     ,
    output  Carry   ,
    output  Cout
);
    
    wire w_xor1 = x0 ^ x1                               ;
    assign Cout = (x0 & x1) | (w_xor1 & x2)             ;
            
    wire s_int  = w_xor1 ^ x2                           ;
            
    wire w_s_x3     = s_int ^ x3                        ;
    assign Sum  = x0 ^ x1 ^ x2 ^ x3 ^ Cin               ;

    assign Carry    = (s_int & x3)  | (w_s_x3 & Cin)    ;

endmodule