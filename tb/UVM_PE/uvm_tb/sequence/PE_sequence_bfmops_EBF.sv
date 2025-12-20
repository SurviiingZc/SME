`include "macro_definition.svh"
`include "uvm_macros.svh"

typedef enum bit [3:0] {
    BFSE_SC_RANDOM            = 0,  // 随机
    BFSE_SC_NAN_INPUT         = 1,  // 输入 NaN
    BFSE_SC_INVALID_MUL       = 2,  // 0 * Inf (乘法阶段无效)
    BFSE_SC_INVALID_SUB       = 3,  // Inf - Inf (减法阶段无效，产生 NaN)
    BFSE_SC_INF_GEN           = 4,  // 乘法溢出出 Inf
    BFSE_SC_INF_OPERAND       = 5,  // 输入就是 Inf
    BFSE_SC_SUB_FROM_ZERO     = 6,  // (0 + 0) - C = -C
    BFSE_SC_EXACT_CANCEL      = 7,  // P - C = 0 (完美对消)
    BFSE_SC_ZERO_SUB          = 8,  // P - 0 = P
    BFSE_SC_BF_DENORM         = 9,  // BF16 输入非规约
    BFSE_SC_WIDEN_PRECISE     = 10, // Widening: 检查 14-bit 乘积精度
    BFSE_SC_WIDEN_NEAR_CANCEL = 11, // Widening: P - C ≈ 0 (暴露低位差异)
    BFSE_SC_WIDEN_STICKY      = 12, // Sticky Bit 测试
    BFSE_SC_SIMPLE_INT        = 13  // 简单整数验证
} scenario_bfse_e;

