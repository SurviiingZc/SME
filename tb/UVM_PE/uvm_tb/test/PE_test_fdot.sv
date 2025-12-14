`ifndef PE_TEST_FDOT_SV
`define PE_TEST_FDOT_SV

class PE_test_fdot extends uvm_test;
    `uvm_component_utils(PE_test_fdot)
    
    PE_env env;

    
    function new(string name = "PE_test_fdot", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = PE_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        PE_sequence_fmlal   seq_fmlal;
        PE_sequence_fmla    seq_fmla;
        PE_sequence_fdot    seq_fdot;

        seq_fmlal   = PE_sequence_fmlal::type_id::create("seq_fmlal");
        // seq_fmla    = PE_sequence_fmla::type_id::create("seq_fmla");
        // seq_fdot    = PE_sequence_fdot::type_id::create("seq_fdot");

        phase.raise_objection(this);
        
        `uvm_info("TEST", "Running float dot test", UVM_LOW)
        seq_fmlal.start(env.agent.sequencer); 
        // seq_fmla.start(env.agent.sequencer);  
        // seq_fdot.start(env.agent.sequencer);
          
        phase.drop_objection(this);
        
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST", "Simulation completed", UVM_LOW)
    endfunction
endclass : PE_test_fdot

`endif
