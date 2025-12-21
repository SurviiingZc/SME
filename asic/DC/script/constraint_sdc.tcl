set compile_enable_constant_propagation_with_no_boundary_opt false
set timing_enable_multiple_clocks_per_reg true
set enable_recovery_removal_arcs true

set sdc_version 2.1

create_clock -name clk -period 0.83 -waveform {0 0.41} [get_ports clk]

set CLK_PORT  [get_ports clk]
set IN_PORTS  [remove_from_collection [all_inputs] $CLK_PORT]

set_clock_uncertainty -setup 0.05 [get_clocks clk]
set_clock_uncertainty -hold  0.02 [get_clocks clk]
set_clock_transition 0.05 [get_clocks clk]

set_input_delay  0.1 -max -clock [get_clocks clk] $IN_PORTS
set_input_delay  0.0.05 -min -clock [get_clocks clk] $IN_PORTS

set_output_delay 0.1 -max -clock [get_clocks clk] [all_outputs]
set_output_delay 0.05 -min -clock [get_clocks clk] [all_outputs]


set_max_fanout 8 [current_design]
set_max_transition	0.18 $IN_PORTS
set_max_transition 0.18 [current_design]
set_load 0.02 [all_outputs]
