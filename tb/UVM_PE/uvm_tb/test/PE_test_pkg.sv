`ifndef PE_TEST_PKG_SV 
`define PE_TEST_PKG_SV 

package PE_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import PE_agent_pkg::*;
import PE_env_pkg::*;
import PE_seq_pkg::*;

`include "PE_test_fmop.sv"
`include "PE_test_int.sv"


endpackage : PE_test_pkg

`endif // PE_TEST_PKG_SV 
