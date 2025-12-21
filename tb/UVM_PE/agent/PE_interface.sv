`ifndef PE_INTERFACE_SV
`define PE_INTERFACE_SV

interface PE_interface(input bit clk, bit rst_n);

    logic            i_Compute_Mode         ;
    logic  [ 2:0]    i_Compute_Precision    ;
    logic            i_Is_Widening          ;
    logic            i_Add_or_Subtract      ;
    logic            i_ZmIsSigned           ;
    logic            i_ZnIsSigned           ;
    logic            i_Num_of_Vector_Group  ;
    logic  [ 1:0]    i_Vector_Group_Num     ;
    logic  [19:0]    i_Exception_Handling   ;
    logic  [ 3:0]    i_Active_Element_A     ;
    logic  [ 3:0]    i_Active_Element_B     ;
    logic  [31:0]    i_ZA_Base_Address      ;  // 移除了 randc

    logic  [31:0]    i_Operand_A      ;  // 移除了 randc
    logic  [31:0]    i_Operand_B      ;  // 移除了 randc
    logic  [127:0]   i_Operand_C      ;  // 移除了 randc

    logic  [127:0]   o_Result         ;

  clocking drv_cb  @(posedge clk);
	 default input #1ps output #1ps;
         output  i_Compute_Mode, i_Compute_Precision, i_Is_Widening, i_Add_or_Subtract,
                i_ZmIsSigned, i_ZnIsSigned, i_Num_of_Vector_Group, i_Vector_Group_Num,
                i_Exception_Handling, i_ZA_Base_Address, i_Active_Element_A, i_Active_Element_B,
                i_Operand_A, i_Operand_B, i_Operand_C; 
         input   o_Result;
	endclocking : drv_cb 

	clocking mon_cb  @(posedge clk);
	 default input #1ps output #1ps;
         input   i_Compute_Mode, i_Compute_Precision, i_Is_Widening, i_Add_or_Subtract,
                i_ZmIsSigned, i_ZnIsSigned, i_Num_of_Vector_Group, i_Vector_Group_Num,
                i_Exception_Handling, i_ZA_Base_Address, i_Active_Element_A, i_Active_Element_B,
                i_Operand_A, i_Operand_B, i_Operand_C, o_Result; 
	endclocking : mon_cb 

endinterface : PE_interface

`endif // PE_INTERFACE_SV