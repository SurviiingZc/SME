`ifndef PE_TEST_FMOP_SV
`define PE_TEST_FMOP_SV

class PE_test_fmop extends uvm_test;
    `uvm_component_utils(PE_test_fmop)
    
    PE_env env;

    
    function new(string name = "PE_test_fmop", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = PE_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        PE_sequence_fmopa   seq_fmopa;
        PE_sequence_fmopa_w seq_fmopa_w;
        PE_sequence_fmops   seq_fmops;
        PE_sequence_fmops_w seq_fmops_w;

        seq_fmopa   = PE_sequence_fmopa::type_id::create("seq_fmopa");
        // seq_fmopa_w = PE_sequence_fmopa_w::type_id::create("seq_fmopa_w");
        seq_fmops   = PE_sequence_fmops::type_id::create("seq_fmops");
        // seq_fmops_w = PE_sequence_fmops_w::type_id::create("seq_fmops_w");
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Running fmop test", UVM_LOW)
        seq_fmopa.start(env.agent.sequencer);
        // seq_fmopa_w.start(env.agent.sequencer);
        seq_fmops.start(env.agent.sequencer);
        // seq_fmops_w.start(env.agent.sequencer);

        phase.drop_objection(this);
        
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST", "Simulation completed", UVM_LOW)
    endfunction
endclass : PE_test_fmop

`endif 
