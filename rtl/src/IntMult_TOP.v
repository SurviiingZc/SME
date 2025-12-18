module IntMult_TOP (
    input  [31:0]        i_operand1             ,
    input  [31:0]        i_operand2             ,
    input                i_ZmIsSigned           ,
    input                i_ZnIsSigned           ,
    input  [3:0]         i_Active_Element_A     ,
    input  [3:0]         i_Active_Element_B     ,
    input  [2:0]         i_Calculation_pricision,
    output [63:0]        o_Product
);

    wire [31:0] operand1_int8 = i_operand1 & {
        {8{i_Active_Element_A[3]}},
        {8{i_Active_Element_A[2]}},
        {8{i_Active_Element_A[1]}},
        {8{i_Active_Element_A[0]}}
    };

    wire [31:0] operand2_int8 = i_operand2 & {
        {8{i_Active_Element_B[3]}},
        {8{i_Active_Element_B[2]}},
        {8{i_Active_Element_B[1]}},
        {8{i_Active_Element_B[0]}}
    };

    wire [31:0] operand1_int16 = i_operand1 & {
        {16{i_Active_Element_A[2]}},
        {16{i_Active_Element_A[0]}}
    };

    wire [31:0] operand2_int16 = i_operand2 & {
        {16{i_Active_Element_B[2]}},
        {16{i_Active_Element_B[0]}}
    };

    wire is_int8  = (i_Calculation_pricision == `INT8);
    wire is_int16 = (i_Calculation_pricision == `INT16);
    wire is_int   = is_int8 | is_int16;

    wire [31:0] operand1_sel = is_int16 ? operand1_int16 : operand1_int8;
    wire [31:0] operand2_sel = is_int16 ? operand2_int16 : operand2_int8;

    wire [31:0] operand1_in  = is_int ? operand1_sel : 32'd0;
    wire [31:0] operand2_in  = is_int ? operand2_sel : 32'd0;

    wire [2:0] int_mode = is_int16 ? `INT16 : `INT8;

    wire [63:0] o_Product_int;

    Booth_int_core u_int_core (
        .mode      ( int_mode      ),
        .i_SignedA ( i_ZmIsSigned  ),
        .i_SignedB ( i_ZnIsSigned  ),
        .i_A       ( operand1_in   ),
        .i_B       ( operand2_in   ),
        .o_P       ( o_Product_int )
    );

    assign o_Product = is_int ? o_Product_int : 64'd0;

endmodule
