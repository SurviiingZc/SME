// `include "macro_definition.svh"
// `include "uvm_macros.svh"

// class PE_sequence_fmops extends PE_sequence;
//     `uvm_object_utils(PE_sequence_fmops)

//     function new(string name = "PE_sequence_fmops");
//         super.new(name);
//     endfunction
    
//     task body();
//         PE_seq_item tr;
//         int i;
//         if (starting_phase != null)
//             starting_phase.raise_objection(this);
//         for(i = 0; i < 8000; i++)begin
//             `uvm_info("SEQ", $sformatf("This is%d test", i), UVM_LOW)
//             tr = PE_seq_item::type_id::create("tr");

//             start_item(tr);
//             if (!tr.randomize() with {
//                 tr.i_Compute_Mode               ==  `Outer_Product;
//                 tr.i_Compute_Precision          ==  `FP16; //inside  {`FP32, `FP16};
//                 tr.i_Is_Widening                ==  `Operands_Is_Not_Widening;
//                 tr.i_Add_or_Subtract            ==  `Subtraction_Operation;
//                 //tr.i_ZmIsSigned                 ==  `Zm_Is_Unsigned;
//                 //tr.i_ZnIsSigned                 ==  `Zn_Is_Unsigned;
//                 //tr.i_Num_of_Vector_Group        ==  `Two_Vector_Group;      
//                 //tr.i_Vector_Group_Num           ==  `Single_Vector_Group;
//                 tr.i_Active_Element_A           ==  4'b1111;
//                 tr.i_Active_Element_B           ==  4'b1111;
//                 tr.i_ZA_Base_Address            ==  32'hffff;
//                 tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;// Alternative_Half_Precision_Format IEEE_Half_Precision_Format
//                 tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
//                 tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;// Flush_Denormalized_Results_to_Zero Do_Not_Flush_Denormalized_Results_to_Zero
//                 tr.i_Exception_Handling[16:15]  == `Round_Towards_Zero; // Round_Towards_Plus_Infinity Round_Towards_Minus_Infinity Round_Towards_Zero Round_to_Nearest_Mode         
//                 tr.i_Exception_Handling[14:13]  == `Stride_1;
//                 tr.i_Exception_Handling[12]     == `Do_Not_Flush_Denormalized_Results_to_Zero_Half;// Flush_Denormalized_Results_to_Zero_Half Do_Not_Flush_Denormalized_Results_to_Zero_Half
//                 tr.i_Exception_Handling[11:10]  == `Length_1;
//                 tr.i_Exception_Handling[9]      == `Trap_Disabled_for_Input_Denormal;
//                 tr.i_Exception_Handling[8]      == `Standard_BFloat16_Behaviors;
//                 tr.i_Exception_Handling[7]      == `Trap_Disabled_for_Inexact_Result;
//                 tr.i_Exception_Handling[6]      == `Trap_Disabled_for_Underflow;
//                 tr.i_Exception_Handling[5]      == `Trap_Disabled_for_Overflow;
//                 tr.i_Exception_Handling[4]      == `Trap_Disabled_for_Divide_by_Zero;
//                 tr.i_Exception_Handling[3]      == `Trap_Disabled_for_Invalid_Operation;
//                 tr.i_Exception_Handling[2]      == `Not_Affect_Output_Elements;
//                 tr.i_Exception_Handling[1]      == `IEEE_Handling_Floating_Point_Numbers;
//                 tr.i_Exception_Handling[0]      == `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF;
//                 // tr.i_Operand_C[127:32]          == 96'b0;
//                 // tr.i_Operand_A[31:0] == 31'h1a5c1adb;
//                 // tr.i_Operand_B[31:0] == 31'h1e5ebedb;
//                 // tr.i_Operand_C[31:0] == 31'h3e5ebfff;
//                 if(i_Compute_Precision == `FP32) {
//                     tr.i_Operand_A[31:0] == 32'h40000001;
//                     tr.i_Operand_B[31:0] == 32'h00000041;
//                     tr.i_Operand_C[31:0] == 32'h00090221;
//                     tr.i_Operand_C[127:32] == 96'b0;

