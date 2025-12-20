`include "macro_definition.svh"
`include "uvm_macros.svh"

typedef enum bit [3:0] {
    BFE_SC_RANDOM            = 0,  // 随机分布
    BFE_SC_NAN_INPUT         = 1,  // 输入 NaN
    BFE_SC_INVALID_MUL       = 2,  // 0 * Inf
    BFE_SC_INVALID_ADD       = 3,  // Inf - Inf
    BFE_SC_INF_GEN           = 4,  // 溢出产生 Inf
    BFE_SC_INF_OPERAND       = 5,  // 输入 Inf
    BFE_SC_INF_SAME_SIGN     = 6,  // Inf + Inf
    BFE_SC_EXACT_CANCEL      = 7,  // 完美对消 (Result = 0)
    BFE_SC_ZERO_ADD          = 8,  // 加 0 测试
    BFE_SC_BF16_DENORM       = 9,  // 非规约数 (Exp=0)
    BFE_SC_WIDEN_PRECISE     = 10, // Widening重点: 检查 14-bit 乘积完整性
    BFE_SC_WIDEN_NEAR_CANCEL = 11, // Widening重点: 近乎对消
    BFE_SC_WIDEN_STICKY      = 12, // Sticky bit 覆盖
    BFE_SC_SIMPLE_INT        = 13  // 简单整数
} scenario_bfe_e;

