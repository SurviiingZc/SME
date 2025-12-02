module PE_tb;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import PE_test_pkg::*;

    bit clk;
    bit rst_n;
    bit monitor_cmp_result;
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Reset generation
    initial begin
        rst_n = 0;
        #20 rst_n = 1;
        `uvm_info("PE_tb", "Reset released", UVM_LOW)
    end
    
    // Interface instantiation
    PE_interface intf(clk, rst_n);
    
    // DUT instantiation
    PE dut(
        .clk                    ( clk                    ),
        .rst_n                  ( rst_n                  ),
        .i_Compute_Mode         ( intf.i_Compute_Mode         ),
        .i_Compute_Precision    ( intf.i_Compute_Precision    ),
        .i_Is_Widening          ( intf.i_Is_Widening          ),
        .i_Add_or_Subtract      ( intf.i_Add_or_Subtract      ),
        .i_ZmIsSigned           ( intf.i_ZmIsSigned           ),
        .i_ZnIsSigned           ( intf.i_ZnIsSigned           ),
        .i_Num_of_Vector_Group  ( intf.i_Num_of_Vector_Group  ),
        .i_Vector_Group_Num     ( intf.i_Vector_Group_Num     ),
        .i_Exception_Handling   ( intf.i_Exception_Handling   ),
        .i_ZA_Base_Address      ( intf.i_ZA_Base_Address      ),
        .i_Active_Element_A     ( intf.i_Active_Element_A     ),
        .i_Active_Element_B     ( intf.i_Active_Element_B     ),
        .i_Operand_A            ( intf.i_Operand_A            ),
        .i_Operand_B            ( intf.i_Operand_B            ),
        .i_Operand_C            ( intf.i_Operand_C            ),
        .o_Result               ( intf.o_Result               )
    );
    
    // UVM start
    initial begin
        uvm_config_db#(virtual PE_interface)::set(null, "uvm_test_top.env.agent*", "vif", intf);
        run_test();
    end

endmodule : PE_tb
