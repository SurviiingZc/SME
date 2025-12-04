class PE_driver extends uvm_driver #(PE_seq_item);
    `uvm_component_utils(PE_driver)
    
    virtual PE_interface vif;
    int transaction_count = 0;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual PE_interface)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not set")
    endfunction
    
    task run_phase(uvm_phase phase);
        if(!vif.rst_n)
            reset_signals();
        
        // 等待复位释放
        wait(vif.rst_n);
        //@(vif.drv_cb);
        
        forever begin
            PE_seq_item tr;
            
            @(vif.drv_cb);
            // 获取新事务
            seq_item_port.get_next_item(tr);
            transaction_count++;
            `uvm_info("DRIVER", $sformatf("Driving transaction %0d at time %0t", 
                      transaction_count, $time), UVM_HIGH)
            // 驱动输入信号
            vif.drv_cb.i_Compute_Mode        <= tr.i_Compute_Mode;
            vif.drv_cb.i_Compute_Precision   <= tr.i_Compute_Precision;
            vif.drv_cb.i_Is_Widening         <= tr.i_Is_Widening;
            vif.drv_cb.i_Add_or_Subtract     <= tr.i_Add_or_Subtract;
            vif.drv_cb.i_ZmIsSigned          <= tr.i_ZmIsSigned;
            vif.drv_cb.i_ZnIsSigned          <= tr.i_ZnIsSigned;
            vif.drv_cb.i_Num_of_Vector_Group <= tr.i_Num_of_Vector_Group;
            vif.drv_cb.i_Vector_Group_Num    <= tr.i_Vector_Group_Num;
            vif.drv_cb.i_Exception_Handling  <= tr.i_Exception_Handling;
            vif.drv_cb.i_ZA_Base_Address     <= tr.i_ZA_Base_Address;
            vif.drv_cb.i_Active_Element_A    <= tr.i_Active_Element_A;
            vif.drv_cb.i_Active_Element_B    <= tr.i_Active_Element_B;
            vif.drv_cb.i_Operand_A           <= tr.i_Operand_A;
            vif.drv_cb.i_Operand_B           <= tr.i_Operand_B;
            vif.drv_cb.i_Operand_C           <= tr.i_Operand_C;
            
            `uvm_info("DRIVER", $sformatf("Inputs:i_Active_Element_A=0x%08h, A=0x%08h, B=0x%08h, C=0x%08h", 
                      tr.i_Active_Element_A,tr.i_Operand_A, tr.i_Operand_B, tr.i_Operand_C[31:0]), UVM_HIGH)
            
            // 保持输入信号稳定6个周期
            `ifdef Is_PipLine
                repeat(5) @(vif.drv_cb);
            `endif

            // 在第6个周期捕获输出
            // tr.o_Result = vif.drv_cb.o_Result;
            // `uvm_info("DRIVER", $sformatf("Captured output: 0x%08h", tr.o_Result), UVM_HIGH)
            
            seq_item_port.item_done();

        end
    endtask

    virtual function void reset_signals();
        vif.drv_cb.i_Compute_Mode        <= 0;
        vif.drv_cb.i_Compute_Precision   <= 0;
        vif.drv_cb.i_Is_Widening         <= 0;
        vif.drv_cb.i_Add_or_Subtract     <= 0;
        vif.drv_cb.i_ZmIsSigned          <= 0;
        vif.drv_cb.i_ZnIsSigned          <= 0;
        vif.drv_cb.i_Num_of_Vector_Group <= 0;
        vif.drv_cb.i_Vector_Group_Num    <= 0;
        vif.drv_cb.i_Exception_Handling  <= 0;
        vif.drv_cb.i_ZA_Base_Address     <= 0;
        vif.drv_cb.i_Active_Element_A    <= 0;
        vif.drv_cb.i_Active_Element_B    <= 0;
        vif.drv_cb.i_Operand_A           <= 0;
        vif.drv_cb.i_Operand_B           <= 0;
        vif.drv_cb.i_Operand_C           <= 0;
    endfunction
endclass