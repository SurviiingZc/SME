`ifndef PE_SEQUENCER_SV
`define PE_SEQUENCER_SV

class PE_sequencer extends uvm_sequencer #(PE_seq_item);
    `uvm_component_utils(PE_sequencer)

    extern function new(string name = "PE_sequencer", uvm_component parent = null);
endclass : PE_sequencer

function PE_sequencer::new(string name = "PE_sequencer", uvm_component parent = null);
    super.new(name, parent);
    
    `uvm_info(get_type_name(), "created", UVM_LOW)
endfunction : new

`endif // PE_SEQUENCER_SV