`ifndef PE_ENV_SV
`define PE_ENV_SV

class PE_env extends uvm_env;
    `uvm_component_utils(PE_env)
    
    PE_agent agent;
    PE_env_refm ref_model;
    PE_env_scb scoreboard;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = PE_agent::type_id::create("agent", this);
        ref_model = PE_env_refm::type_id::create("ref_model", this);
        scoreboard = PE_env_scb::type_id::create("scoreboard", this);

    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.agt_ap.connect(ref_model.item_collected_export);
        ref_model.item_ref_port.connect(scoreboard.sb_export_ref);
        agent.agt_ap.connect(scoreboard.sb_export_dut);

    endfunction
endclass : PE_env

`endif // PE_ENV_SV