//                     // tr.i_Operand_A[31:0] == gen_a;
//                     // tr.i_Operand_B[31:0] == gen_b;
//                     // tr.i_Operand_C[31:0] == gen_c;
//                     // tr.i_Operand_C[127:32] == 96'b0;
//                 }
//                 else if(i_Compute_Precision == `FP16) {
//                     // 对于其他精度，保持完全随机
//                     tr.i_Operand_A[31:16] inside {[16'h0000:16'hffff]};
//                     tr.i_Operand_B[31:16] inside {[16'h0000:16'hffff]};
//                     tr.i_Operand_A[15:0] inside {[16'h0000:16'hffff]};
//                     tr.i_Operand_B[15:0] inside {[16'h0000:16'hffff]};
//                     tr.i_Operand_C[31:16]== 16'd0;
//                     tr.i_Operand_C[63:48]== 16'd0;
//                     tr.i_Operand_C[95:80]== 16'd0; 
//                     tr.i_Operand_C[127:112]== 16'd0;                      
//                 }
//                 // i_Operand_A[31:0] dist {
//                 //     [32'h00800001:32'h7fffffff] :/ 50,
//                 //     [32'h80800001:32'hffffffff] :/ 50
//                 // };

//                 // i_Operand_B[31:0] dist {
//                 //     [32'h00800001:32'h3fffffff] :/ 50,
//                 //     [32'h80800001:32'hbfffffff] :/ 50
//                 // };

//                 // i_Operand_C[31:0] dist {
//                 //     [32'h00800001:32'h3fffffff] :/ 50,
//                 //     [32'h80800001:32'hbfffffff] :/ 50
//                 // };
                
//                 // i_Exception_Handling[16:15] dist {
//                 //     2'b00 := 25,
//                 //     2'b01 := 25,
//                 //     2'b10 := 25,
//                 //     2'b11 :/ 25 
//                 // };
//             }) begin
//                `uvm_error("RND", "Randomization failed")
//             end
            
//             finish_item(tr);
//         end
//         // 序列完成后drop objection
//         if (starting_phase != null) begin
//             starting_phase.drop_objection(this);
//         end

//         `uvm_info("SEQ", "Sequence completed", UVM_LOW)
//     endtask
// endclass


`include "macro_definition.svh"
`include "uvm_macros.svh"

