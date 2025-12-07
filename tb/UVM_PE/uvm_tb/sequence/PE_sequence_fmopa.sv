// `include "macro_definition.svh"
// `include "uvm_macros.svh"

// class PE_sequence_fmopa extends PE_sequence;
//     `uvm_object_utils(PE_sequence_fmopa)

//     function new(string name = "PE_sequence_fmopa");
//         super.new(name);
//     endfunction
    
//     task body();
//         PE_seq_item tr;
//         int i;
//         if (starting_phase != null)
//             starting_phase.raise_objection(this);
//         for(i = 0; i < 4098; i++)begin
//             `uvm_info("SEQ", $sformatf("This is%d test", i), UVM_LOW)
//             tr = PE_seq_item::type_id::create("tr");

//             start_item(tr);
//             if (!tr.randomize() with {
//                 tr.i_Compute_Mode               ==  `Outer_Product;
//                 tr.i_Compute_Precision          ==  `FP32;
//                 tr.i_Is_Widening                ==  `Operands_Is_Not_Widening;
//                 tr.i_Add_or_Subtract            ==  `Addition_Operation;
//                 // tr.i_ZmIsSigned                 ==  `Zm_Is_Signed;
//                 // tr.i_ZnIsSigned                 ==  `Zn_Is_Signed;
//                 //tr.i_Num_of_Vector_Group        ==  `Two_Vector_Group;      
//                 //tr.i_Vector_Group_Num           ==  `Single_Vector_Group;
//                 tr.i_Active_Element_A           ==  4'b1111;
//                 tr.i_Active_Element_B           ==  4'b1111;
//                 tr.i_ZA_Base_Address            ==  32'hffff;
//                 tr.i_Exception_Handling[19]     == `Alternative_Half_Precision_Format;// Alternative_Half_Precision_Format IEEE_Half_Precision_Format
//                 tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
//                 tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;// Flush_Denormalized_Results_to_Zero Do_Not_Flush_Denormalized_Results_to_Zero
//                 tr.i_Exception_Handling[16:15]  == `Round_Towards_Plus_Infinity; //Round_to_Nearest_Mode Round_Towards_Plus_Infinity Round_Towards_Minus_Infinity Round_Towards_Zero          
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
//                 tr.i_Operand_C[127:32]          == 96'b0;
//                 // tr.i_Operand_A[31:0] == 32'h41200000;
//                 // tr.i_Operand_B[31:0] == 32'h41200000;
//                 // tr.i_Operand_C[31:0] == 32'h3f800000;

                

//                 i_Operand_A[31:0] dist {
//                     [32'h00000000:32'h7fffffff] :/ 50,
//                     [32'h80000000:32'hffffffff] :/ 50
//                 };

//                 i_Operand_B[31:0] dist {
//                     [32'h00000000:32'h7fffffff] :/ 50,
//                     [32'h80000000:32'hffffffff] :/ 50
//                 };

//                 i_Operand_C[31:0] dist {
//                     [32'h00000000:32'h7fffffff] :/ 50,
//                     [32'h80000000:32'hffffffff] :/ 50
//                 };
                
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

