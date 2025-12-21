`ifndef PE_ENV_REFM_SV
`define PE_ENV_REFM_SV

// import "DPI-C" context function int unsigned FPMulAdd_ZA(
//                            input int unsigned addend,
//                            input int unsigned op1,
//                            input int unsigned op2,
//                            input byte N,
//                            input int unsigned fpcr_in
//                            );
import "DPI-C" context function void PE_C_top(
    input int   unsigned    i_Compute_Mode          ,       
    input int   unsigned    i_Compute_Precision     ,  
    input int   unsigned    i_Is_Widening           ,
    input int   unsigned    i_Add_or_Subtract       ,
    input int   unsigned    i_ZmIsSigned            ,
    input int   unsigned    i_ZnIsSigned            ,
    input int   unsigned    i_Num_of_Vector_Group   ,
    input int   unsigned    i_Vector_Group_Num      ,
    input int   unsigned    i_Exception_Handling    ,//要拆分成寄存器
    input int   unsigned    i_Active_Element_A      ,//4bit的有效指示
    input int   unsigned    i_Active_Element_B      ,
    input int   unsigned    i_ZA_Base_Address       ,
    input int   unsigned    i_Operand_A             ,
    input int   unsigned    i_Operand_B             ,
    input int   unsigned    i_Operand_C[4]          ,
    output int  unsigned    o_Result[4]               
);

class PE_env_refm extends uvm_component;
    `uvm_component_utils(PE_env_refm)
    
    uvm_analysis_imp #(PE_seq_item, PE_env_refm) item_collected_export;
    uvm_analysis_port #(PE_seq_item) item_ref_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
        item_ref_port = new("item_ref_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    function void write(PE_seq_item tr);
        PE_seq_item ref_tr;
        int unsigned opc[4], ores[4];
        logic [127:0] result;
        
        `uvm_info("REFM", $sformatf("Starting reference model calculation at time %0t", $time), UVM_HIGH)
        
        ref_tr = PE_seq_item::type_id::create("ref_tr");
        ref_tr.copy(tr);
        
        `uvm_info("REFM", $sformatf("Calling C_ref_top with: C=0x%08h, A=0x%08h, B=0x%08h, fpcr=0x%05h",
           tr.i_Operand_C[31:0], tr.i_Operand_A, tr.i_Operand_B, {12'b0,tr.i_Exception_Handling}), UVM_HIGH)
        
        opc[0] = ref_tr.i_Operand_C[31:0];
        opc[1] = ref_tr.i_Operand_C[63:32];
        opc[2] = ref_tr.i_Operand_C[95:64];
        opc[3] = ref_tr.i_Operand_C[127:96];

        PE_C_top(
            ref_tr.i_Compute_Mode          ,       
            ref_tr.i_Compute_Precision     ,  
            ref_tr.i_Is_Widening           ,
            ref_tr.i_Add_or_Subtract       ,
            ref_tr.i_ZmIsSigned            ,
            ref_tr.i_ZnIsSigned            ,
            ref_tr.i_Num_of_Vector_Group   ,
            ref_tr.i_Vector_Group_Num      ,
            ref_tr.i_Exception_Handling    ,//要拆分成寄存器
            ref_tr.i_Active_Element_A      ,//4bit的有效指示
            ref_tr.i_Active_Element_B      ,
            ref_tr.i_ZA_Base_Address       ,
            ref_tr.i_Operand_A             ,
            ref_tr.i_Operand_B             ,
            opc                            ,
            ores               
        );        
        result = {ores[3],ores[2],ores[1],ores[0]};
        `uvm_info("REFM", $sformatf("DPI function returned: 0x%08h", result), UVM_HIGH)
        ref_tr.expected = result;
        item_ref_port.write(ref_tr);
        
        //`uvm_info("REFM", "Reference model calculation completed", UVM_HIGH)
    endfunction
endclass
`endif // PE_ENV_REFM_SV