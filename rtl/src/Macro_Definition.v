//=====================================================================
// Description : Clock period
//=====================================================================
`define clock_period                5

//=====================================================================
// Description : Simulation method
//=====================================================================
// `define VCS_FSDB
// `define FPGA
`define Is_PipLine
`define FPMultiplication_Verification
`define First_Level_FPAdd_Verification
`define Second_Level_FPAdd_Verification
`define Final_Result_Verification

//=====================================================================
// Description : Current Exception Level
//=====================================================================
`define AArch64                     1
`define AArch32                     0

//=====================================================================
// Description : List of features to be supported
//=====================================================================
`define FEAT_SME                    1
`define FEAT_SME_F16F16             1 
`define FEAT_SME2                   1
// FEAT_AFP allows alternate behavior for specified floating-point instructions including:
// 1.Flushing of denormalized numbers to zero can be controlled separately on inputs and outputs.
// 2.Alternate NaN propagation rules and Default NaN values can apply.
// 3.Certain scalar SIMD and floating-point instructions can be configured to preserve higher numbered SIMD vector elements.
// 4.Changes to floating-point exception generation.
`define FEAT_AFP                    1
// FEAT_EBF16 supports the Extended BFloat16 mode. This feature is supported in AArch64 state only.
// Performing a fused two-way sum-of-products for each pair of adjacent BFloat16 elements, without intermediate rounding of the products,
// but rounding the single-precision sum before addition to the accumulator.
`define FEAT_EBF16                  1
`define FEAT_SME_FA64               0
`define FEAT_SME_F64F64             0
`define FEAT_SME_I16I64             0
`define FEAT_SME2p1                 0
`define FEAT_SVE2p1                 0
`define FEAT_SVE_B16B16             0

//=====================================================================
// Description : FPCR(Floating-point Control Register) register bit definition
//=====================================================================

// Alternative half-precision control bit (AHP)
`define IEEE_Half_Precision_Format                              1'd0
`define Alternative_Half_Precision_Format                       1'd1

// Default NaN use for NaN propagation (DN)
`define NaN_Propagate_Through_Floating_Point_Operation          1'd0
`define Operation_Involving_NaNs_Returns_Default_NaN            1'd1

// Flushing denormalized numbers to zero control bit (FZ)
`define Do_Not_Flush_Denormalized_Results_to_Zero               1'd0
`define Flush_Denormalized_Results_to_Zero                      1'd1

// Rounding mode control bits (RMode)
`define Round_to_Nearest_Mode                                   2'd0
`define Round_Towards_Plus_Infinity                             2'd1
`define Round_Towards_Minus_Infinity                            2'd2
`define Round_Towards_Zero                                      2'd3

// This field has no function in AArch64 state, Stride bits (Stride) 
`define Stride_1                                                2'd0
`define Stride_2                                                2'd1
`define Stride_4                                                2'd2
`define Stride_8                                                2'd3

// Flush-to-zero mode for half-precision (FZ16)
`define Do_Not_Flush_Denormalized_Results_to_Zero_Half          1'd0
`define Flush_Denormalized_Results_to_Zero_Half                 1'd1

// This field has no function in AArch64 state, Length of the vector (Len)
`define Length_1                                                2'd0
`define Length_2                                                2'd1
`define Length_4                                                2'd2
`define Length_8                                                2'd3

// Trap enable for input denormal (IDE)
`define Trap_Disabled_for_Input_Denormal                        1'd0
`define Trap_Enabled_for_Input_Denormal                         1'd1

// The value of this bit controls the numeric behaviors of BFloat16 dot product calculations (EBF)
`define Standard_BFloat16_Behaviors                             1'd0
`define Extended_BFloat16_Behaviors                             1'd1

// Trap enable for inexact result (IXE)
`define Trap_Disabled_for_Inexact_Result                        1'd0
`define Trap_Enabled_for_Inexact_Result                         1'd1

// Trap enable for underflow (UFE)
`define Trap_Disabled_for_Underflow                             1'd0
`define Trap_Enabled_for_Underflow                              1'd1

