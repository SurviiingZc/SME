#ifndef PARAM_H
#define PARAM_H
//=====================================================================
// Description : Clock period
//=====================================================================
#define clock_period                0.8

//=====================================================================
// Description : Simulation method
//=====================================================================
#define VCS_FSDB
// #define FPGA

//=====================================================================
// Description : Current Exception Level
//=====================================================================
#define AArch64                     1
#define AArch32                     0

//=====================================================================
// Description : List of features to be supported
//=====================================================================
#define FEAT_SME                    1
#define FEAT_SME_F16F16             1 
#define FEAT_SME2                   1
// FEAT_AFP allows alternate behavior for specified floating-point instructions including:
// 1.Flushing of denormalized numbers to zero can be controlled separately on inputs and outputs.
// 2.Alternate NaN propagation rules and Default NaN values can apply.
// 3.Certain scalar SIMD and floating-point instructions can be configured to preserve higher numbered SIMD vector elements.
// 4.Changes to floating-point exception generation.
#define FEAT_AFP                    1
// FEAT_EBF16 supports the Extended BFloat16 mode. This feature is supported in AArch64 state only.
// Performing a fused two-way sum-of-products for each pair of adjacent BFloat16 elements, without intermediate rounding of the products,
// but rounding the single-precision sum before addition to the accumulator.
#define FEAT_EBF16                  1
#define FEAT_SME_FA64               0
#define FEAT_SME_F64F64             0
#define FEAT_SME_I16I64             0
#define FEAT_SME2p1                 0
#define FEAT_SVE2p1                 0
#define FEAT_SVE_B16B16             0

//=====================================================================
// Description : FPCR(Floating-point Control Register) register bit definition
//=====================================================================

// Alternative half-precision control bit (AHP)
#define IEEE_Half_Precision_Format                               0
#define Alternative_Half_Precision_Format                        1

// Default NaN use for NaN propagation (DN)
#define NaN_Propagate_Through_Floating_Point_Operation           0
#define Operation_Involving_NaNs_Returns_Default_NaN             1

// Flushing denormalized numbers to zero control bit (FZ)
#define Do_Not_Flush_Denormalized_Results_to_Zero                0
#define Flush_Denormalized_Results_to_Zero                       1

// Rounding mode control bits (RMode)
#define Round_to_Nearest_Mode                                    0
#define Round_Towards_Plus_Infinity                              1
#define Round_Towards_Minus_Infinity                             2
#define Round_Towards_Zero                                       3

// This field has no function in AArch64 state, Stride bits (Stride) 
#define Stride_1                                                 0
#define Stride_2                                                 1
#define Stride_4                                                 2
#define Stride_8                                                 3

// Flush-to-zero mode for half-precision (FZ16)
#define Do_Not_Flush_Denormalized_Results_to_Zero_Half           0
#define Flush_Denormalized_Results_to_Zero_Half                  1

// This field has no function in AArch64 state, Length of the vector (Len)
#define Length_1                                                 0
#define Length_2                                                 1
#define Length_4                                                 2
#define Length_8                                                 3

// Trap enable for input denormal (IDE)
#define Trap_Disabled_for_Input_Denormal                         0
#define Trap_Enabled_for_Input_Denormal                          1

// The value of this bit controls the numeric behaviors of BFloat16 dot product calculations (EBF)
#define Standard_BFloat16_Behaviors                              0
#define Extended_BFloat16_Behaviors                              1

// Trap enable for inexact result (IXE)
#define Trap_Disabled_for_Inexact_Result                         0
#define Trap_Enabled_for_Inexact_Result                          1

// Trap enable for underflow (UFE)
#define Trap_Disabled_for_Underflow                              0
#define Trap_Enabled_for_Underflow                               1

// Trap enable for overflow (OFE)
#define Trap_Disabled_for_Overflow                               0
#define Trap_Enabled_for_Overflow                                1

// Trap enable for divide-by-zero (DZE)
#define Trap_Disabled_for_Divide_by_Zero                         0
#define Trap_Enabled_for_Divide_by_Zero                          1

// Trap enable for invalid operation (IOE)
#define Trap_Disabled_for_Invalid_Operation                      0
#define Trap_Enabled_for_Invalid_Operation                       1

