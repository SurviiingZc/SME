module IntMult_TOP (
    input  [31:0]        i_operand1             ,     
    input  [31:0]        i_operand2             ,     
    input                i_ZmIsSigned           ,  // 0 -> unsigned 1 -> signed Zm 
    input                i_ZnIsSigned           ,  // 0 -> unsigned 1 -> signed Zn 
    input  [3:0]         i_Active_Element_A     ,
    input  [3:0]         i_Active_Element_B     ,
    input  [2:0]         i_Calculation_pricision,
    output [31:0]        o_AddZA                ,
    output [63:0]        o_Product     
);
 
wire [63:0] o_Product_int8 , o_Product_int16;
assign o_AddZA = i_Active_Element_A[0] ? 'd0 : i_operand1;
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
 
assign o_Product = (i_Calculation_pricision == `INT16) ? o_Product_int16 :
                   ((i_Calculation_pricision == `INT8) ? o_Product_int8 : 64'b0);
 
IntMult#(
    .IN_WIDTH     ( 8 )
) u_IntMult (
    .operand1     ( operand1_int8     ),
    .operand2     ( operand2_int8     ),
    .i_ZmIsSigned ( i_ZmIsSigned   ),
    .i_ZnIsSigned ( i_ZnIsSigned   ),
    .o_Product    ( o_Product_int8    )
);
 
Int16Mult#(
    .IN_WIDTH     ( 16 )
) u_Int16Mult (
    .operand1     ( operand1_int16     ),
    .operand2     ( operand2_int16     ),
    .i_ZmIsSigned ( i_ZmIsSigned   ),
    .i_ZnIsSigned ( i_ZnIsSigned   ),
    .o_Product    ( o_Product_int16    )
);
 
endmodule 