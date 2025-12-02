set compile_enable_constant_propagation_with_no_boundary_opt false
set timing_enable_multiple_clocks_per_reg true
set enable_recovery_removal_arcs true

set sdc_version 2.1

# set_unit -time ns -resistance kohm -capacitance pf -voltage V -current uA
# 单位设置（建议全部小写）
set_units -time ns -capacitance pf -resistance kohm -voltage v -current ma


# Set clock constraints

create_clock -name clk -period 0.83 -waveform [list 0 0.41]    [get_ports clk]
#create_clock -name Pad_SCLK -period 50   [get_ports Pad_SCLK]
#create_clock -name osc_clk  -period 10   [get_pins  u_Oscillator/clk]




set_input_delay  0.2 -max  -clock [get_clocks clk] [all_inputs] 
set_input_delay  0.1 -min  -clock [get_clocks clk] [all_inputs] 
set_output_delay  0.2 -max  -clock [get_clocks clk]  [all_outputs] 
set_output_delay  0.1 -min  -clock [get_clocks clk]  [all_outputs] 


# sign off   20%
#set_clock_uncertainty -setup 0.2  [get_clocks clk]
#set_clock_uncertainty -hold  0.2  [get_clocks clk]

#set_clock_uncertainty -hold 2  [get_clocks osc_clk]

#set_clock_uncertainty -setup 10 [get_clocks Pad_SCLK]
#set_clock_uncertainty -hold  10 [get_clocks Pad_SCLK]


#set_clock_latency       -source 0.5 [get_clocks clk_dpie]   input  max 50%   min 20%

#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_read_en]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[0]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[1]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[2]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[3]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[4]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[5]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[6]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_image[7]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[0]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[1]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[2]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[3]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[4]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[5]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[6]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_weights[7]]
#set_input_delay		-max 0.41	  	-clock clk		[get_ports Pad_valid_4_a_CIRCLE]
#set_output_delay	-max 0.41	  	-clock clk		[get_ports Pad_valid_lut_out]
#set_output_delay	-max 0.41	    -clock clk		[get_ports Pad_dout_valid]
#
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_read_en ]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[0]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[1]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[2]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[3]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[4]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[5]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[6]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_image[7]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[0]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[1]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[2]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[3]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[4]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[5]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[6]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_weights[7]]
#set_input_delay		-min 0.08	  	-clock clk		[get_ports Pad_valid_4_a_CIRCLE]
#set_output_delay	-min 0.08	  	-clock clk		[get_ports Pad_valid_lut_out]
#set_output_delay	-min 0.08	    -clock clk		[get_ports Pad_dout_valid]




#set_input_delay		-max 5   	  	-clock Pad_clk		[get_ports Pad_rst]
#set_input_delay		-max 6.5	  	-clock Pad_clk		[get_ports Pad_sel]
#set_output_delay	-max 6.5	    -clock Pad_clk		[get_ports Pad_int_clk]


#set_input_delay		-min 1.5	  	-clock Pad_clk		[get_ports Pad_rst]
#set_input_delay		-min 1.5	  	-clock Pad_clk		[get_ports Pad_sel]
#set_output_delay	-min 1.5	    -clock Pad_clk		[get_ports Pad_int_clk]


#set_clock_groups  -logically_exclusive   -group {Pad_SCLK } 
#set_clock_groups -logically_exclusive -group {Pad_clk }  -group {osc_clk } 
# Set design rule constraints
# set_max_fanout 32 [current_design]
# set_max_transition	0.5		[all_inputs]
set_max_fanout 8 [current_design]
set_max_transition	0.18		[all_inputs]