class PE_sequence_bfmops_EBF extends PE_sequence;
    `uvm_object_utils(PE_sequence_bfmops_EBF)

    rand scenario_bfse_e cur_scenario;
    rand bit [15:0] rand_a1, rand_a2; // BF16
    rand bit [15:0] rand_b1, rand_b2; // BF16
    rand bit [31:0] rand_c;           // FP32

    const bit [15:0] BF16_POS_INF  = 16'h7F80;
    const bit [15:0] BF16_NEG_INF  = 16'hFF80;
    const bit [15:0] BF16_POS_ZERO = 16'h0000;
    const bit [15:0] BF16_NEG_ZERO = 16'h8000;
    const bit [15:0] BF16_QNAN     = 16'h7FC0;
    const bit [15:0] BF16_ONE      = 16'h3F80; // 1.0
    const bit [15:0] BF16_TWO      = 16'h4000; // 2.0
    const bit [15:0] BF16_MAX      = 16'h7F7F; // Max Normal

    // FP32 Constants
    const bit [31:0] FP32_POS_ZERO = 32'h00000000;
    const bit [31:0] FP32_POS_INF  = 32'h7F800000;
    const bit [31:0] FP32_QNAN     = 32'h7FC00000;

    function new(string name = "PE_sequence_bfmops_EBF");
        super.new(name);
    endfunction
    
    constraint c_operands_generation {
        // --- 场景分布 ---
        cur_scenario dist {
            BFSE_SC_RANDOM            := 30,
            BFSE_SC_WIDEN_PRECISE     := 15, // 重点 BF16 Widening
            BFSE_SC_WIDEN_NEAR_CANCEL := 10, 
            BFSE_SC_INVALID_SUB       := 5,  
            BFSE_SC_EXACT_CANCEL      := 10, 
            BFSE_SC_SUB_FROM_ZERO     := 5,
            BFSE_SC_ZERO_SUB          := 5,
            BFSE_SC_NAN_INPUT         := 3,
            BFSE_SC_INVALID_MUL       := 3,
            BFSE_SC_INF_GEN           := 5,
            BFSE_SC_INF_OPERAND       := 5,
            BFSE_SC_BF_DENORM         := 3,
            BFSE_SC_SIMPLE_INT        := 1
        };

        // --- 具体数值约束 ---

        // 1. NaN
        if (cur_scenario == BFSE_SC_NAN_INPUT) {
            (rand_a1 == BF16_QNAN) || (rand_b1 == BF16_QNAN) || (rand_c == FP32_QNAN);
        }

        // 2. 无效乘法 0 * Inf
        else if (cur_scenario == BFSE_SC_INVALID_MUL) {
            (rand_a1 == BF16_POS_ZERO && rand_b1 == BF16_POS_INF);
        }

        // 3. 无效减法 Inf - Inf (产生 NaN)
        else if (cur_scenario == BFSE_SC_INVALID_SUB) {
            // DotProduct = +Inf
            rand_a1 == BF16_POS_INF; rand_b1 == BF16_ONE;
            rand_a2 == BF16_POS_ZERO;
            // C = +Inf
            rand_c == FP32_POS_INF;
            // Result = (+Inf) - (+Inf) = NaN
        }

        // 4. 乘法溢出
        else if (cur_scenario == BFSE_SC_INF_GEN) {
            rand_a1 == BF16_MAX; rand_b1 == BF16_MAX;
            rand_a2 == BF16_POS_ZERO;
        }

        // 5. 输入 Inf
        else if (cur_scenario == BFSE_SC_INF_OPERAND) {
            rand_a1 == BF16_POS_INF; rand_b1 == BF16_ONE;
            rand_c  == 32'h3F800000; // 1.0
        }

        // 6. 从 0 减 (0 - C = -C)
        else if (cur_scenario == BFSE_SC_SUB_FROM_ZERO) {
            rand_a1 == BF16_POS_ZERO; rand_b1 == BF16_POS_ZERO;
            rand_a2 == BF16_POS_ZERO; rand_b2 == BF16_POS_ZERO;
        }

        // 7. 完美对消 (P - C = 0)
        else if (cur_scenario == BFSE_SC_EXACT_CANCEL) {
            // P = 2.0 (1*1 + 1*1)
            rand_a1 == BF16_ONE; rand_b1 == BF16_ONE;
            rand_a2 == BF16_ONE; rand_b2 == BF16_ONE;
            // C = 2.0
            rand_c == 32'h40000000; 
        }

        // 8. 减 0 (P - 0 = P)
        else if (cur_scenario == BFSE_SC_ZERO_SUB) {
            rand_c == FP32_POS_ZERO;
        }

        // 9. Widening: 14-bit 乘积完整性测试
        else if (cur_scenario == BFSE_SC_WIDEN_PRECISE) {
            // BF16 尾数 7 bit，乘积 14 bit。
            // 构造 1.1111111 * 1.1111111
            rand_a1[6:0] == 7'h7F; 
            rand_b1[6:0] == 7'h7F;
            rand_a1[14:7] == 8'd127; // Exp=0
            rand_b1[14:7] == 8'd127;
            
            rand_a2 == BF16_POS_ZERO;
            rand_c  == FP32_POS_ZERO; // 减0，检查输出是否保留所有位
        }

        // 10. Widening: 近乎对消
        else if (cur_scenario == BFSE_SC_WIDEN_NEAR_CANCEL) {
            // P = 1.0 
            rand_a1 == BF16_ONE; rand_b1 == BF16_ONE;
            rand_a2 == BF16_POS_ZERO; 
            
            // C = 1.0 + epsilon (FP32 smallest step)
            rand_c inside {32'h3F800001, 32'h3F7FFFFF}; 
        }

        // 11. BF Denorm
        else if (cur_scenario == BFSE_SC_BF_DENORM) {
            rand_a1[14:7] == 8'h00; // Exp=0
            rand_a1[6:0] != 0;
            rand_b1 == BF16_ONE;
            rand_c == FP32_POS_ZERO;
        }

        // 12. 简单整数
        else if (cur_scenario == BFSE_SC_SIMPLE_INT) {
            rand_a1 inside {BF16_ONE, BF16_TWO};
            rand_b1 inside {BF16_ONE, BF16_TWO};
            rand_c  == 32'h3F800000; // 1.0
        }
    }

    task body();
        PE_seq_item tr;
        int i;
        if (starting_phase != null)
            starting_phase.raise_objection(this);
            
        for(i = 0; i < 5000; i++)begin
            `uvm_info("SEQ", $sformatf("This is%d test", i), UVM_MEDIUM)
            tr = PE_seq_item::type_id::create("tr");

            start_item(tr);

            if (!this.randomize()) begin
                `uvm_error("SEQ", "Local variable randomization failed")
            end
            
            `uvm_info("SEQ_DBG", $sformatf("Scenario: %s | A1:%h B1:%h C:%h", 
                      cur_scenario.name(), rand_a1, rand_b1, rand_c), UVM_HIGH)

            if (!tr.randomize() with {
                tr.i_Compute_Mode               == `Outer_Product;
                tr.i_Is_Widening                == `Operands_Is_Widening;
                tr.i_Add_or_Subtract            == `Subtraction_Operation;
                
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                tr.i_Compute_Precision          == `BF16; // BF16 精度

                tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;
                tr.i_Exception_Handling[16:15]  == `Round_Towards_Zero;
                // i_Exception_Handling[16:15] dist {
                //     2'b00 := 25,
                //     2'b01 := 25,
                //     2'b10 := 25,
                //     2'b11 :/ 25 
                // };       
                tr.i_Exception_Handling[14:13]  == `Stride_1;
                tr.i_Exception_Handling[12]     == `Do_Not_Flush_Denormalized_Results_to_Zero_Half;
                tr.i_Exception_Handling[11:10]  == `Length_1;
                tr.i_Exception_Handling[9]      == `Trap_Disabled_for_Input_Denormal;
                tr.i_Exception_Handling[8]      == `Extended_BFloat16_Behaviors; // BF16 Specific
                tr.i_Exception_Handling[7]      == `Trap_Disabled_for_Inexact_Result;
                tr.i_Exception_Handling[6]      == `Trap_Disabled_for_Underflow;
                tr.i_Exception_Handling[5]      == `Trap_Disabled_for_Overflow;
                tr.i_Exception_Handling[4]      == `Trap_Disabled_for_Divide_by_Zero;
                tr.i_Exception_Handling[3]      == `Trap_Disabled_for_Invalid_Operation;
                tr.i_Exception_Handling[2]      == `Not_Affect_Output_Elements;
                tr.i_Exception_Handling[1]      == `IEEE_Handling_Floating_Point_Numbers; 
                tr.i_Exception_Handling[0]      == `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF;
                
                // 数据填充
                i_Operand_A == {rand_a2, rand_a1};
                i_Operand_B == {rand_b2, rand_b1};
                i_Operand_C == rand_c;

            }) begin
               `uvm_error("RND", "Randomization failed")
            end
            
            finish_item(tr);
        end
        
        if (starting_phase != null) begin
            starting_phase.drop_objection(this);
        end

        `uvm_info("SEQ", "Sequence completed", UVM_LOW)
    endtask
endclass