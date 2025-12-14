`include "macro_definition.svh"
`include "uvm_macros.svh"

class PE_sequence_fdot extends PE_sequence;
    `uvm_object_utils(PE_sequence_fdot)

    function new(string name = "PE_sequence_fdot");
        super.new(name);
    endfunction
    
    task body();
        PE_seq_item tr;
        int i;
        if (starting_phase != null)
            starting_phase.raise_objection(this);
        for(i = 0; i < 50000; i++)begin
            `uvm_info("SEQ", $sformatf("This is%d test", i), UVM_MEDIUM)
            tr = PE_seq_item::type_id::create("tr");

            start_item(tr);
            if (!tr.randomize() with {
                tr.i_Compute_Mode               == `Inner_Product;
                tr.i_Compute_Precision          == `FP16;
                tr.i_Is_Widening                == `Operands_Is_Widening;
                tr.i_Add_or_Subtract            == `Addition_Operation;
                tr.i_Vector_Group_Num           ==  `Single_Vector_Group;
                tr.i_Active_Element_A           == 4'b1111;
                tr.i_Active_Element_B           == 4'b1111;
                tr.i_ZA_Base_Address            == 32'hffff;
                tr.i_Exception_Handling[19]     == `IEEE_Half_Precision_Format;// Alternative_Half_Precision_Format IEEE_Half_Precision_Format
                tr.i_Exception_Handling[18]     == `Operation_Involving_NaNs_Returns_Default_NaN;
                tr.i_Exception_Handling[17]     == `Do_Not_Flush_Denormalized_Results_to_Zero;// Flush_Denormalized_Results_to_Zero Do_Not_Flush_Denormalized_Results_to_Zero
                i_Exception_Handling[16:15] dist {
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
                
                i_Operand_A[31:0] dist {
                    [32'h00000000:32'h7fffffff] :/ 50,
                    [32'h80000001:32'hffffffff] :/ 50
                };

                i_Operand_B[31:0] dist {
                    [32'h00000000:32'h7fffffff] :/ 50,
                    [32'h80000001:32'hffffffff] :/ 50
                };

                i_Operand_C[31:0] dist {
                    [32'h00000000:32'h7fffffff] :/ 50,
                    [32'h80000001:32'hffffffff] :/ 50
                };
                // i_Exception_Handling[16:15] dist {
                //     2'b00 := 25,
                //     2'b01 := 25,
                //     2'b10 := 25,
                //     2'b11 :/ 25 
                // };
            }) begin
               `uvm_error("RND", "Randomization failed")
            end
            
            finish_item(tr);
        end
        // 序列完成后drop objection
        if (starting_phase != null) begin
            starting_phase.drop_objection(this);
        end

        `uvm_info("SEQ", "Sequence completed", UVM_LOW)
    endtask
endclass