class PE_sequence_fmops extends PE_sequence;
    `uvm_object_utils(PE_sequence_fmops)

    function new(string name = "PE_sequence_fmsub");
        super.new(name);
    endfunction

    typedef enum bit [3:0] {
        SC_RANDOM          = 0, 
        SC_NAN_INPUT       = 1, 
        SC_INVALID_MUL     = 2, 
        SC_INVALID_ADD     = 3, 
        SC_INF_GEN         = 4, 
        SC_INF_OPERAND     = 5, 
        SC_INF_SAME_SIGN   = 6, 
        SC_EXACT_CANCEL    = 7, 
        SC_ZERO_ADD        = 8, 
        SC_TINY_FMA        = 9, 
        SC_ROUNDING_EDGE   = 10,
        SC_1_2_3           = 11
    } scenario_e;

    const bit [7:0] FP32_EXP_ONES = 8'hFF;
    const bit [4:0] FP16_EXP_ONES = 5'h1F;

    task body();
        PE_seq_item tr;
        scenario_e current_scenario;
        int i;
        int tiny_sub_case;   
        int round_sub_case;

        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for(i = 0; i < 30000; i++) begin
            tr = PE_seq_item::type_id::create("tr");
            start_item(tr);

            // 1. 场景随机化
            if (!std::randomize(current_scenario) with {
                current_scenario dist {
                    SC_RANDOM        := 20,
                    SC_NAN_INPUT     := 5,
                    SC_INVALID_MUL   := 5,
                    SC_INVALID_ADD   := 5,
                    SC_INF_GEN       := 5,
                    SC_INF_OPERAND   := 5,
                    SC_INF_SAME_SIGN := 5,
                    SC_EXACT_CANCEL  := 5,
                    SC_ZERO_ADD      := 5,
                    SC_TINY_FMA      := 20,
                    SC_ROUNDING_EDGE := 20,
                    SC_1_2_3         := 0
                };
            }) begin
                `uvm_error("SEQ", "Scenario randomization failed")
            end
            
            // 2. 子场景随机化
            void'(std::randomize(tiny_sub_case) with { tiny_sub_case dist { 0:=25, 1:=75 }; });
            void'(std::randomize(round_sub_case) with { round_sub_case dist { 0:=40, 1:=40, 2:=20 }; });
            
            `uvm_info("SEQ", $sformatf("Loop %0d: Scenario: %s (FMS)", i, current_scenario.name()), UVM_HIGH)

            if (!tr.randomize() with {
                tr.i_Compute_Mode               == `Outer_Product;
                tr.i_Is_Widening                == `Operands_Is_Not_Widening;
                tr.i_Add_or_Subtract            == `Subtraction_Operation; 
                
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                
                tr.i_Compute_Precision          == `FP32;
                tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;// Alternative_Half_Precision_Format IEEE_Half_Precision_Format
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Flush_Denormalized_Results_to_Zero;// Flush_Denormalized_Results_to_Zero Do_Not_Flush_Denormalized_Results_to_Zero
                // i_Exception_Handling[16:15] dist {
                //     2'b00 := 25,
                //     2'b01 := 25,
                //     2'b10 := 25,
                //     2'b11 :/ 25 
                // };
                tr.i_Exception_Handling[16:15]  == `Round_to_Nearest_Mode; // Round_Towards_Plus_Infinity Round_Towards_Minus_Infinity Round_Towards_Zero Round_to_Nearest_Mode         
                tr.i_Exception_Handling[14:13]  == `Stride_1;
                tr.i_Exception_Handling[12]     == `Do_Not_Flush_Denormalized_Results_to_Zero_Half;// Flush_Denormalized_Results_to_Zero_Half Do_Not_Flush_Denormalized_Results_to_Zero_Half
                tr.i_Exception_Handling[11:10]  == `Length_1;
                tr.i_Exception_Handling[9]      == `Trap_Disabled_for_Input_Denormal;
                tr.i_Exception_Handling[8]      == `Standard_BFloat16_Behaviors;
                tr.i_Exception_Handling[7]      == `Trap_Disabled_for_Inexact_Result;
                tr.i_Exception_Handling[6]      == `Trap_Disabled_for_Underflow;
                tr.i_Exception_Handling[5]      == `Trap_Disabled_for_Overflow;
                tr.i_Exception_Handling[4]      == `Trap_Disabled_for_Divide_by_Zero;
                tr.i_Exception_Handling[3]      == `Trap_Disabled_for_Invalid_Operation;
                tr.i_Exception_Handling[2]      == `Not_Affect_Output_Elements;
                tr.i_Exception_Handling[1]      == `IEEE_Handling_Floating_Point_Numbers;
                tr.i_Exception_Handling[0]      == `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF;

               
                if (current_scenario == SC_ROUNDING_EDGE) {

                    if (tr.i_Compute_Precision == `FP32) {
                        tr.i_Operand_C[127:32] == 96'b0;
                        i_Operand_A[30:23] inside {[50:100]}; 
                        i_Operand_B[30:23] inside {[50:100]};
                        
                        if (round_sub_case == 0) { // Tie Case
                            (int'(i_Operand_C[30:23]) + 127) == (int'(i_Operand_A[30:23]) + int'(i_Operand_B[30:23]) + 24);
                            i_Operand_C[0] == 1'b0; 
                        }
                        else if (round_sub_case == 1) { // Sticky Case
                            (int'(i_Operand_C[30:23]) + 127) > (int'(i_Operand_A[30:23]) + int'(i_Operand_B[30:23]) + 25);
                            (int'(i_Operand_C[30:23]) + 127) < (int'(i_Operand_A[30:23]) + int'(i_Operand_B[30:23]) + 60);
                        }
                        else { // 1.0 ULP Case
                            (int'(i_Operand_C[30:23]) + 127) == (int'(i_Operand_A[30:23]) + int'(i_Operand_B[30:23]) + 23);
                        }
                    } 
                    else { // FP16
                        tr.i_Operand_C[31:16]== 0; tr.i_Operand_C[127:32]== 0;
                        i_Operand_A[14:10] inside {[5:12]}; i_Operand_B[14:10] inside {[5:12]};

                        if (round_sub_case == 0) { // Tie Case
                            (int'(i_Operand_C[14:10]) + 15) == (int'(i_Operand_A[14:10]) + int'(i_Operand_B[14:10]) + 11);
                            i_Operand_C[0] == 1'b0;
                        }
                        else if (round_sub_case == 1) { // Sticky Case
                            (int'(i_Operand_C[14:10]) + 15) > (int'(i_Operand_A[14:10]) + int'(i_Operand_B[14:10]) + 12);
                            (int'(i_Operand_C[14:10]) + 15) < (int'(i_Operand_A[14:10]) + int'(i_Operand_B[14:10]) + 25);
                        }
                        else { // 1.0 ULP
                            (int'(i_Operand_C[14:10]) + 15) == (int'(i_Operand_A[14:10]) + int'(i_Operand_B[14:10]) + 10);
                        }
                        i_Operand_A[30:16] != 0; i_Operand_B[30:16] != 0;
                    }
                }
                
                if (tr.i_Compute_Precision == `FP32 && current_scenario != SC_ROUNDING_EDGE) {
                    tr.i_Operand_C[127:32] == 96'b0;

                    if (current_scenario == SC_NAN_INPUT) {
                        (i_Operand_A[30:23] == FP32_EXP_ONES && i_Operand_A[22:0] != 0) ||
                        (i_Operand_B[30:23] == FP32_EXP_ONES && i_Operand_B[22:0] != 0) ||
                        (i_Operand_C[30:23] == FP32_EXP_ONES && i_Operand_C[22:0] != 0);
                    }
                    if (current_scenario == SC_INVALID_MUL) { 
                        ((i_Operand_A[30:0] == 0) && (i_Operand_B[30:23] == FP32_EXP_ONES && i_Operand_B[22:0] == 0)) ||
                        ((i_Operand_B[30:0] == 0) && (i_Operand_A[30:23] == FP32_EXP_ONES && i_Operand_A[22:0] == 0));
                    }
                    
                    // FMS: P - C. 要产生 NaN, 必须是 Inf - Inf.
                    // 所以 A*B 和 C 必须 同号
                    if (current_scenario == SC_INVALID_ADD) { 
                        (i_Operand_A[30:23] == FP32_EXP_ONES && i_Operand_A[22:0] == 0); // A=Inf
                        (i_Operand_B == 32'h3F800000); // B=1.0
                        (i_Operand_C[30:23] == FP32_EXP_ONES && i_Operand_C[22:0] == 0); // C=Inf
                        i_Operand_A[31] == i_Operand_C[31]; // 符号相同 (Inf - Inf)
                    }

                    if (current_scenario == SC_INF_GEN) {
                        i_Operand_A[30:23] inside {[200:254]}; i_Operand_B[30:23] inside {[200:254]}; 
                    }
                    if (current_scenario == SC_INF_OPERAND) {
                        i_Operand_A[30:23] < 127; i_Operand_B[30:23] < 127;
                        i_Operand_C[30:23] == FP32_EXP_ONES && i_Operand_C[22:0] == 0; 
                    }
                    
                    // FMS: P - C = 0 -> P = C
                    // 所以 P 和 C 必须 同号且相等
                    if (current_scenario == SC_EXACT_CANCEL) {
                        i_Operand_A == 32'h40000000; // +2.0
                        i_Operand_B == 32'h40000000; // +2.0
                        i_Operand_C == 32'h41000000; // +4.0 
                    }
                    
                    if (current_scenario == SC_TINY_FMA) {
                        i_Operand_C[30:23] inside {[100:150]}; 
                        if (tiny_sub_case == 0) { 
                            i_Operand_A[30:23] inside {[1:60]}; i_Operand_B[30:23] inside {[1:60]}; 
                            (int'(i_Operand_A[30:23]) + int'(i_Operand_B[30:23])) <= 127;
                        } else { 
                            i_Operand_A[30:23] == 0; i_Operand_B[30:23] inside {[0:5]}; 
                            i_Operand_A[22:5] == 0; i_Operand_A[4:0]  != 0; 
                        }
                    }
                }

                else if (tr.i_Compute_Precision == `FP16 && current_scenario != SC_ROUNDING_EDGE) {
                    tr.i_Operand_A[31:16] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_B[31:16] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_A[15:0] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_B[15:0] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_C[31:16]== 16'd0;
                    tr.i_Operand_C[63:48]== 16'd0;
                    tr.i_Operand_C[95:80]== 16'd0; 
                    tr.i_Operand_C[127:112]== 16'd0;

                    if (current_scenario == SC_NAN_INPUT) {
                        (i_Operand_A[14:10] == FP16_EXP_ONES && i_Operand_A[9:0] != 0) ||
                        (i_Operand_B[14:10] == FP16_EXP_ONES && i_Operand_B[9:0] != 0) ||
                        (i_Operand_C[14:10] == FP16_EXP_ONES && i_Operand_C[9:0] != 0);
                        i_Operand_A[30:26] dist { FP16_EXP_ONES :/ 10, [0:30] :/ 90 };
                        i_Operand_B[30:26] dist { FP16_EXP_ONES :/ 10, [0:30] :/ 90 };
                    }
                    if (current_scenario == SC_INVALID_MUL) {
                        ((i_Operand_A[14:0] == 0) && (i_Operand_B[14:10] == FP16_EXP_ONES && i_Operand_B[9:0] == 0)) ||
                        ((i_Operand_B[14:0] == 0) && (i_Operand_A[14:10] == FP16_EXP_ONES && i_Operand_A[9:0] == 0));
                        i_Operand_A[30:16] != 0; i_Operand_B[30:16] != 0;
                    }

                    // --- FMS: Inf - Inf (同号) ---
                    if (current_scenario == SC_INVALID_ADD) {
                        (i_Operand_A[14:10] == FP16_EXP_ONES && i_Operand_A[9:0] == 0); 
                        (i_Operand_B[15:0] == 16'h3C00); 
                        (i_Operand_C[14:10] == FP16_EXP_ONES && i_Operand_C[9:0] == 0); 
                        i_Operand_A[15] == i_Operand_C[15]; // 符号相同
                        i_Operand_A[30:26] inside {[1:20]}; i_Operand_B[30:26] inside {[1:20]};
                    }
                    if (current_scenario == SC_INF_GEN) {
                        i_Operand_A[14:10] inside {[25:30]}; i_Operand_B[14:10] inside {[25:30]};
                        i_Operand_A[30:26] inside {[25:30]}; i_Operand_B[30:26] inside {[25:30]}; 
                    }
                    
                    // --- FMS: Exact Cancel (同号) ---
                    if (current_scenario == SC_EXACT_CANCEL) {
                        i_Operand_A[15:0] == 16'h4000; // 2.0
                        i_Operand_B[15:0] == 16'h4000; // 2.0
                        i_Operand_C[15:0] == 16'h4400; // +4.0 (2*2 - 4 = 0)
                        i_Operand_A[31:16] == 16'h4000; i_Operand_B[31:16] == 16'h4000;
                    }
                    if (current_scenario == SC_TINY_FMA) {
                        i_Operand_C[14:10] inside {[10:20]}; 
                        if (tiny_sub_case == 0) { 
                            i_Operand_A[14:10] inside {[1:14]}; i_Operand_B[14:10] inside {[1:14]}; 
                            (int'(i_Operand_A[14:10]) + int'(i_Operand_B[14:10])) <= 15;
                        } else { 
                            i_Operand_A[14:10] == 0; i_Operand_B[14:10] inside {[0:3]};
                            i_Operand_A[9:3] == 0; i_Operand_A[2:0] != 0;
                        }
                        i_Operand_A[30:26] inside {[0:10]}; i_Operand_B[30:26] inside {[0:10]};
                    }
                }
                
                if (current_scenario == SC_ZERO_ADD) {
                    if (tr.i_Compute_Precision == `FP32) {
                        i_Operand_A[30:0] == 0; i_Operand_B[30:0] == 0; i_Operand_C[30:0] == 0;
                    } else {
                        i_Operand_A[14:0] == 0; i_Operand_B[14:0] == 0; i_Operand_C[14:0] == 0;
                        i_Operand_A[30:16] == 0; i_Operand_B[30:16] == 0;
                    }
                }
                
                // FMS: P - C. 如果 P=Inf, C=-Inf -> Inf - (-Inf) = Inf + Inf = Inf
                // 所以必须 异号
                if (current_scenario == SC_INF_SAME_SIGN) {
                    if (tr.i_Compute_Precision == `FP32) {
                        i_Operand_A == 32'h7F800000; // +Inf
                        i_Operand_B == 32'h3F800000; // 1.0
                        i_Operand_C == 32'hFF800000; // -Inf (减负无穷=加正无穷)
                    } else {
                        i_Operand_A[15:0] == 16'h7C00; // +Inf
                        i_Operand_B[15:0] == 16'h3C00; // 1.0
                        i_Operand_C[15:0] == 16'hFC00; // -Inf
                        i_Operand_A[31:16] == 16'h7C00; i_Operand_B[31:16] == 16'h3C00; 
                    }
                }
            }) begin
               `uvm_error("RND", "Randomization failed")
            end
            finish_item(tr);
        end
        if (starting_phase != null) starting_phase.drop_objection(this);
        `uvm_info("SEQ", "Sequence completed", UVM_LOW)
    endtask
endclass