class PE_sequence_bfmopa_EBF extends PE_sequence;
    `uvm_object_utils(PE_sequence_bfmopa_EBF)

    rand scenario_bfe_e cur_scenario;
    rand bit [15:0] rand_a1, rand_a2; // BF16
    rand bit [15:0] rand_b1, rand_b2; // BF16
    rand bit [31:0] rand_c;           // FP32

    // 指数偏差 Bias = 127
    const bit [15:0] BF16_POS_INF  = 16'h7F80;
    const bit [15:0] BF16_NEG_INF  = 16'hFF80;
    const bit [15:0] BF16_POS_ZERO = 16'h0000;
    const bit [15:0] BF16_NEG_ZERO = 16'h8000;
    const bit [15:0] BF16_QNAN     = 16'h7FC0; // Quiet NaN
    const bit [15:0] BF16_ONE      = 16'h3F80; // 1.0 (Exp=127, Man=0)
    const bit [15:0] BF16_TWO      = 16'h4000; // 2.0
    const bit [15:0] BF16_MAX      = 16'h7F7F; // Max Normal (0 11111110 1111111)
    
    // FP32 Constants
    const bit [31:0] FP32_POS_ZERO = 32'h00000000;
    const bit [31:0] FP32_POS_INF  = 32'h7F800000;
    const bit [31:0] FP32_QNAN     = 32'h7FC00000;

    function new(string name = "PE_sequence_bfmopa_EBF");
        super.new(name);
    endfunction

    constraint c_operands_generation {
        // --- 场景分布 ---
        cur_scenario dist {
            BFE_SC_RANDOM            := 30,
            BFE_SC_WIDEN_PRECISE     := 15, // 重点：测试 7bit -> 14bit 扩展是否丢失
            BFE_SC_WIDEN_NEAR_CANCEL := 10,
            BFE_SC_WIDEN_STICKY      := 5,
            BFE_SC_NAN_INPUT         := 3,
            BFE_SC_INVALID_MUL       := 3,
            BFE_SC_INVALID_ADD       := 3,
            BFE_SC_INF_GEN           := 5,
            BFE_SC_INF_OPERAND       := 5,
            BFE_SC_BF16_DENORM       := 5,  // 测试 BF16 下溢
            [BFE_SC_INF_SAME_SIGN:BFE_SC_ZERO_ADD] :/ 10,
            BFE_SC_EXACT_CANCEL      := 5,
            BFE_SC_SIMPLE_INT        := 1
        };

        // --- 具体数值约束 ---
        
              
            // 1. NaN 输入
            if (cur_scenario == BFE_SC_NAN_INPUT) {
                (rand_a1 == BF16_QNAN) || (rand_b1 == BF16_QNAN) || (rand_c == FP32_QNAN);
            }

            // 2. 无效乘法 0 * Inf
            else if (cur_scenario == BFE_SC_INVALID_MUL) {
                (rand_a1 == BF16_POS_ZERO && rand_b1 == BF16_POS_INF) || 
                (rand_a2 == BF16_NEG_INF  && rand_b2 == BF16_POS_ZERO);
            }

            // 3. 无效加法 Inf - Inf
            else if (cur_scenario == BFE_SC_INVALID_ADD) {
                rand_a1 == BF16_POS_INF; rand_b1 == BF16_ONE;
                rand_a2 == BF16_NEG_INF; rand_b2 == BF16_ONE;
            }

            // 4. 乘法溢出 (BF16 Max * Max 必定溢出到 Inf)
            else if (cur_scenario == BFE_SC_INF_GEN) {
                rand_a1 == BF16_MAX; rand_b1 == BF16_MAX;
                rand_a2 == BF16_POS_ZERO; rand_b2 == BF16_POS_ZERO;
            }

            // 5. 输入 Inf
            else if (cur_scenario == BFE_SC_INF_OPERAND) {
                rand_a1 inside {BF16_POS_INF, BF16_NEG_INF};
                rand_b1 == BF16_ONE;
            }

            // 6. BF16 Denorm (Exp = 0)
            else if (cur_scenario == BFE_SC_BF16_DENORM) {
                rand_a1[14:7] == 8'h00; // Exp bits
                rand_a1[6:0]  != 0;     // Mantissa not 0
                rand_b1 == BF16_ONE;
                rand_c == FP32_POS_ZERO;
            }

            // 7. 完美对消
            else if (cur_scenario == BFE_SC_EXACT_CANCEL) {
                rand_a1[14:0] == rand_a2[14:0]; // Mag match
                rand_b1[14:0] == rand_b2[14:0];
                rand_a1[15]   != rand_a2[15];   // Sign diff
                rand_b1[15]   == rand_b2[15];
                rand_c        == FP32_POS_ZERO;
            }

            // 8. Widening: 14-bit 乘积完整性检测
            else if (cur_scenario == BFE_SC_WIDEN_PRECISE) {
                // BF16 尾数只有 7 位。
                // 如果两个数尾数全为 1 (0x7F)，乘积尾数将有 14 位有效值。
                // 结果不应该被舍入回 7 位再相加，而应保留 14 位。
                rand_a1[6:0] == 7'h7F; // 1.1111111
                rand_b1[6:0] == 7'h7F; // 1.1111111
                // 选取普通指数
                rand_a1[14:7] == 8'd127; // Exp=0
                rand_b1[14:7] == 8'd127;
                
                // 第二路乘积设为 0
                rand_a2 == BF16_POS_ZERO; rand_b2 == BF16_POS_ZERO;
                rand_c == FP32_POS_ZERO;
            }

            // 9. Widening: 近乎对消
            else if (cur_scenario == BFE_SC_WIDEN_NEAR_CANCEL) {
                // 构造 a1b1 ≈ -a2b2
                rand_a1[14:7] inside {[120:135]}; // Normal Exp
                rand_b1[14:7] inside {[120:135]};
                
                // a2 = -a1
                rand_a2 == {~rand_a1[15], rand_a1[14:0]};
                
                // b2 ≈ b1 (Differ by 1 ULP)
                rand_b2[15:7] == rand_b1[15:7]; // Sign + Exp same
                (rand_b2[6:0] == rand_b1[6:0] + 1) || (rand_b2[6:0] == rand_b1[6:0] - 1);
                
                rand_c == FP32_POS_ZERO;
            }
            
            // 10. Sticky Bit 测试 (大指数差)
            else if (cur_scenario == BFE_SC_WIDEN_STICKY) {
                // BF16 尾数短，更容易制造对齐移位
                rand_a1[14:7] == 8'd150; // Large
                rand_b1[14:7] == 8'd150; 
                
                // Small: Diff > 24 bits
                rand_a2[14:7] == 8'd100; 
                rand_b2[14:7] == 8'd100;
                rand_a2[15]   != rand_a1[15]; // Subtraction
                rand_c == FP32_POS_ZERO;
            }

            // 11. 简单整数 (1*2 + 2*1)
            else if (cur_scenario == BFE_SC_SIMPLE_INT) {
                rand_a1 inside {BF16_ONE, BF16_TWO};
                rand_b1 inside {BF16_ONE, BF16_TWO};
                rand_c  == 32'h3F800000; // FP32 1.0
            }
        }
    

    task body();
        PE_seq_item tr;
        int i;
        
        if (starting_phase != null)
            starting_phase.raise_objection(this);
            
        for(i = 0; i < 5000; i++)begin
            `uvm_info("SEQ", $sformatf("Processing test %0d", i), UVM_MEDIUM)
            tr = PE_seq_item::type_id::create("tr");

            start_item(tr);

            if (!this.randomize()) begin
                `uvm_error("SEQ", "Local variable randomization failed")
            end
            
            `uvm_info("SEQ_DBG", $sformatf("Scenario: %s | A1:%h B1:%h | A2:%h B2:%h", 
                      cur_scenario.name(), rand_a1, rand_b1, rand_a2, rand_b2), UVM_HIGH)

            if (!tr.randomize() with {
                // --- 基础配置 (原样保留) ---
                tr.i_Compute_Mode               == `Outer_Product;
                tr.i_Is_Widening                == `Operands_Is_Widening;
                tr.i_Add_or_Subtract            == `Addition_Operation; 
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                tr.i_Compute_Precision          == `BF16;
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
                tr.i_Exception_Handling[8]      == `Extended_BFloat16_Behaviors;   //Extended_BFloat16_Behaviors  Standard_BFloat16_Behaviors
                tr.i_Exception_Handling[7]      == `Trap_Disabled_for_Inexact_Result;
                tr.i_Exception_Handling[6]      == `Trap_Disabled_for_Underflow;
                tr.i_Exception_Handling[5]      == `Trap_Disabled_for_Overflow;
                tr.i_Exception_Handling[4]      == `Trap_Disabled_for_Divide_by_Zero;
                tr.i_Exception_Handling[3]      == `Trap_Disabled_for_Invalid_Operation;
                tr.i_Exception_Handling[2]      == `Not_Affect_Output_Elements;
                tr.i_Exception_Handling[1]      == `IEEE_Handling_Floating_Point_Numbers;
                tr.i_Exception_Handling[0]      == `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF;

                // Operand A (高16=a2, 低16=a1)
                i_Operand_A == {rand_a2, rand_a1};

                // Operand B (高16=b2, 低16=b1)
                i_Operand_B == {rand_b2, rand_b1};

                // Operand C
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

// `include "macro_definition.svh"
// `include "uvm_macros.svh"

// class PE_sequence_bfmopa extends PE_sequence;
//     `uvm_object_utils(PE_sequence_bfmopa)

//     function new(string name = "PE_sequence_bfmopa");
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
//                 tr.i_Compute_Mode               == `Outer_Product;
//                 tr.i_Is_Widening                == `Operands_Is_Widening;
//                 tr.i_Add_or_Subtract            == `Addition_Operation; 
//                 tr.i_Active_Element_A           == 4'b1111;
//                 tr.i_Active_Element_B           == 4'b1111;
//                 tr.i_ZA_Base_Address            == 32'hffff;
//                 tr.i_Compute_Precision          == `BF16;
//                 tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;
//                 tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
//                 tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;
//                 tr.i_Exception_Handling[16:15]  == `Round_Towards_Zero;
//                 tr.i_Exception_Handling[14:13]  == `Stride_1;
//                 tr.i_Exception_Handling[12]     == `Do_Not_Flush_Denormalized_Results_to_Zero_Half;
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
//                 tr.i_Operand_C[127:32]          == 96'b0;

//                 tr.i_Operand_A[31:16] inside {[16'h0000:16'hffff]};
//                 tr.i_Operand_B[31:16] inside {[16'h0000:16'hffff]};
//                 tr.i_Operand_A[15:0] inside {[16'h0000:16'hffff]};
//                 tr.i_Operand_B[15:0] inside {[16'h0000:16'hffff]};
//                 // tr.i_Operand_C[31:16]== 16'd0;
//                 // tr.i_Operand_C[63:48]== 16'd0;
//                 // tr.i_Operand_C[95:80]== 16'd0; 
//                 // tr.i_Operand_C[127:112]== 16'd0;                      

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