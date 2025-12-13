`ifndef PE_TEST_ALL_SV
`define PE_TEST_ALL_SV

class PE_test_all extends uvm_test;
    `uvm_component_utils(PE_test_all)
    
    PE_env env;

    
    function new(string name = "PE_test_all", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = PE_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        PE_sequence_smopa   seq_smopa;
        PE_sequence_smops   seq_smops;
        PE_sequence_sumopa  seq_sumopa;
        PE_sequence_sumops  seq_sumops;
        PE_sequence_umopa   seq_umopa;
        PE_sequence_umops   seq_umops;
        PE_sequence_usmopa  seq_usmopa;
        PE_sequence_usmops  seq_usmops;
        PE_sequence_udot    seq_udot;
        PE_sequence_sdot    seq_sdot;
        PE_sequence_smlal   seq_smlal;
        PE_sequence_smlall  seq_smlall;
        PE_sequence_umlal   seq_umlal;
        PE_sequence_umlall  seq_umlall;
        PE_sequence_fmopa   seq_fmopa;
        PE_sequence_fmopa_w seq_fmopa_w;
        PE_sequence_fmops   seq_fmops;
        PE_sequence_fmops_w seq_fmops_w;
        PE_sequence_fmlal   seq_fmlal;
        PE_sequence_fmla    seq_fmla;
        PE_sequence_bfmopa  seq_bfmopa;
        PE_sequence_bfmops  seq_bfmops;
        PE_sequence_fdot    seq_fdot;

        // seq_smopa   = PE_sequence_smopa::type_id::create("seq_smopa");
        // seq_smops   = PE_sequence_smops::type_id::create("seq_smops") ;
        // seq_sumopa  = PE_sequence_sumopa::type_id::create("seq_sumopa") ;
        // seq_sumops  = PE_sequence_sumops::type_id::create("seq_sumops") ;
        // seq_umopa   = PE_sequence_umopa::type_id::create("seq_umopa") ;
        // seq_umops   = PE_sequence_umops::type_id::create("seq_umops") ;
        // seq_usmopa  = PE_sequence_usmopa::type_id::create("seq_usmopa") ;
        // seq_usmops  = PE_sequence_usmops::type_id::create("seq_usmops") ;
        // seq_udot    = PE_sequence_udot::type_id::create("seq_udot") ;
        // seq_sdot    = PE_sequence_sdot::type_id::create("seq_sdot") ;
        // seq_smlal   = PE_sequence_smlal::type_id::create("seq_smlal")  ;
        // seq_smlall  = PE_sequence_smlall::type_id::create("seq_smlall") ;
        // seq_umlal   = PE_sequence_umlal::type_id::create("seq_umlal") ;
        // seq_umlall  = PE_sequence_umlall::type_id::create("seq_umlall");
        seq_fmopa   = PE_sequence_fmopa::type_id::create("seq_fmopa");
        seq_fmopa_w = PE_sequence_fmopa_w::type_id::create("seq_fmopa_w");
        seq_fmops   = PE_sequence_fmops::type_id::create("seq_fmops");
        seq_fmops_w = PE_sequence_fmops_w::type_id::create("seq_fmops_w");
        // seq_fmlal   = PE_sequence_fmlal::type_id::create("seq_fmlal");
        seq_fmla    = PE_sequence_fmla::type_id::create("seq_fmla");
        seq_bfmopa  = PE_sequence_bfmopa::type_id::create("seq_bfmopa");
        seq_bfmops  = PE_sequence_bfmops::type_id::create("seq_bfmops");
        seq_fdot    = PE_sequence_fdot::type_id::create("seq_fdot");

        phase.raise_objection(this);
        
        `uvm_info("TEST", "Running all test", UVM_LOW)
        // seq_smopa.start(env.agent.sequencer);  
        // seq_smops.start(env.agent.sequencer);  
        // seq_sumopa.start(env.agent.sequencer); 
        // seq_sumops.start(env.agent.sequencer); 
        // seq_umopa.start(env.agent.sequencer); 
        // seq_umops.start(env.agent.sequencer);  
        // seq_usmopa.start(env.agent.sequencer); 
        // seq_usmops.start(env.agent.sequencer); 
        // seq_udot.start(env.agent.sequencer);   
        // seq_sdot.start(env.agent.sequencer);   
        // seq_smlal.start(env.agent.sequencer);  
        // seq_smlall.start(env.agent.sequencer); 
        // seq_umlal.start(env.agent.sequencer);  
        // seq_umlall.start(env.agent.sequencer);           
        seq_fmopa.start(env.agent.sequencer);
        seq_fmopa_w.start(env.agent.sequencer);
        seq_fmops.start(env.agent.sequencer);  
        seq_fmops_w.start(env.agent.sequencer);
        // seq_fmlal.start(env.agent.sequencer); 
        seq_fmla.start(env.agent.sequencer);  
        seq_bfmopa.start(env.agent.sequencer);
        seq_bfmops.start(env.agent.sequencer);
        seq_fdot.start(env.agent.sequencer);
          
        phase.drop_objection(this);
        
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST", "Simulation completed", UVM_LOW)
    endfunction
endclass : PE_test_all

`endif
