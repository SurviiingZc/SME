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

    // 定义测试场景枚举
    typedef enum {
        SCENE_RANDOM,           // 纯随机
        SCENE_CANCELLATION,     // 灾难性抵消
        SCENE_STICKY,           // 大移位/Sticky测试
        SCENE_TIE_0_5_ULP,      // 0.5 ULP 边界
        SCENE_NEAR_1_0_ULP,     // 1.0 ULP 边界
        SCENE_OVERFLOW_DIRECT,  // 直接上溢
        SCENE_OVERFLOW_ROUND    // 舍入导致上溢
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

        for(i = 0; i < 8192; i++) begin 
            `uvm_info("SEQ", $sformatf("Generating test %0d", i), UVM_LOW)
            tr = PE_seq_item::type_id::create("tr");

            if (!std::randomize(e_a, e_b, e_c, m_a, m_b, m_c, s_a, s_b, s_c, cur_scene) with {
                
                // 场景分布权重
                cur_scene dist {
                    SCENE_RANDOM          := 10,
                    SCENE_CANCELLATION    := 10,
                    SCENE_STICKY          := 0,
                    SCENE_TIE_0_5_ULP     := 0,
                    SCENE_NEAR_1_0_ULP    := 0,
                    SCENE_OVERFLOW_DIRECT := 40, 
                    SCENE_OVERFLOW_ROUND  := 40  
                };

                // 除非是溢出场景，否则限制指数在常规范围
                if (cur_scene != SCENE_OVERFLOW_DIRECT && cur_scene != SCENE_OVERFLOW_ROUND) {
                    e_a inside {[1:254]};
                    e_b inside {[1:254]};
                    e_c inside {[1:254]};
                }

                // --- 场景 1: 灾难性抵消 ---
                if (cur_scene == SCENE_CANCELLATION) {
                    (int'(e_c) + 127) - (int'(e_a) + int'(e_b)) inside {[-1:1]};
                    s_c != (s_a ^ s_b);
                }

                // --- 场景 2: Sticky / 大移位 ---
                if (cur_scene == SCENE_STICKY) {
                    (int'(e_c) + 127) > (int'(e_a) + int'(e_b) + 25);
                    (int'(e_c) + 127) < (int'(e_a) + int'(e_b) + 100);
                }

                // --- 场景 3: 0.5 ULP 边界 ---
                if (cur_scene == SCENE_TIE_0_5_ULP) {
                    (int'(e_c) + 127) == (int'(e_a) + int'(e_b) + 24);
                    m_c[0] == 0; // 配合 RNE 偶数舍入
                }

                // --- 场景 4: 1.0 ULP 边缘 ---
                if (cur_scene == SCENE_NEAR_1_0_ULP) {
                    (int'(e_c) + 127) > (int'(e_a) + int'(e_b) + 40);
                }

                // --- 场景 5: 直接上溢 ---
                if (cur_scene == SCENE_OVERFLOW_DIRECT) {
                    e_a inside {[200:254]};
                    e_b inside {[200:254]};
                    // ExpA + ExpB - 127 > 254 (FP32 Max) => Sum > 381
                    (int'(e_a) + int'(e_b)) > 382;
                    s_c == (s_a ^ s_b); 
                }

                // --- 场景 6: 舍入导致上溢 ---
                if (cur_scene == SCENE_OVERFLOW_ROUND) {
                    // C 固定为最大有限数
                    e_c == 254;
                    m_c == 23'h7FFFFF; 
                    
                    // P (A*B) 位于 0.5 ULP 附近 (Exp_P approx 254-24 = 230)
                    (int'(e_a) + int'(e_b)) inside {[228:232]};
                    
                    s_c == (s_a ^ s_b);
                }
            }) begin
                `uvm_error("SEQ", "Local Randomization Failed")
            end

            // 组装浮点数
            gen_a = {s_a, e_a, m_a};
            gen_b = {s_b, e_b, m_b};
            gen_c = {s_c, e_c, m_c};

            start_item(tr);
            if (!tr.randomize() with {
                // 固定配置
                tr.i_Compute_Mode               == `Outer_Product;
                tr.i_Compute_Precision          == `FP32;
                tr.i_Is_Widening                == `Operands_Is_Not_Widening;
                tr.i_Add_or_Subtract            == `Addition_Operation;
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                
                // 异常处理配置
                tr.i_Exception_Handling[19]     == `Alternative_Half_Precision_Format;
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;
                tr.i_Exception_Handling[16:15]  == `Round_Towards_Plus_Infinity;
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
                tr.i_Operand_C[127:32]          == 96'b0;

                // 填入计算好的操作数
                tr.i_Operand_A[31:0] == gen_a;
                tr.i_Operand_B[31:0] == gen_b;
                tr.i_Operand_C[31:0] == gen_c;
                
            }) begin
               `uvm_error("RND", "Transaction Randomization failed")
            end
            
            finish_item(tr);
            #10;
        end
        
        if (starting_phase != null) begin
            starting_phase.drop_objection(this);
        end

        `uvm_info("SEQ", "Sequence completed", UVM_LOW)
    endtask
endclass
