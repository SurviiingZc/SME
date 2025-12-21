module booth_pp_generator #(
  parameter WIDTH = 12
)(
  input  [WIDTH-1:0] i_a_in,
  input  [2:0]       i_code_in,
  output [WIDTH:0]   o_pp_out,
  output             o_neg_sig
);
  wire y2 = i_code_in[2];
  wire y1 = i_code_in[1];
  wire y0 = i_code_in[0];

  wire is_one  = y1 ^ y0;
  wire is_two  = (~y2 &  y1 &  y0) | ( y2 & ~y1 & ~y0);
  wire is_zero = ~(is_one | is_two);
  wire neg = y2 & ~(y1 & y0);
  assign o_neg_sig = neg & ~is_zero;

  wire [WIDTH:0] mag_one = {i_a_in[WIDTH-1], i_a_in};
  wire [WIDTH:0] mag_two = {i_a_in, 1'b0};
  wire [WIDTH:0] mag_sel = is_two ? mag_two : mag_one;

  assign o_pp_out = is_zero ? { (WIDTH+1){1'b0} } :
                    (neg ? ~mag_sel : mag_sel);

endmodule
