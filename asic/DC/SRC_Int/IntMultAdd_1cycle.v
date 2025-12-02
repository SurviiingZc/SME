module IntMultAdd_1cycle(
    input  [31:0]        i_operand1             ,     
    input  [31:0]        i_operand2             ,   
    input  [127:0]       i_Addend               ,      
    input                i_ZmIsSigned           , // 0 -> unsigned 1 -> signed Zm 
    input                i_ZnIsSigned           , // 0 -> unsigned 1 -> signed Zn 
    input  [3:0]         i_Active_Element_A     ,
    input  [3:0]         i_Active_Element_B     ,
    input                i_Calculation_mode     , // 0 -> Inner_Product ; 1 -> Outer_Product
    input  [2:0]         i_Calculation_pricision,
    input                i_Num_of_Vector_Group  , // 0 -> Single_Vector_Group ; 1 -> Double_Vector_Group ; 2 -> Quad_Vector_Group
    input                i_Operator             , // 0 -> Subtraction_Operation ; 1 -> Addition_Operation 
    output [127:0]       o_Output     
);
    wire   [63:0]        o_Product;
    IntMult_TOP u_IntMult_TOP(
    .i_operand1              ( i_operand1              ),
    .i_operand2              ( i_operand2              ),
    .i_ZmIsSigned            ( i_ZmIsSigned            ),
    .i_ZnIsSigned            ( i_ZnIsSigned            ),
    .i_Active_Element_A      ( i_Active_Element_A      ),
    .i_Active_Element_B      ( i_Active_Element_B      ),
    .i_Calculation_pricision ( i_Calculation_pricision ),
    .o_Product               ( o_Product               )
);
    IntAdditionAarry u_IntAdditionAarry(
    .i_Product               ( o_Product               ),
    .i_Addend                ( i_Addend                ),
    .i_ZmIsSigned            ( i_ZmIsSigned            ),
    .i_ZnIsSigned            ( i_ZnIsSigned            ),
    .i_Calculation_mode      ( i_Calculation_mode      ),
    .i_Num_of_Vector_Group   ( i_Num_of_Vector_Group   ),
    .i_Calculation_pricision ( i_Calculation_pricision ),
    .i_Operator              ( i_Operator              ),
    .o_Output                ( o_Output                )
);

endmodule