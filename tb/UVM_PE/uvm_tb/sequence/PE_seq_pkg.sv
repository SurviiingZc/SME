`ifndef PE_SEQ_PKG_SV	
`define PE_SEQ_PKG_SV	

package PE_seq_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import PE_agent_pkg::*;

`include "PE_base_sequence.sv"
`include "PE_sequence_fmlal.sv"
`include "PE_sequence_fmops_w.sv"
`include "PE_sequence_smops.sv"   
`include "PE_sequence_umlal.sv"          
`include "PE_sequence_fmla.sv"     
`include "PE_sequence_sdot.sv"     
`include "PE_sequence_sumopa.sv"
`include "PE_sequence_umopa.sv"
`include "PE_sequence_bfmopa.sv"  
`include "PE_sequence_fmopa.sv"
`include "PE_sequence_fmopa_32.sv"     
`include "PE_sequence_smlall.sv"   
`include "PE_sequence_sumops.sv"  
`include "PE_sequence_umops.sv"
`include "PE_sequence_bfmops.sv"  
`include "PE_sequence_fmopa_w.sv"  
`include "PE_sequence_smlal.sv"    
`include "PE_sequence_udot.sv"    
`include "PE_sequence_usmopa.sv"
`include "PE_sequence_fdot.sv"    
`include "PE_sequence_fmops.sv"    
`include "PE_sequence_smopa.sv"    
`include "PE_sequence_umlall.sv"  
`include "PE_sequence_usmops.sv"

endpackage : PE_seq_pkg

`endif // PE_SEQ_PKG_SV	