class PE_sequence_fmopa extends PE_sequence;
    `uvm_object_utils(PE_sequence_fmopa)

    function new(string name = "PE_sequence_fmopa");
        super.new(name);
    endfunction

    // 定义场景枚举
    typedef enum {
        SCENE_RANDOM,      // 纯随机
        SCENE_CANCELLATION,// 灾难性抵消 (测试前导零/归一化)
        SCENE_STICKY,      // 大移位 (测试你的减法借位逻辑)
        SCENE_TIE_0_5_ULP, // 舍入边界: 刚好是 X.5
        SCENE_NEAR_1_0_ULP // 舍入边界: 刚好是 X.00...01
    } scene_e;

    task body();
        PE_seq_item tr;
        int i;
        
        // 临时变量，用于构造特定的浮点数
        bit [31:0] gen_a, gen_b, gen_c;
        bit [7:0]  e_a, e_b, e_c;
        bit [22:0] m_a, m_b, m_c;
        bit        s_a, s_b, s_c;
        scene_e    cur_scene;

        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for(i = 0; i < 32768; i++) begin // 增加一点循环次数以覆盖更多场景
            `uvm_info("SEQ", $sformatf("Generating test %0d", i), UVM_MEDIUM)
            tr = PE_seq_item::type_id::create("tr");

            // ======================================================
            // 步骤 1: 在本地进行有针对性的数学随机
            // ======================================================
            void'(std::randomize(e_a, e_b, e_c, m_a, m_b, m_c, s_a, s_b, s_c, cur_scene) with {
                // 1. 场景分布权重
                cur_scene dist {
                    SCENE_RANDOM       := 20,
                    SCENE_CANCELLATION := 20,
                    SCENE_STICKY       := 20, // 重点测你之前的 Bug
                    SCENE_TIE_0_5_ULP  := 20, // 重点测 RNE 舍入
                    SCENE_NEAR_1_0_ULP := 20  // 重点测 RU/RD 舍入
                };

                // 2. 基础指数范围 (避开 NaN/Inf 以专注于算术逻辑，除非专门测异常)
                e_a inside {[1:254]};
                e_b inside {[1:254]};
                
                // 计算乘积的理想指数 (ExpA + ExpB - 127)
                // 这是一个临时的约束辅助逻辑
                
                // --------------------------------------------------
                // 场景 A: 灾难性抵消 (Catastrophic Cancellation)
                // --------------------------------------------------
                if (cur_scene == SCENE_CANCELLATION) {
                    // C 的指数非常接近 P，且必须是有效减法
                    e_c inside {[1:254]};
                    // 约束差值在 +/- 1 以内
                    (e_c + 127) - (e_a + e_b) inside {[-1:1]};
                    // 符号相反
                    s_c != (s_a ^ s_b);
                }

                // --------------------------------------------------
                // 场景 B: 大移位/Sticky (针对你之前的减法Bug)
                // --------------------------------------------------
                if (cur_scene == SCENE_STICKY) {
                    // C 远大于 A*B，P 被移出但留有 Sticky
                    // 移位量在 25 到 100 之间
                    (e_c + 127) > (e_a + e_b + 25);
                    (e_c + 127) < (e_a + e_b + 100);
                }

                // --------------------------------------------------
                // 场景 C: 0.5 ULP 边界 (Tie Case)
                // --------------------------------------------------
                if (cur_scene == SCENE_TIE_0_5_ULP) {
                    // 为了制造 X.5 的效果，P 需要作为 C 的 Guard Bit
                    // C 的 LSB 权重是 2^(Ec-23)
                    // P 的最高位权重是 2^(Ep)
                    // 需要 Ep approx Ec - 24
                    (e_c + 127) == (e_a + e_b + 24);
                    
                    // 强制 Mantissa 使得结果产生精准的中间值
                    m_c[0] == 0; // 配合 RNE 偶数舍入测试
                }

                // --------------------------------------------------
                // 场景 D: 1.0 ULP 边界 (微小增量)
                // --------------------------------------------------
                if (cur_scene == SCENE_NEAR_1_0_ULP) {
                    // 刚好有一点点 Sticky，类似于 SCENE_STICKY 但更极限
                    // 使得 P 仅仅贡献一个极其微小的值
                    (e_c + 127) > (e_a + e_b + 40);
                }

                // --------------------------------------------------
                // 场景 E: 普通随机
                // --------------------------------------------------
                if (cur_scene == SCENE_RANDOM) {
                    e_c inside {[1:254]};
                }
            });

            // 组装随机好的浮点数
            gen_a = {s_a, e_a, m_a};
            gen_b = {s_b, e_b, m_b};
            gen_c = {s_c, e_c, m_c};

            // ======================================================
            // 步骤 2: 将构造好的值赋给 Transaction 并随机其他控制位
            // ======================================================
            start_item(tr);
            if (!tr.randomize() with {
                // 固定控制信号
                tr.i_Compute_Mode               == `Outer_Product;
                tr.i_Compute_Precision      inside {`FP16,`FP32};
                tr.i_Is_Widening                == `Operands_Is_Not_Widening;
                tr.i_Add_or_Subtract            == `Addition_Operation;
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                
                // 异常处理配置
                tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;
                // tr.i_Exception_Handling[16:15]  == `Round_Towards_Minus_Infinity; //Round_to_Nearest_Mode Round_Towards_Plus_Infinity Round_Towards_Minus_Infinity Round_Towards_Zero          
                // tr.i_Exception_Handling[16:15] dist {
                //     `Round_Towards_Plus_Infinity  := 25,
                //     `Round_to_Nearest_Mode        := 25,
                //     `Round_Towards_Minus_Infinity := 25,
                //     `Round_Towards_Zero           := 25
                // };
                
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


                if(i_Compute_Precision == `FP32) {
                    tr.i_Operand_A[31:0] == 32'h40000001;
                    tr.i_Operand_B[31:0] == 32'h00000041;
                    tr.i_Operand_C[31:0] == 32'h00090221;
                    tr.i_Operand_C[127:32] == 96'b0;

                    // tr.i_Operand_A[31:0] == gen_a;
                    // tr.i_Operand_B[31:0] == gen_b;
                    // tr.i_Operand_C[31:0] == gen_c;
                    // tr.i_Operand_C[127:32] == 96'b0;
                }
                else if(i_Compute_Precision == `FP16) {
                    // 对于其他精度，保持完全随机
                    tr.i_Operand_A[31:16] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_B[31:16] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_A[15:0] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_B[15:0] inside {[16'h0000:16'hffff]};
                    tr.i_Operand_C[31:16]== 16'd0;
                    tr.i_Operand_C[63:48]== 16'd0;
                    tr.i_Operand_C[95:80]== 16'd0; 
                    tr.i_Operand_C[127:112]== 16'd0;                      
                }
            }) begin
               `uvm_error("RND", "Transaction Randomization failed")
            end
            
            finish_item(tr);

        end
        
        if (starting_phase != null) begin
            starting_phase.drop_objection(this);
        end

        `uvm_info("SEQ", "Sequence completed", UVM_LOW)
    endtask
endclass
