`timescale 1ns/1ps
`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif
module IntAdditionAarry(
    input                   [63:0]  i_Product,  
    input                   [127:0] i_Addend,    
    input                           i_ZmIsSigned,       // 0 -> unsigned ; 1 -> signed Zm
    input                           i_ZnIsSigned,       // 0 -> unsigned ; 1 -> signed Zn 
    input                           i_Calculation_mode, // 0 -> Inner_Product ; 1 -> Outer_Product
    input                           i_Num_of_Vector_Group,   // 0 -> Single_Vector_Group ; 1 -> Double_Vector_Group ; 2 -> Quad_Vector_Group
    input                   [2:0]   i_Calculation_pricision, // 6 -> INT32 ; 2 -> INT16 ; 4 -> INT8
    input                           i_Operator,         // 0 -> Subtraction_Operation ; 1 -> Addition_Operation 
    output reg              [127:0] o_Output     
);
wire        [31:0] o_Sum_0 , o_Sum_1 , o_Sum_2 , o_Sum_3, o_Sum_4 , o_Sum_5 , o_Sub , o_Sum_outer,o_Sum_SingleGroup;
wire               signflag = (i_ZmIsSigned) | (i_ZnIsSigned);
// Int8*Int8 product
wire        [15:0] result           [0:3];
wire signed [31:0] ext_result       [0:3];
wire signed [32:0] ext_result_int16 [0:1];
wire        [31:0] o_Sum            [0:3];
wire        [31:0] o_Sum_Int16      [0:1];
wire        [31:0] addend_select    [0:1];
genvar i,j;

generate
    // int8 product result split 
    for (i = 0; i < 4; i = i + 1) begin : assign_results       
        assign result[i] = i_Product[i*16+:16]                                                  ;
        assign ext_result[i] = signflag ? {{16{result[i][15]}}, result[i]} : {16'b0, result[i]} ;
    end
    // int16 product result split
    for (j = 0; j < 2; j = j + 1) begin : gen_ext_result_int16
        assign ext_result_int16[j] = signflag ? {i_Product[j*32+31], i_Product[j*32 +: 32]} : {1'b0, i_Product[j*32 +: 32]};
    end
endgenerate

// Sum of Int8*Int8 product
wire signed [31:0] sum_temp_int8  = ext_result[0] + ext_result[1] + ext_result[2] + ext_result[3]     ;
wire signed [32:0] sum_temp_int16 = ext_result_int16[0] + ext_result_int16[1]                         ;
// Int16 num of vector group
assign addend_select[0] = i_Addend[31:0];
assign addend_select[1] = (i_Num_of_Vector_Group == `Four_Vector_Group) ? i_Addend[63:32] : i_Addend[31:0];

// output concatenation​
wire        [127:0] inner_int8_sum          =  { o_Sum[0], o_Sum[1], o_Sum[2], o_Sum[3]}                            ;
wire        [127:0] inner_int16_DoubleGroup =  { o_Sum_Int16[0] , o_Sum_Int16[1] , o_Sum_Int16[0] , o_Sum_Int16[1]} ;
wire        [127:0] inner_int16_SingleGroup =  {4{o_Sum_SingleGroup}}                                               ;
wire        [127:0] inner_int32_sum         =  { o_Sum_Int16[0] , o_Sum_Int16[0] , o_Sum_Int16[0] , o_Sum_Int16[0]} ;
wire        [127:0] outer_sum               =  { o_Sum_outer , o_Sum_outer , o_Sum_outer , o_Sum_outer}             ;
wire        [127:0] outer_sub               =  { o_Sub , o_Sub , o_Sub , o_Sub }                                    ;

always @(*) begin
    if (i_Calculation_mode == `Outer_Product) begin
        if (i_Operator == `Addition_Operation) begin
            o_Output = outer_sum;
        end else begin
            o_Output = outer_sub;
        end
    end else begin
        if (i_Calculation_pricision == `INT8) begin
            o_Output = inner_int8_sum;
        end else if (i_Calculation_pricision == `INT16 && i_Num_of_Vector_Group == `Four_Vector_Group) begin
            o_Output = inner_int16_DoubleGroup;
        end else if (i_Calculation_pricision == `INT16 && i_Num_of_Vector_Group == `Two_Vector_Group) begin
            o_Output = inner_int16_SingleGroup;
        end else begin
            o_Output = inner_int32_sum;
        end
    end
end

generate
    for (i = 0; i < 4; i = i + 1) begin : gen_IntAddition       
        IntAddition u_IntAddition(
            .product  ( ext_result[i]          ),
            .i_Addend ( i_Addend[i * 32 +: 32] ), 
            .o_Sum    ( o_Sum[i]               )
        );
    end

    for (j = 0; j < 2; j = j + 1 )begin : gen_Int16Addition
        Int16Addition u_Int16Addition(
            .i_Product ( ext_result_int16[j] ),
            .i_Addend  ( addend_select[j]    ),
            .o_Sum     ( o_Sum_Int16[j]      )
        );
    end
endgenerate

Int16Addition u_Int16Addition_SingleGroup(
            .i_Product ( sum_temp_int16      ),
            .i_Addend  ( addend_select[0]    ),
            .o_Sum     ( o_Sum_SingleGroup   )
        );

IntAddition u_IntAddition_outer(
    .product  ( sum_temp_int8  ),
    .i_Addend ( i_Addend[31:0] ),
    .o_Sum    ( o_Sum_outer    )
);

IntSubtraction u_IntSubtraction_outer(
    .product  ( sum_temp_int8  ),
    .i_Addend ( i_Addend[31:0] ),
    .o_Sub    ( o_Sub    )
);

 
endmodule