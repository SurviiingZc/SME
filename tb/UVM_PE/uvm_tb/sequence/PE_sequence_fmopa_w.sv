`include "macro_definition.svh"
`include "uvm_macros.svh"

class PE_sequence_fmopa_w extends PE_sequence;
    `uvm_object_utils(PE_sequence_fmopa_w)

    function new(string name = "PE_sequence_fmopa_w");
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
        SC_ROUNDING_EDGE   = 10 ,
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

        for(i = 0; i < 50000; i++) begin
            `uvm_info("SEQ", $sformatf("Generating test %0d", i), UVM_MEDIUM)
            tr = PE_seq_item::type_id::create("tr");
            start_item(tr);

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
                    SC_ROUNDING_EDGE := 20, // 重点测试 Widening 精度
                    SC_1_2_3         := 1
                };
            }) begin
                `uvm_error("SEQ", "Scenario randomization failed")
            end
            void'(std::randomize(tiny_sub_case) with { tiny_sub_case dist { 0:=25, 1:=75 }; });
            void'(std::randomize(round_sub_case) with { round_sub_case dist { 0:=40, 1:=40, 2:=20 }; });
            `uvm_info("SEQ", $sformatf("Loop %0d: Scenario: %s", i, current_scenario.name()), UVM_HIGH)

            if (!tr.randomize() with {
                tr.i_Compute_Mode               == `Outer_Product;
                tr.i_Is_Widening                == `Operands_Is_Widening; // 核心：Widening 模式
                tr.i_Add_or_Subtract            == `Addition_Operation; 
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                tr.i_Compute_Precision          == `FP16;
                
                tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Flush_Denormalized_Results_to_Zero;
                // tr.i_Exception_Handling[16:15]  == `Round_to_Nearest_Mode;       
                i_Exception_Handling[16:15] dist {
                    2'b00 := 25,
                    2'b01 := 25,
                    2'b10 := 25,
                    2'b11 :/ 25 
                };
                tr.i_Exception_Handling[14:13]  == `Stride_1;
                tr.i_Exception_Handling[12]     == `Do_Not_Flush_Denormalized_Results_to_Zero_Half;
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
                
                // Widening: C 是 FP32，只用低 32 位，高位清零
                tr.i_Operand_C[127:32] == 96'b0;


                if (current_scenario == SC_ROUNDING_EDGE) {
                    // 构造满尾数输入：1.11...1 * 1.11...1
                    // 只有 Widening 才能保留乘积的完整 22 bit 精度
                    i_Operand_A[9:0] == 10'h3FF; i_Operand_B[9:0] == 10'h3FF;
                    // 高位 Element 也填满，增加覆盖
                    i_Operand_A[25:16] == 10'h3FF; i_Operand_B[25:16] == 10'h3FF;
                    
                    // 指数设置为 0 (Bias 15) -> 1.xxx
                    i_Operand_A[14:10] == 5'd15; i_Operand_B[14:10] == 5'd15;
                    i_Operand_A[30:26] == 5'd15; i_Operand_B[30:26] == 5'd15;

                    // C 设为 0，以便单纯检查 a*b 的精度是否被截断
                    tr.i_Operand_C[30:0] == 0;
                }
                
                if (current_scenario != SC_ROUNDING_EDGE) {
                    // FP16 输入范围约束
                    tr.i_Operand_A[31:16] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_B[31:16] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_A[15:0] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_B[15:0] inside {[16'h0000:16'hffff]};

                    if (current_scenario == SC_1_2_3) {
                        // FP16: 1.0=0x3C00, 2.0=0x4000
                        i_Operand_A == 32'h40003C00; 
                        i_Operand_B == 32'h3C004000; 
                        // FP32: 4.0=0x40800000 (1*2 + 2*1 = 4)
                        // Result = 4 + 4 = 8.0 (0x41000000)
                        i_Operand_C == 32'h40800000;
                    }
                    if (current_scenario == SC_NAN_INPUT) {
                        // FP16 NaN: Exp=0x1F, Man!=0
                        (i_Operand_A[14:10] == FP16_EXP_ONES && i_Operand_A[9:0] != 0) ||
                        (i_Operand_B[14:10] == FP16_EXP_ONES && i_Operand_B[9:0] != 0) ||
                        (i_Operand_C[30:23] == FP32_EXP_ONES && i_Operand_C[22:0] != 0); // C is FP32
                        i_Operand_A[30:26] dist { FP16_EXP_ONES :/ 10, [0:30] :/ 90 };
                    }
                    if (current_scenario == SC_INVALID_MUL) { 
                        // 0 * Inf
                        ((i_Operand_A[14:0] == 0) && (i_Operand_B[14:10] == FP16_EXP_ONES && i_Operand_B[9:0] == 0)) ||
                        ((i_Operand_B[14:0] == 0) && (i_Operand_A[14:10] == FP16_EXP_ONES && i_Operand_A[9:0] == 0));
                    }
                    if (current_scenario == SC_INVALID_ADD) { 
                        // Widening 后变成 (Inf + (-Inf)) + C 或 (Inf) + (-Inf)
                        // 让 P1 = Inf, P2 = -Inf
                        i_Operand_A[15:0] == 16'h7C00; // +Inf
                        i_Operand_B[15:0] == 16'h3C00; // 1.0
                        i_Operand_A[31:16] == 16'hFC00; // -Inf
                        i_Operand_B[31:16] == 16'h3C00; // 1.0
                        // C is normal
                        i_Operand_C[30:23] inside {[100:150]};
                    }
                    if (current_scenario == SC_INF_GEN) {
                        // Max * Max -> Overflow to Inf
                        i_Operand_A[14:10] inside {[25:30]}; i_Operand_B[14:10] inside {[25:30]};
                        i_Operand_A[30:26] inside {[25:30]}; i_Operand_B[30:26] inside {[25:30]}; 
                    }
                    if (current_scenario == SC_EXACT_CANCEL) {
                        // (P1 + P2) + C = 0
                        // P1=1, P2=1 -> Sum=2. C=-2.
                        i_Operand_A == 32'h3C003C00; i_Operand_B == 32'h3C003C00;
                        // FP32 -2.0 = 0xC0000000
                        i_Operand_C == 32'hC0000000;
                    }
                    if (current_scenario == SC_TINY_FMA) {
                        i_Operand_C[30:23] inside {[100:120]}; 
                        if (tiny_sub_case == 0) { 
                            i_Operand_A[14:10] inside {[1:5]}; i_Operand_B[14:10] inside {[1:5]}; 
                        } else { 
                            i_Operand_A[14:10] == 0; i_Operand_B[14:10] inside {[0:3]};
                        }
                    }
                }
                
                if (current_scenario == SC_ZERO_ADD) {
                    i_Operand_A == 0; i_Operand_B == 0; i_Operand_C[30:0] == 0;
                }
                if (current_scenario == SC_INF_SAME_SIGN) {
                    // Inf + Inf + Inf
                    i_Operand_A[15:0] == 16'h7C00; i_Operand_B[15:0] == 16'h3C00; 
                    i_Operand_A[31:16] == 16'h7C00; i_Operand_B[31:16] == 16'h3C00;
                    i_Operand_C == 32'h7F800000;
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