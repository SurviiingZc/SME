`include "macro_definition.svh"
`include "uvm_macros.svh"

class PE_sequence_fmlal extends PE_sequence;
    `uvm_object_utils(PE_sequence_fmlal)

    function new(string name = "PE_sequence_fmlal");
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
        SC_MULZERO          = 11
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
            tr = PE_seq_item::type_id::create("tr");
            start_item(tr);

            if (!std::randomize(current_scenario) with {
                current_scenario dist {
                    SC_RANDOM        := 20,
                    SC_NAN_INPUT     := 10,
                    SC_INVALID_MUL   := 5,
                    SC_INVALID_ADD   := 5,
                    SC_INF_GEN       := 5,
                    SC_INF_OPERAND   := 5,
                    SC_INF_SAME_SIGN := 5,
                    SC_EXACT_CANCEL  := 5,
                    SC_ZERO_ADD      := 5,
                    SC_TINY_FMA      := 15,
                    SC_ROUNDING_EDGE := 15,
                    SC_MULZERO        := 5
                };
            }) `uvm_error("SEQ", "Scenario randomization failed")

            void'(std::randomize(tiny_sub_case) with { tiny_sub_case dist { 0:=50, 1:=50 }; });
            void'(std::randomize(round_sub_case) with { round_sub_case dist { 0:=40, 1:=40, 2:=20 }; });

            if (!tr.randomize() with {
                // 固定模式：FP16 Widening to FP32
                tr.i_Compute_Mode               ==  `Inner_Product;
                tr.i_Compute_Precision      	==  `FP16;
                tr.i_Is_Widening                ==  `Operands_Is_Widening;
                tr.i_Add_or_Subtract            ==  `Addition_Operation;
                tr.i_Vector_Group_Num           ==  `Double_Vector_Group;
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;// Alternative_Half_Precision_Format IEEE_Half_Precision_Format
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;// Flush_Denormalized_Results_to_Zero Do_Not_Flush_Denormalized_Results_to_Zero
                tr.i_Exception_Handling[16:15] dist {
                    2'b00 := 25,
                    2'b01 := 25,
                    2'b10 := 25,
                    2'b11 :/ 25 
                };
                // tr.i_Exception_Handling[16:15]  == `Round_Towards_Zero; // Round_Towards_Plus_Infinity Round_Towards_Minus_Infinity Round_Towards_Zero Round_to_Nearest_Mode         
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
                tr.i_Exception_Handling[1]      == `IEEE_Handling_Floating_Point_Numbers; //Alternative_Handling_Floating_Point_Numbers IEEE_Handling_Floating_Point_Numbers
                tr.i_Exception_Handling[0]      == `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF;

                // 未使用的通道清零
                tr.i_Operand_C[127:64] == 64'b0;

                // --- 场景约束 ---
                
                if (current_scenario == SC_RANDOM) {
                    // 全随机，无需额外约束
                }

                if (current_scenario == SC_NAN_INPUT) {
                    // 任意一个输入是 NaN (a1, b1, a2, b2 为 FP16; C1, C2 为 FP32)
                    (tr.i_Operand_A[14:10] == FP16_EXP_ONES && tr.i_Operand_A[9:0] != 0) ||
                    (tr.i_Operand_B[30:26] == FP16_EXP_ONES && tr.i_Operand_B[25:16] != 0) ||
                    (tr.i_Operand_C[30:23] == FP32_EXP_ONES && tr.i_Operand_C[22:0] != 0);
                }

                if (current_scenario == SC_INVALID_MUL) { 
                    // 0 * Inf
                    (tr.i_Operand_A[14:0] == 0 && tr.i_Operand_B[14:10] == FP16_EXP_ONES && tr.i_Operand_B[9:0] == 0) ||
                    (tr.i_Operand_B[14:0] == 0 && tr.i_Operand_A[14:10] == FP16_EXP_ONES && tr.i_Operand_A[9:0] == 0);
                }

                if (current_scenario == SC_INVALID_ADD) {
                    // Inf - Inf (即 a*b 为 +Inf, C 为 -Inf)
                    tr.i_Operand_A[14:10] == 5'h10; tr.i_Operand_B[14:10] == 5'h10; // 产生大数
                    tr.i_Operand_C[31] != (tr.i_Operand_A[15] ^ tr.i_Operand_B[15]);
                    tr.i_Operand_C[30:23] == FP32_EXP_ONES; tr.i_Operand_C[22:0] == 0;
                }

                if (current_scenario == SC_INF_GEN) {
                    // 结果溢出到无穷 (FP16*FP16 最大约 2^16, FP32 范围大，所以这里主要考查 C 接近 FP32 极限)
                    tr.i_Operand_C[30:23] == 8'hFE; 
                    tr.i_Operand_A[14:10] == 5'h1E; tr.i_Operand_B[14:10] == 5'h1E;
                    tr.i_Operand_C[31] == (tr.i_Operand_A[15] ^ tr.i_Operand_B[15]);
                }

                if (current_scenario == SC_EXACT_CANCEL) {
                    // a*b + C 发生精确抵消 (a*b = -C)
                    // 例子: 2.0(FP16) * 2.0(FP16) + (-4.0(FP32))
                    // 2.0 in FP16 = 16'h4000; -4.0 in FP32 = 32'hC0800000
                    tr.i_Operand_A[15:0]  == 16'h4000; 
                    tr.i_Operand_B[15:0]  == 16'h4000;
                    tr.i_Operand_C[31:0]  == 32'hC0800000;

                    // 第二组 a2*b2 + C2
                    tr.i_Operand_A[31:16] == 16'h3C00; // 1.0
                    tr.i_Operand_B[31:16] == 16'h3C00; // 1.0
                    tr.i_Operand_C[63:32] == 32'hBF800000; // -1.0
                }

                if (current_scenario == SC_ROUNDING_EDGE) {
                    // 针对 FP32 加法的舍入边界
                    // a*b 的结果是精确的，关键看 a*b 和 C 相加时的对阶舍入
                    tr.i_Operand_A[14:10] inside {[10:20]};
                    tr.i_Operand_B[14:10] inside {[10:20]};
                    // 让 C 的指数比 (a*b) 大 25 左右，迫使 a*b 的尾数向右移出 FP32 的 23位尾数区
                    if (round_sub_case == 0) { // Tie
                         (int'(tr.i_Operand_C[30:23])) == (int'(tr.i_Operand_A[14:10]) + int'(tr.i_Operand_B[14:10]) - 15 + 127 + 24);
                    } else { // Sticky bits
                         (int'(tr.i_Operand_C[30:23])) > (int'(tr.i_Operand_A[14:10]) + int'(tr.i_Operand_B[14:10]) + 112 + 25);
                    }
                }
    
                if (current_scenario == SC_TINY_FMA) {
                    // 产生 FP32 Subnormal 结果
                    tr.i_Operand_C[30:23] == 8'h00;
                    tr.i_Operand_A[14:10] == 5'h01; tr.i_Operand_B[14:10] == 5'h01; // 极小 FP16
                }

                if (current_scenario == SC_ZERO_ADD) {
                    tr.i_Operand_A[31:0] == 0;
                    tr.i_Operand_B[31:0] == 0;
                    tr.i_Operand_C[63:0] == 0;
                }
                
                if (current_scenario == SC_MULZERO) {
                    tr.i_Operand_A[14:0] == 0;
                    tr.i_Operand_B[14:0] == 0;
                    tr.i_Operand_A[30:16] == 0;
                    tr.i_Operand_B[30:16] == 0;      
                }
            }) `uvm_error("RND", "Randomization failed")

            finish_item(tr);
        end

        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass