`ifndef PE_MONITOR_SV
`define PE_MONITOR_SV

`ifdef Is_PipLine
    class PE_monitor extends uvm_monitor;
        `uvm_component_utils(PE_monitor)
        
        uvm_analysis_port #(PE_seq_item) mon_ap;
        virtual PE_interface vif;
        
        // 流水线相关
        PE_seq_item input_queue[$];    // 输入事务队列
        int pipeline_stages[$];         // 流水线阶段队列
        int pipeline_depth = 7;         // 默认7周期延迟，整数为3
        
        int mon_item_num = 0;
        
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
            // 等待复位释放
            wait(vif.rst_n);
            @(vif.mon_cb);
            
            fork
                monitor_inputs();      // 监控输入
                monitor_outputs();     // 监控输出
                update_pipeline();     // 更新流水线状态
            join
        endtask
        
        // 任务1：监控输入
        task monitor_inputs();
            forever begin
                @(vif.mon_cb);
                
                // 检测是否有有效输入
                if(inputs_changed()) begin
                    PE_seq_item tr = PE_seq_item::type_id::create("tr");
                    
                    // 采样输入信号
                    tr.i_Compute_Mode        = vif.mon_cb.i_Compute_Mode;
                    tr.i_Compute_Precision   = vif.mon_cb.i_Compute_Precision;
                    tr.i_Is_Widening         = vif.mon_cb.i_Is_Widening;
                    tr.i_Add_or_Subtract     = vif.mon_cb.i_Add_or_Subtract;
                    tr.i_ZmIsSigned          = vif.mon_cb.i_ZmIsSigned;
                    tr.i_ZnIsSigned          = vif.mon_cb.i_ZnIsSigned;
                    tr.i_Num_of_Vector_Group = vif.mon_cb.i_Num_of_Vector_Group;
                    tr.i_Vector_Group_Num    = vif.mon_cb.i_Vector_Group_Num;
                    tr.i_Exception_Handling  = vif.mon_cb.i_Exception_Handling;
                    tr.i_ZA_Base_Address     = vif.mon_cb.i_ZA_Base_Address;
                    tr.i_Active_Element_A    = vif.mon_cb.i_Active_Element_A;
                    tr.i_Active_Element_B    = vif.mon_cb.i_Active_Element_B;
                    tr.i_Operand_A           = vif.mon_cb.i_Operand_A;
                    tr.i_Operand_B           = vif.mon_cb.i_Operand_B;
                    tr.i_Operand_C           = vif.mon_cb.i_Operand_C;
                    
                    tr.is_request = 1;
                    tr.input_time = $time;
                    tr.pipeline_stage = 0;
                    
                    // 放入队列
                    input_queue.push_back(tr);
                    pipeline_stages.push_back(0);
                    
                    mon_item_num++;
                    
                    `uvm_info("MONITOR", $sformatf("Captured input %0d at time %0t, A=0x%08h, B=0x%08h, C=0x%08h", 
                            mon_item_num, $time, tr.i_Operand_A, tr.i_Operand_B, tr.i_Operand_C), UVM_MEDIUM)
                end
            end
        endtask
        
        // 任务2：监控输出
        task monitor_outputs();
            forever begin
                @(vif.mon_cb);
                if(vif.i_Compute_Precision == `INT16 || vif.i_Compute_Precision == `INT8) begin
                    pipeline_depth = 3; // 整数模式3周期延迟
                end else begin
                    pipeline_depth = 7; // 浮点模式7周期延迟
                end
                // 检查队列中是否有事务已完成流水线
                if(pipeline_stages.size() > 0 && pipeline_stages[0] >= pipeline_depth) begin
                    // 获取最早的事务
                    PE_seq_item tr = input_queue[0];
                    PE_seq_item rsp_tr;
                    
                    // 创建响应事务
                    rsp_tr = PE_seq_item::type_id::create("rsp_tr");
                    rsp_tr.copy_from(tr);
                    rsp_tr.is_request = 0;
                    rsp_tr.o_Result = vif.mon_cb.o_Result;
                    
                    // 计算期望结果（这里需要您的reference model）
                    // rsp_tr.expected = calculate_expected(tr);
                    
                    // 通过analysis port发送
                    mon_ap.write(rsp_tr);
                    
                    // 从队列中移除
                    input_queue.delete(0);
                    pipeline_stages.delete(0);
                    
                    `uvm_info("MONITOR", $sformatf("Captured output for transaction at time %0t, result=0x%032h", 
                            $time, rsp_tr.o_Result), UVM_MEDIUM)
                end
            end
        endtask
        
        // 任务3：更新流水线状态
        task update_pipeline();
            forever begin
                @(vif.mon_cb);
                
                // 更新所有在流水线中的事务阶段
                for(int i = 0; i < pipeline_stages.size(); i++) begin
                    pipeline_stages[i] = pipeline_stages[i] + 1;
                    
                    // 更新事务中的流水线阶段
                    if(i < input_queue.size()) begin
                        input_queue[i].pipeline_stage = pipeline_stages[i];
                    end
                end
            end
        endtask
        
        // 检测输入信号是否发生变化（新事务开始）
        function bit inputs_changed();
            // 检查是否有非零输入，表示新事务开始
            // 您可以根据实际需求调整这个判断逻辑
            static bit [31:0] last_operand_A = 0;
            static bit [31:0] last_operand_B = 0;
            static bit [127:0] last_operand_C = 0;
            
            bit changed = (vif.mon_cb.i_Operand_A != last_operand_A) ||
                          (vif.mon_cb.i_Operand_B != last_operand_B) ||
                          (vif.mon_cb.i_Operand_C != last_operand_C);
            
            last_operand_A = vif.mon_cb.i_Operand_A;
            last_operand_B = vif.mon_cb.i_Operand_B;
            last_operand_C = vif.mon_cb.i_Operand_C;
            
            return changed;
        endfunction

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info(get_type_name(), 
                $sformatf("Captured %0d transactions", mon_item_num), UVM_LOW)
        endfunction
    endclass
`else
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
                // sample_delay = 0;
                @(vif.mon_cb);
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
                
                current_tr.o_Result = vif.mon_cb.o_Result;
                mon_ap.write(current_tr);
                mon_item_num++;
                
                `uvm_info("MONITOR", $sformatf("Completed transaction %0d at time %0t, A=0x%08h, C = 0x%08h, result=0x%08h", 
                        mon_item_num, $time, current_tr.i_Operand_A, current_tr.i_Operand_C, current_tr.o_Result), UVM_MEDIUM)
        
            end
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info(get_type_name(), 
                $sformatf("Captured %0d transactions", mon_item_num), UVM_LOW)
        endfunction
    endclass
`endif
`endif // PE_MONITOR_SV