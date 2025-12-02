`ifndef PE_AGENT_PKG_SV
`define PE_AGENT_PKG_SV

package PE_agent_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "PE_seq_item.sv"
`include "PE_sequencer.sv"
`include "PE_driver.sv"
`include "PE_monitor.sv"
`include "PE_agent.sv"

endpackage : PE_agent_pkg

`endif // PE_AGENT_PKG_SV
