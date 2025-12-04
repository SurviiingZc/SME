// `ifdef Is_PipLine
//     class PE_driver extends uvm_driver #(PE_seq_item);
//         `uvm_component_utils(PE_driver)
        
//         virtual PE_interface vif;
//         int transaction_count = 0;
        
//         // 流水线队列
//         PE_seq_item req_fifo[$];  // 请求队列
//         int pipeline_counter[$];   // 流水线计数器队列
        
//         // 流水线控制
//         bit pipeline_enabled = 1;  // 流水线使能
//         int pipeline_depth = 6;    // 流水线深度（固定6周期）
        
//         function new(string name, uvm_component parent);
//             super.new(name, parent);
//         endfunction
        
//         function void build_phase(uvm_phase phase);
//             super.build_phase(phase);
//             if (!uvm_config_db#(virtual PE_interface)::get(this, "", "vif", vif))
//                 `uvm_fatal("NOVIF", "Virtual interface not set")
//         endfunction
        
//         task run_phase(uvm_phase phase);
//             if(!vif.rst_n)
//                 reset_signals();
            
//             // 等待复位释放
//             wait(vif.rst_n);
//             @(vif.drv_cb);
            
//             // 创建并行进程
//             fork
//                 get_and_queue_transactions();
//                 drive_transactions();
//                 // manage_pipeline();
//             join
//         endtask
        
//         // 任务1：从sequencer获取事务并放入队列
//         task get_and_queue_transactions();
//             forever begin
//                 PE_seq_item tr;
                
//                 // 获取新事务
//                 seq_item_port.get_next_item(tr);
//                 tr.is_request = 1;
//                 tr.input_time = $time;
//                 transaction_count++;
                
//                 `uvm_info("DRIVER", $sformatf("Received transaction %0d at time %0t", 
//                         transaction_count, $time), UVM_LOW)
                
//                 // 放入请求队列
//                 req_fifo.push_back(tr);
                
//                 // // 初始化流水线计数器
//                 // pipeline_counter.push_back(0);
                
//                 seq_item_port.item_done();
//             end
//         endtask
        
//         // 任务2：驱动事务到DUT
//         task drive_transactions();
//             PE_seq_item tr;
//             forever begin                
//                 // 如果需要驱动新事务
//                 if(req_fifo.size() > 0) begin
//                     tr = req_fifo.pop_front();  // 查看队列头
                    
//                     // 驱动输入信号
//                     vif.drv_cb.i_Compute_Mode        <= tr.i_Compute_Mode;
//                     vif.drv_cb.i_Compute_Precision   <= tr.i_Compute_Precision;
//                     vif.drv_cb.i_Is_Widening         <= tr.i_Is_Widening;
//                     vif.drv_cb.i_Add_or_Subtract     <= tr.i_Add_or_Subtract;
//                     vif.drv_cb.i_ZmIsSigned          <= tr.i_ZmIsSigned;
//                     vif.drv_cb.i_ZnIsSigned          <= tr.i_ZnIsSigned;
//                     vif.drv_cb.i_Num_of_Vector_Group <= tr.i_Num_of_Vector_Group;
//                     vif.drv_cb.i_Vector_Group_Num    <= tr.i_Vector_Group_Num;
//                     vif.drv_cb.i_Exception_Handling  <= tr.i_Exception_Handling;
//                     vif.drv_cb.i_ZA_Base_Address     <= tr.i_ZA_Base_Address;
//                     vif.drv_cb.i_Active_Element_A    <= tr.i_Active_Element_A;
//                     vif.drv_cb.i_Active_Element_B    <= tr.i_Active_Element_B;
//                     vif.drv_cb.i_Operand_A           <= tr.i_Operand_A;
//                     vif.drv_cb.i_Operand_B           <= tr.i_Operand_B;
//                     vif.drv_cb.i_Operand_C           <= tr.i_Operand_C;
                    
//                     `uvm_info("DRIVER", $sformatf("Driving transaction %0d: A=0x%08h, B=0x%08h", 
//                             transaction_count, 
//                             tr.i_Operand_A, tr.i_Operand_B), UVM_LOW)
//                 end else begin
//                     // 队列为空时驱动默认值
//                     reset_signals();
//                 end
//                 @(vif.drv_cb);
//             end
//         endtask
        
//         // 任务3：管理流水线计数器
//         task manage_pipeline();
//             forever begin
                
//                 // 更新所有在流水线中的事务计数器
//                 for(int i = 0; i < pipeline_counter.size(); i++) begin
//                     if(pipeline_counter[i] < pipeline_depth) begin
//                         pipeline_counter[i]++;
                        
//                         // 如果事务完成流水线
//                         if(pipeline_counter[i] == pipeline_depth) begin
//                             // 从队列中移除已完成的事务
//                             PE_seq_item completed_tr = req_fifo[0];
//                             req_fifo.delete(0);
//                             pipeline_counter.delete(0);
                            
//                             `uvm_info("DRIVER", $sformatf("Transaction completed pipeline at time %0t", 
//                                     $time), UVM_HIGH)
//                         end
//                     end
//                 end
//                 @(vif.drv_cb);
//             end
//         endtask

//         virtual function void reset_signals();
//             vif.drv_cb.i_Compute_Mode        <= 0;
//             vif.drv_cb.i_Compute_Precision   <= 0;
//             vif.drv_cb.i_Is_Widening         <= 0;
//             vif.drv_cb.i_Add_or_Subtract     <= 0;
//             vif.drv_cb.i_ZmIsSigned          <= 0;
//             vif.drv_cb.i_ZnIsSigned          <= 0;
//             vif.drv_cb.i_Num_of_Vector_Group <= 0;
//             vif.drv_cb.i_Vector_Group_Num    <= 0;
//             vif.drv_cb.i_Exception_Handling  <= 0;
//             vif.drv_cb.i_ZA_Base_Address     <= 0;
//             vif.drv_cb.i_Active_Element_A    <= 0;
//             vif.drv_cb.i_Active_Element_B    <= 0;
//             vif.drv_cb.i_Operand_A           <= 0;
//             vif.drv_cb.i_Operand_B           <= 0;
//             vif.drv_cb.i_Operand_C           <= 0;
//         endfunction
//     endclass

// `else
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
// `endif