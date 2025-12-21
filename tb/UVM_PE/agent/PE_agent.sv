`ifndef PE_AGENT_SV
`define PE_AGENT_SV

class PE_agent extends uvm_agent;
    `uvm_component_utils(PE_agent)
    
    uvm_analysis_port #(PE_seq_item) agt_ap;
    PE_driver driver;
    PE_monitor monitor;
    PE_sequencer sequencer; // 使用自定义序列器
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        agt_ap = new("agt_ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = PE_monitor::type_id::create("monitor", this);
        driver = PE_driver::type_id::create("driver", this);
        sequencer = PE_sequencer::type_id::create("sequencer", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.mon_ap.connect(agt_ap);
    endfunction
endclass

`endif // PE_AGENT_SV