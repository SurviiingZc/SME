`ifndef PE_SEQ_ITEM_SV
`define PE_SEQ_ITEM_SV

`ifdef Is_PipLine
    class PE_seq_item extends uvm_sequence_item;    
        rand bit            i_Compute_Mode          ;//四值逻辑
        rand bit  [ 2:0]    i_Compute_Precision     ;
        rand bit            i_Is_Widening           ;
        rand bit            i_Add_or_Subtract       ;
        rand bit            i_ZmIsSigned            ;
        rand bit            i_ZnIsSigned            ;
        rand bit            i_Num_of_Vector_Group   ;
        rand bit  [ 1:0]    i_Vector_Group_Num      ;
        rand bit  [19:0]    i_Exception_Handling    ;
        rand bit  [ 3:0]    i_Active_Element_A      ;
        rand bit  [ 3:0]    i_Active_Element_B      ;
        rand bit  [31:0]    i_ZA_Base_Address       ;//二值逻辑

        rand bit  [31:0]    i_Operand_A             ;
        rand bit  [31:0]    i_Operand_B             ;
        rand bit  [127:0]   i_Operand_C             ; //超过32位就不能用randc

        logic     [127:0]   o_Result                ;
        logic     [127:0]   expected                ;

        // 流水线相关字段
        bit                 is_request;     // 标识请求/响应
        int                 pipeline_stage; // 流水线阶段（0-5）
        time                input_time;     // 输入时间戳

        `uvm_object_utils_begin(PE_seq_item)
            `uvm_field_int(i_Compute_Mode, UVM_ALL_ON)
            `uvm_field_int(i_Compute_Precision, UVM_ALL_ON)
            `uvm_field_int(i_Is_Widening, UVM_ALL_ON)
            `uvm_field_int(i_Add_or_Subtract, UVM_ALL_ON)
            `uvm_field_int(i_ZmIsSigned, UVM_ALL_ON)
            `uvm_field_int(i_ZnIsSigned, UVM_ALL_ON)
            `uvm_field_int(i_Num_of_Vector_Group, UVM_ALL_ON)
            `uvm_field_int(i_Vector_Group_Num, UVM_ALL_ON)
            `uvm_field_int(i_Exception_Handling, UVM_ALL_ON)
            `uvm_field_int(i_Active_Element_A, UVM_ALL_ON)
            `uvm_field_int(i_Active_Element_B, UVM_ALL_ON)
            `uvm_field_int(i_ZA_Base_Address, UVM_ALL_ON)
            `uvm_field_int(i_Operand_A, UVM_ALL_ON)
            `uvm_field_int(i_Operand_B, UVM_ALL_ON)
            `uvm_field_int(i_Operand_C, UVM_ALL_ON)

            `uvm_field_int(o_Result, UVM_ALL_ON)
            `uvm_field_int(expected, UVM_ALL_ON)
            `uvm_field_int(is_request, UVM_ALL_ON)
            `uvm_field_int(pipeline_stage, UVM_ALL_ON)

        `uvm_object_utils_end

        // 构造函数
        function new(string name = "PE_seq_item");
            super.new(name);
            `uvm_info(get_type_name(), "created", UVM_FULL)
        endfunction

        // 复制函数
        function void copy_from(PE_seq_item rhs);
            this.i_Compute_Mode = rhs.i_Compute_Mode;
            this.i_Compute_Precision = rhs.i_Compute_Precision;
            this.i_Is_Widening = rhs.i_Is_Widening;
            this.i_Add_or_Subtract = rhs.i_Add_or_Subtract;
            this.i_ZmIsSigned = rhs.i_ZmIsSigned;
            this.i_ZnIsSigned = rhs.i_ZnIsSigned;
            this.i_Num_of_Vector_Group = rhs.i_Num_of_Vector_Group;
            this.i_Vector_Group_Num = rhs.i_Vector_Group_Num;
            this.i_Exception_Handling = rhs.i_Exception_Handling;
            this.i_Active_Element_A = rhs.i_Active_Element_A;
            this.i_Active_Element_B = rhs.i_Active_Element_B;
            this.i_ZA_Base_Address = rhs.i_ZA_Base_Address;
            this.i_Operand_A = rhs.i_Operand_A;
            this.i_Operand_B = rhs.i_Operand_B;
            this.i_Operand_C = rhs.i_Operand_C;
            this.input_time = rhs.input_time;
        endfunction
    endclass
`else
    class PE_seq_item extends uvm_sequence_item;    
        rand bit            i_Compute_Mode          ;//四值逻辑
        rand bit  [ 2:0]    i_Compute_Precision     ;
        rand bit            i_Is_Widening           ;
        rand bit            i_Add_or_Subtract       ;
        rand bit            i_ZmIsSigned            ;
        rand bit            i_ZnIsSigned            ;
        rand bit            i_Num_of_Vector_Group   ;
        rand bit  [ 1:0]    i_Vector_Group_Num      ;
        rand bit  [19:0]    i_Exception_Handling    ;
        rand bit  [ 3:0]    i_Active_Element_A      ;
        rand bit  [ 3:0]    i_Active_Element_B      ;
        rand bit  [31:0]    i_ZA_Base_Address       ;//二值逻辑

        rand bit  [31:0]    i_Operand_A             ;
        rand bit  [31:0]    i_Operand_B             ;
        rand bit  [127:0]   i_Operand_C             ; //超过32位就不能用randc

        logic     [127:0]   o_Result                ;
        logic     [127:0]   expected                ;  


        `uvm_object_utils_begin(PE_seq_item)
            `uvm_field_int(i_Compute_Mode, UVM_ALL_ON)
            `uvm_field_int(i_Compute_Precision, UVM_ALL_ON)
            `uvm_field_int(i_Is_Widening, UVM_ALL_ON)
            `uvm_field_int(i_Add_or_Subtract, UVM_ALL_ON)
            `uvm_field_int(i_ZmIsSigned, UVM_ALL_ON)
            `uvm_field_int(i_ZnIsSigned, UVM_ALL_ON)
            `uvm_field_int(i_Num_of_Vector_Group, UVM_ALL_ON)
            `uvm_field_int(i_Vector_Group_Num, UVM_ALL_ON)
            `uvm_field_int(i_Exception_Handling, UVM_ALL_ON)
            `uvm_field_int(i_Active_Element_A, UVM_ALL_ON)
            `uvm_field_int(i_Active_Element_B, UVM_ALL_ON)
            `uvm_field_int(i_ZA_Base_Address, UVM_ALL_ON)
            `uvm_field_int(i_Operand_A, UVM_ALL_ON)
            `uvm_field_int(i_Operand_B, UVM_ALL_ON)
            `uvm_field_int(i_Operand_C, UVM_ALL_ON)

            `uvm_field_int(o_Result, UVM_ALL_ON)
            `uvm_field_int(expected, UVM_ALL_ON)
        `uvm_object_utils_end

        // 构造函数
        function new(string name = "PE_seq_item");
            super.new(name);
            `uvm_info(get_type_name(), "created", UVM_FULL)
        endfunction


    endclass
`endif

`endif // PE_SEQ_ITEM_SV