// Controls how the output elements other than the lowest element of the vector are determined for Advanced SIMD scalar instructions (NEP) 
#define Not_Affect_Output_Elements                               0
#define Affect_Output_Elements                                   1

// Alternate Handling. Controls alternate handling of floating-point numbers (AH)
#define IEEE_Handling_Floating_Point_Numbers                     0
#define Alternative_Handling_Floating_Point_Numbers              1

// Flush Inputs to Zero. Controls whether single-precision, double-precision and BFloat16 input operands that are denormalized numbers are flushed to zero (FIZ)
#define Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF         0
#define Flush_Denormalized_Results_to_Zero_S_D_BF                1

//=====================================================================
// Description : FPEXC (Floating-Point E1xception Control Register) register bit definition
//=====================================================================
// Exception bit (EX)
#define EX_Disabled                                              0
#define EX_Enabled                                               1

// Enables access to the Advanced SIMD and floating-point functionality from all Exception levels (EN)
#define Accesses_to_FPSCR_And_Any_SIMD_And_FP_Resister           0
#define Accesses_to_Advanced_SIMD_And_FP_Functionality           1

// Defined synchronous exception on floating-point execution (DEX)
#define Exception_Generated_by_Execution_of_Unallocated          0
#define Exception_Generated_during_Execution_of_Allocated        1

// FPINST2 instruction Valid bit (FP2V)
#define FPINST2_Instruction_Invalid                              0
#define FPINST2_Instruction_Valid                                1

// VECITR valid bit (VV)
#define VECITR_Invalid                                           0
#define VECITR_Valid                                             1

// Trapped Fault Valid bit (TFV)
#define Trapped_Fault_Invalid                                    0
#define Trapped_Fault_Valid                                      1

// Vector iteration count (VECITR)
#define Vector_iteration_0_count                                0
#define Vector_iteration_1_count                                1
#define Vector_iteration_2_count                                2
#define Vector_iteration_3_count                                3
#define Vector_iteration_4_count                                4
#define Vector_iteration_5_count                                5
#define Vector_iteration_6_count                                6
#define Vector_iteration_7_count                                7

// Input Denormal trapped exception bit (IDF). This bit must be cleared to 0 by the exception-handling routine.
#define Input_Denormal_Exception_Has_Not_Occurred                0
#define Input_Denormal_Exception_Has_Occurred                    1

// Inexact trapped exception bit (IXF). This bit must be cleared to 0 by the exception-handling routine.
#define Inexact_Exception_Has_Not_Occurred                       0
#define Inexact_Exception_Has_Occurred                           1

// Underflow trapped exception bit (UFF). This bit must be cleared to 0 by the exception-handling routine.
#define Underflow_Exception_Has_Not_Occurred                     0
#define Underflow_Exception_Has_Occurred                         1

// Overflow trapped exception bit (OFF). This bit must be cleared to 0 by the exception-handling routine.
#define Overflow_Exception_Has_Not_Occurred                      0
#define Overflow_Exception_Has_Occurred                          1

// Divide by Zero trapped exception bit (DZF). This bit must be cleared to 0 by the exception-handling routine.
#define Divide_by_Zero_Exception_Has_Not_Occurred                0
#define Divide_by_Zero_Exception_Has_Occurred                    1

// Invalid Operation trapped exception bit (IOF). This bit must be cleared to 0 by the exception-handling routine.
#define Invalid_Operation_Exception_Has_Not_Occurred             0
#define Invalid_Operation_Exception_Has_Occurred                 1

//=====================================================================
// Description : FPSR(Floating-point Status Register) register bit definition
//=====================================================================

// Negative condition flag for AArch32 floating-point comparison operations (N)

// Zero condition flag for AArch32 floating-point comparison operations (Z)

// Carry condition flag for AArch32 floating-point comparison operations (C)

// Overflow condition flag for AArch32 floating-point comparison operations (V)

// Cumulative saturation bit, Advanced SIMD only (QC)

// Input Denormal cumulative floating-point exception bit (IDC). This bit is set to 1 to indicate that the Input Denormal floating-point exception has occurred since 0 was last written to this bit.
#define Input_Denormal_Cumulative_Exception_Has_Not_Occurred     0
#define Input_Denormal_Cumulative_Exception_Has_Occurred         1

