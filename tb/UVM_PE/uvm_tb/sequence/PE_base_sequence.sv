`include "macro_definition.svh"
`include "uvm_macros.svh"
class PE_sequence extends uvm_sequence #(PE_seq_item);
 `uvm_object_utils(PE_sequence)
    
    function new(string name = "PE_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        PE_seq_item tr;
        tr = PE_seq_item::type_id::create("tr");
        start_item(tr);
        if (!tr.randomize()) 
            `uvm_error("RND", "Randomization failed")
        finish_item(tr);
    endtask
endclass