// Trap enable for overflow (OFE)
`define Trap_Disabled_for_Overflow                              1'd0
`define Trap_Enabled_for_Overflow                               1'd1

// Trap enable for divide-by-zero (DZE)
`define Trap_Disabled_for_Divide_by_Zero                        1'd0
`define Trap_Enabled_for_Divide_by_Zero                         1'd1

// Trap enable for invalid operation (IOE)
`define Trap_Disabled_for_Invalid_Operation                     1'd0
`define Trap_Enabled_for_Invalid_Operation                      1'd1

// Controls how the output elements other than the lowest element of the vector are determined for Advanced SIMD scalar instructions (NEP) 
`define Not_Affect_Output_Elements                              1'd0
`define Affect_Output_Elements                                  1'd1

// Alternate Handling. Controls alternate handling of floating-point numbers (AH)
`define IEEE_Handling_Floating_Point_Numbers                    1'd0
`define Alternative_Handling_Floating_Point_Numbers             1'd1

// Flush Inputs to Zero. Controls whether single-precision, double-precision and BFloat16 input operands that are denormalized numbers are flushed to zero (FIZ)
`define Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF        1'd0
`define Flush_Denormalized_Results_to_Zero_S_D_BF               1'd1

//=====================================================================
// Description : SME/PE Operation defination
//=====================================================================
// Calculation mode signal
`define Inner_Product                   1'd0
`define Outer_Product                   1'd1
// Calculation precision
`define INT32                           3'd6
`define FP32                            3'd0
`define FP16                            3'd1
`define INT16                           3'd2
`define BF16                            3'd3
`define INT8                            3'd4
`define FP8                             3'd5
`define FP16_4                          3'd7
// Widening signal
`define Operands_Is_Not_Widening        1'd0
`define Operands_Is_Widening            1'd1
// Addition or subtraction indication signal
`define Subtraction_Operation           1'd0
`define Addition_Operation              1'd1
//The signed indication signal for the value in the Zm register.
`define Zm_Is_Unsigned                  1'd0
`define Zm_Is_Signed                    1'd1
//The signed indication signal for the value in the Zn register.
`define Zn_Is_Unsigned                  1'd0
`define Zn_Is_Signed                    1'd1
//This signal indicates the number of vector groups and is only valid in the inner product mode.
`define Two_Vector_Group                1'd0
`define Four_Vector_Group               1'd1
//This signal indicates the number of vectors in a vector group.
`define Single_Vector_Group             2'd0
`define Double_Vector_Group             2'd1
`define Quad_Vector_Group               2'd2
//Whether activation sites are generated randomly.
// `define Randomly_Generate_Activation_Bits             
`define Generate_Fixed_Activation_Bits             

//=====================================================================
// Description : FPType
//=====================================================================
`define FPType_Nonzero                  3'd0
`define FPType_Denormal                 3'd1
`define FPType_Zero                     3'd2
`define FPType_Infinity                 3'd3
`define FPType_QNaN                     3'd4
`define FPType_SNaN                     3'd5

//=====================================================================
// Description : FPExc
//=====================================================================
`define FPExc_InvalidOp                 3'd0
`define FPExc_DivideByZero              3'd1
`define FPExc_Overflow                  3'd2
`define FPExc_Underflow                 3'd3
`define FPExc_Inexact                   3'd4
`define FPExc_InputDenorm               3'd5
`define FPExc_None                      3'd6

`define FPExc_None_Report               6'b000000
`define FPExc_InvalidOp_Report          6'b000001
`define FPExc_DivideByZero_Report       6'b000010
`define FPExc_Overflow_Report           6'b000100
`define FPExc_Underflow_Report          6'b001000
`define FPExc_Inexact_Report            6'b010000
`define FPExc_InputDenorm_Report        6'b100000

//=====================================================================
// Description : BF_Data_Width
//=====================================================================
`define BF_Data_Width_16                6'd16
`define BF_Data_Width_32                6'd32