// Inexact cumulative floating-point exception bit (IXC). This bit is set to 1 to indicate that the Inexact floating-point exception has occurred since 0 was last written to this bit.
#define Inexact_Cumulative_Exception_Has_Not_Occurred            0
#define Inexact_Cumulative_Exception_Has_Occurred                1

// Underflow cumulative floating-point exception bit (UFC). This bit is set to 1 to indicate that the Underflow floating-point exception has occurred since 0 was last written to this bit.
#define Underflow_Cumulative_Exception_Has_Not_Occurred          0
#define Underflow_Cumulative_Exception_Has_Occurred              1

// Overflow cumulative floating-point exception bit (OFC). This bit is set to 1 to indicate that the Overflow floating-point exception has occurred since 0 was last written to this bit.
#define Overflow_Cumulative_Exception_Has_Not_Occurred           0
#define Overflow_Cumulative_Exception_Has_Occurred               1

// Divide by Zero cumulative floating-point exception bit (DZC). This bit is set to 1 to indicate that the Divide by Zero floating-point exception has occurred since 0 was last written to this bit.
#define Divide_by_Zero_Cumulative_Exception_Has_Not_Occurred     0
#define Divide_by_Zero_Cumulative_Exception_Has_Occurred         1

// Invalid Operation cumulative floating-point exception bit (DZC). This bit is set to 1 to indicate that the Invalid Operation floating-point exception has occurred since 0 was last written to this bit.
#define Invalid_Operation_Cumulative_Exception_Has_Not_Occurred  0
#define Invalid_Operation_Cumulative_Exception_Has_Occurred      1

//=====================================================================
// Description : SME/PE Operation defination
//=====================================================================
// Calculation mode signal
#define Inner_Product                    0
#define Outer_Product                    1
// Calculation precision
#define INT32                            6
#define FP32                             0
#define FP16                             1
#define INT16                            2
#define BF16                             3
#define INT8                             4
#define FP8                              5
// Widening signal
#define Operands_Is_Not_Widening         0
#define Operands_Is_Widening             1
// Addition or subtraction indication signal
#define Subtraction_Operation            0
#define Addition_Operation               1
//The signed indication signal for the value in the Zm register.
#define Zm_Is_Unsigned                   0
#define Zm_Is_Signed                     1
//The signed indication signal for the value in the Zn register.
#define Zn_Is_Unsigned                   0
#define Zn_Is_Signed                     1
//This signal indicates the number of vector groups and is only valid in the inner product mode.
#define Two_Vector_Group                 0
#define Four_Vector_Group                1
//This signal indicates the number of vectors in a vector group.
#define Single_Vector_Group              0
#define Double_Vector_Group              1
#define Quad_Vector_Group                2
//Whether activation sites are generated randomly.
// #define Randomly_Generate_Activation_Bits             
#define Generate_Fixed_Activation_Bits             

//=====================================================================
// Description : FPType
//=====================================================================
#define FPType_Zero                      0
#define FPType_Denormal                  1
#define FPType_Nonzero                   2
#define FPType_Infinity                  3
#define FPType_QNaN                      4
#define FPType_SNaN                      5

//=====================================================================
// Description : FPExc
//=====================================================================
#define FPExc_InvalidOp                  0
#define FPExc_DivideByZero               1
#define FPExc_Overflow                   2
#define FPExc_Underflow                  3
#define FPExc_Inexact                    4
#define FPExc_InputDenorm                5
#define FPExc_None                       6

// #define FPExc_None_Report               6'b000000
// #define FPExc_InvalidOp_Report          6'b000001
// #define FPExc_DivideByZero_Report       6'b000010
// #define FPExc_Overflow_Report           6'b000100
// #define FPExc_Underflow_Report          6'b001000
// #define FPExc_Inexact_Report            6'b010000
// #define FPExc_InputDenorm_Report        6'b100000


//=====================================================================
// Description : BF_Data_Width
//=====================================================================
#define BF_Data_Width_16                 16
#define BF_Data_Width_32                 32

//=====================================================================
// Description : C_ref_model_parameter
//=====================================================================
#define INT_CALC                        0

#define FMOPA                           1
#define FMOPS                           2
#define FMOPA_W                         3
#define FMOPS_W                         4  
#define BFMOPA                          5
#define BFMOPS                          6
#define FDOT                            7
#define FMLA                            8
#define FMLAL                           9                       

#endif