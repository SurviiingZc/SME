class PE_monitor extends uvm_monitor;
    `uvm_component_utils(PE_monitor)
    
    uvm_analysis_port #(PE_seq_item) mon_ap;
    virtual PE_interface vif;
    
    int mon_item_num = 0;
    bit sampling_enabled = 0;
    int sample_delay = 0;
    int delay_cnt = 0;
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
        mon_ap = new("mon_ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual PE_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
        PE_seq_item current_tr;
        
        // 等待复位释放
        wait(vif.rst_n);
        @(vif.mon_cb);
        
        forever begin
            // 检测新事务开始（输入信号变化）
            sampling_enabled = 1;
            // sample_delay = 0;
            
            // 创建新事务并采样输入
            current_tr = PE_seq_item::type_id::create("current_tr");
            current_tr.i_Compute_Mode        = vif.mon_cb.i_Compute_Mode;
            current_tr.i_Compute_Precision   = vif.mon_cb.i_Compute_Precision;
            current_tr.i_Is_Widening         = vif.mon_cb.i_Is_Widening;
            current_tr.i_Add_or_Subtract     = vif.mon_cb.i_Add_or_Subtract;
            current_tr.i_ZmIsSigned          = vif.mon_cb.i_ZmIsSigned;
            current_tr.i_ZnIsSigned          = vif.mon_cb.i_ZnIsSigned;
            current_tr.i_Num_of_Vector_Group = vif.mon_cb.i_Num_of_Vector_Group;
            current_tr.i_Vector_Group_Num    = vif.mon_cb.i_Vector_Group_Num;
            current_tr.i_Exception_Handling  = vif.mon_cb.i_Exception_Handling;
            current_tr.i_ZA_Base_Address     = vif.mon_cb.i_ZA_Base_Address;
            current_tr.i_Active_Element_A    = vif.mon_cb.i_Active_Element_A;
            current_tr.i_Active_Element_B    = vif.mon_cb.i_Active_Element_B;
            current_tr.i_Operand_A           = vif.mon_cb.i_Operand_A;
            current_tr.i_Operand_B           = vif.mon_cb.i_Operand_B;
            current_tr.i_Operand_C           = vif.mon_cb.i_Operand_C;
            
            `uvm_info("MONITOR", $sformatf("Started monitoring transaction at time %0t", $time), UVM_HIGH)
            `ifdef Is_PipLine
                if (sample_delay == 0) begin
                    repeat(7) @(vif.mon_cb);
                    sample_delay = 1;
                end else 
                    repeat(6) @(vif.mon_cb);                
            `else
                // if(sample_delay) begin
                //     @(vif.mon_cb);
                //     sample_delay = 0;
                // end
                // delay_cnt = 1;
            `endif                            
            
            current_tr.o_Result = vif.mon_cb.o_Result;
            mon_ap.write(current_tr);
            mon_item_num++;
            
            `uvm_info("MONITOR", $sformatf("Completed transaction %0d at time %0t, A=0x%08h, C = 0x%08h, result=0x%08h", 
                      mon_item_num, $time, current_tr.i_Operand_A, current_tr.i_Operand_C, current_tr.o_Result), UVM_MEDIUM)
            
            @(vif.mon_cb);
        end
    endtask
    
    // 检测输入信号是否发生变化（新事务开始）
    function bit inputs_changed();
        // 检查关键输入信号是否非零，表示新事务开始
        return (vif.mon_cb.i_Operand_A != 0 || 
                vif.mon_cb.i_Operand_B != 0 ||
                vif.mon_cb.i_Operand_C != 0);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), 
            $sformatf("Captured %0d transactions", mon_item_num), UVM_LOW)
    endfunction
endclass