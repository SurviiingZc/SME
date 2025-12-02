class PE_env_scb extends uvm_scoreboard;
    `uvm_component_utils(PE_env_scb)
    
    uvm_analysis_export #(PE_seq_item) sb_export_dut;
    uvm_analysis_export #(PE_seq_item) sb_export_ref;
    
    uvm_tlm_analysis_fifo #(PE_seq_item) fifo_dut;
    uvm_tlm_analysis_fifo #(PE_seq_item) fifo_ref;
    
    int error_count = 0;
    int total_count = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export_dut = new("sb_export_dut", this);
        sb_export_ref = new("sb_export_ref", this);
        fifo_dut = new("fifo_dut", this);
        fifo_ref = new("fifo_ref", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export_dut.connect(fifo_dut.analysis_export);
        sb_export_ref.connect(fifo_ref.analysis_export);
    endfunction
    
    task run_phase(uvm_phase phase);
        PE_seq_item tr_dut, tr_ref;
        
        forever begin
            // 阻塞等待两个fifo都有数据
            fifo_dut.get(tr_dut);
            fifo_ref.get(tr_ref);
            
            total_count++;
            
            // 详细调试信息
            `uvm_info("SB_DEBUG", $sformatf("Comparing transaction %0d:", total_count), UVM_HIGH)
            `uvm_info("SB_DEBUG", $sformatf("  Inputs: A=0x%08h, B=0x%08h, C=0x%08h", 
                      tr_dut.i_Operand_A, tr_dut.i_Operand_B, tr_dut.i_Operand_C[31:0]), UVM_MEDIUM)
            
            // 检查结果是否匹配
            if (tr_dut.o_Result === tr_ref.expected) begin
                `uvm_info("SB", $sformatf("PASS: Transaction %0d matched DUT=0x%08h, REF=0x%08h\n", 
                           total_count, tr_dut.o_Result, tr_ref.expected), UVM_MEDIUM)
            end else begin
                error_count++;
                `uvm_error("SB", $sformatf("FAIL: Transaction %0d mismatch! DUT=0x%08h, REF=0x%08h\n", 
                          total_count, tr_dut.o_Result, tr_ref.expected))
            end
        end
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SB", $sformatf("Test Complete! Total Transactions: %0d, Errors: %0d", 
                    total_count, error_count), UVM_LOW)
        
        if (error_count == 0) begin
            `uvm_info("SB", "*** TEST PASSED ***", UVM_NONE)
        end else begin
            `uvm_error("SB", "*** TEST FAILED ***")
        end
    endfunction
endclass