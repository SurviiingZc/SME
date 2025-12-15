`ifndef PE_TEST_BFMOP_SV
`define PE_TEST_BFMOP_SV

class PE_test_bfmop extends uvm_test;
    `uvm_component_utils(PE_test_bfmop)
    
    PE_env env;
    
    function new(string name = "PE_test_bfmop", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = PE_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        PE_sequence_bfmopa  seq_bfmopa;
        PE_sequence_bfmops  seq_bfmops;
        PE_sequence_bfmopa  seq_bfmopa_EBF;
        PE_sequence_bfmops  seq_bfmops_EBF;
        seq_bfmopa      = PE_sequence_bfmopa::type_id::create("seq_bfmopa");
        seq_bfmops      = PE_sequence_bfmops::type_id::create("seq_bfmops");
        seq_bfmopa_EBF  = PE_sequence_bfmopa::type_id::create("seq_bfmopa");
        seq_bfmops_EBF  = PE_sequence_bfmops::type_id::create("seq_bfmops");
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Running bfmop test", UVM_LOW)
        seq_bfmopa.start(env.agent.sequencer);
        seq_bfmops.start(env.agent.sequencer);
        seq_bfmopa_EBF.start(env.agent.sequencer);
        seq_bfmops_EBF.start(env.agent.sequencer);  
        phase.drop_objection(this);
        
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST", "Simulation completed", UVM_LOW)
    endfunction
endclass : PE_test_bfmop

`endif
