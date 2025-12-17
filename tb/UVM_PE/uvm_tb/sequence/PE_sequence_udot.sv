`include "macro_definition.svh"
`include "uvm_macros.svh"

class PE_sequence_udot extends PE_sequence;
    `uvm_object_utils(PE_sequence_udot)

    function new(string name = "PE_sequence_udot");
        super.new(name);
    endfunction
    
    task body();
        PE_seq_item tr;
        int i;
        if (starting_phase != null)
            starting_phase.raise_objection(this);
        for(i = 0; i < 10000; i++)begin
            `uvm_info("SEQ", $sformatf("This is%d test", i), UVM_MEDIUM)
            tr = PE_seq_item::type_id::create("tr");

            start_item(tr);
            if (!tr.randomize() with {
                tr.i_Compute_Mode               ==  `Inner_Product;
                tr.i_Compute_Precision          ==  `INT16;
                //tr.i_Is_Widening                ==  `Operands_Is_Widening;
                tr.i_Add_or_Subtract            ==  `Addition_Operation;
                tr.i_ZmIsSigned                 ==  `Zm_Is_Unsigned;
                tr.i_ZnIsSigned                 ==  `Zn_Is_Unsigned;
                //tr.i_Num_of_Vector_Group        ==  `Two_Vector_Group;      
                tr.i_Vector_Group_Num           ==  `Single_Vector_Group;
                tr.i_Active_Element_A           ==  4'b1111;
                tr.i_Active_Element_B           ==  4'b1111;
                // tr.i_ZA_Base_Address            ==  32'hffff;
                tr.i_Exception_Handling[19:17]  == 3'b0;
                tr.i_Exception_Handling[14:0]   == 15'b0;
               
                // tr.i_Operand_A[31:0] == 32'h00000001;
                // tr.i_Operand_B[31:0] == 32'h00000001;
                // tr.i_Operand_C[31:0] == 32'h00000001;

                //tr.i_Exception_Handling[16:15] == 2'b01;

                i_Operand_A[31:0] dist {
                    [32'h00000000:32'h7fffffff] :/ 50,
                    [32'h80000000:32'hffffffff] :/ 50
                };

                i_Operand_B[31:0] dist {
                    [32'h00000000:32'h3fffffff] :/ 50,
                    [32'h80000000:32'hbfffffff] :/ 50
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
