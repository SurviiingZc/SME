module IntMultAdd_1cycle_pipelined(
    input clk,
    input rstn,
    input [31:0]        i_operand1,
    input [31:0]        i_operand2,
    input [127:0]       i_Addend,
    input               i_ZmIsSigned,       // 0 -> unsigned 1 -> signed Zm 
    input               i_ZnIsSigned,       // 0 -> unsigned 1 -> signed Zn 
    input [3:0]         i_Active_Element_A,
    input [3:0]         i_Active_Element_B,
    input               i_Calculation_mode, // 0 -> Inner_Product; 1 -> Outer_Product
    input [2:0]         i_Calculation_pricision,
    input               i_Num_of_Vector_Group, // 0 -> Single_Vector_Group; 1 -> Double_Vector_Group; 2 -> Quad_Vector_Group
    input               i_Operator,        // 0 -> Subtraction_Operation; 1 -> Addition_Operation 
    output reg [127:0]  Output
);

reg [31:0]        r_operand1;
reg [31:0]        r_operand2;
reg [127:0]       r_Addend;
reg               r_ZmIsSigned;
reg               r_ZnIsSigned;
reg [3:0]         r_Active_Element_A;
reg [3:0]         r_Active_Element_B;
reg               r_Calculation_mode;
reg [2:0]         r_Calculation_pricision;
reg               r_Num_of_Vector_Group;
reg               r_Operator;

wire [63:0]       o_Product;
wire [127:0]      o_Output;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        r_operand1             <= 0;
        r_operand2             <= 0;
        r_Addend               <= 0;
        r_ZmIsSigned           <= 0;
        r_ZnIsSigned           <= 0;
        r_Active_Element_A     <= 0;
        r_Active_Element_B     <= 0;
        r_Calculation_mode     <= 0;
        r_Calculation_pricision<= 0;
        r_Num_of_Vector_Group  <= 0;
        r_Operator             <= 0;
    end else begin
        r_operand1             <= i_operand1;
        r_operand2             <= i_operand2;
        r_Addend               <= i_Addend;
        r_ZmIsSigned           <= i_ZmIsSigned;
        r_ZnIsSigned           <= i_ZnIsSigned;
        r_Active_Element_A     <= i_Active_Element_A;
        r_Active_Element_B     <= i_Active_Element_B;
        r_Calculation_mode     <= i_Calculation_mode;
        r_Calculation_pricision<= i_Calculation_pricision;
        r_Num_of_Vector_Group  <= i_Num_of_Vector_Group;
        r_Operator             <= i_Operator;
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        Output <= 0;
    end else begin
        Output <= o_Output;
    end
end

IntMult_TOP u_IntMult_TOP(
    .i_operand1              (r_operand1),
    .i_operand2              (r_operand2),
    .i_ZmIsSigned            (r_ZmIsSigned),
    .i_ZnIsSigned            (r_ZnIsSigned),
    .i_Active_Element_A      (r_Active_Element_A),
    .i_Active_Element_B      (r_Active_Element_B),
    .i_Calculation_pricision (r_Calculation_pricision),
    .o_Product               (o_Product)
);

IntAdditionAarry u_IntAdditionAarry(
    .i_Product               (o_Product),
    .i_Addend                (r_Addend),
    .i_ZmIsSigned            (r_ZmIsSigned),
    .i_ZnIsSigned            (r_ZnIsSigned),
    .i_Calculation_mode      (r_Calculation_mode),
    .i_Num_of_Vector_Group   (r_Num_of_Vector_Group),
    .i_Calculation_pricision (r_Calculation_pricision),
    .i_Operator              (r_Operator),
    .o_Output                (o_Output)
);

endmodule