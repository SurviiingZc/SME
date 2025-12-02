`ifndef PE_ENV_PKG_SV
`define PE_ENV_PKG_SV

package PE_env_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import PE_agent_pkg::*;
`include "PE_cov_collector.sv"
`include "PE_env_refm.sv"
`include "PE_env_scb.sv"
`include "PE_env.sv" //env包含上面组件，要再最后引用


endpackage : PE_env_pkg

`endif // PE_ENV_PKG_SV
