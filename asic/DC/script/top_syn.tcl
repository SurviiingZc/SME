set SCRIPT_FILE     script
source ./$SCRIPT_FILE/set_env.tcl

source -echo ./$SCRIPT_FILE/file_create.tcl

set cache_write  WORK/$file_version
set cache_read   WORK/$file_version

set_host_options -max_cores 16



set search_path [list \
                /simulation/PDK/T28_logic_hpc_plus/STD/tcbn28hpcplusbwp7t35p140_190a/ccs/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn28hpcplusbwp7t35p140_180a/\
                /simulation/PDK/T28_logic_hpc_plus/IO/tphn28hpcpgv18_170d/nldm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tphn28hpcpgv18_170a/]
set target_library   [list ${lib_slow}.db ]
set link_library     [list "*" ${lib_slow}.db]
set synthetic_library [list ${lib_slow}.db]


define_design_lib WORK -path ./WORK/$file_version







set script_dir [file dirname [info script]]
set lst_file_path [file join $script_dir filelist.lst]
set source_file [sh cat $lst_file_path]

suppress_message VER-318
suppress_message ELAB-311
suppress_message UCN-1

analyze -format sverilog -lib work ${source_file}


elaborate $working_design
report_attributes -design
current_design $working_design
link

source -echo ./$SCRIPT_FILE/set_parameter.tcl
source -echo ./$SCRIPT_FILE/constraint_sdc.tcl  ;
source -echo ./$SCRIPT_FILE/dont_touch.tcl

#change naming rule

report_clock > $RPT_OUT/clock.syn.rpt
report_clock -skew >> $RPT_OUT/clock.syn.rpt

current_design $working_design

uniquify -force

set_optimize_registers true
set_boundary_optimization [current_design] true

change_names -rules verilog -hierarchy

set_fix_multiple_port_nets -all -buffer_constants
set_svf $DATA_OUT/$working_design.svf


compile_ultra -timing_high_effort_script > $RPT_OUT/compile.rpt
compile_ultra -inc -timing_high_effort_script > $RPT_OUT/compile_inc.rpt

change_names -rules verilog -hierarchy
current_design $working_design


check_design  > $RPT_OUT/check_design.rpt
check_timing  > $RPT_OUT/check_timing.rpt

report_qor > $RPT_OUT/qor.rpt

report_area > $RPT_OUT/area.rpt
report_area -hierarchy > $RPT_OUT/area_hier.rpt
report_timing   -loops > $RPT_OUT/timing_loop.rpt
report_timing -path full -net -cap -input -tran -delay min -max_paths 200 -nworst 200 > $RPT_OUT/timing.min.rpt
report_timing -path full -net -cap -input -tran -delay max -max_paths 200 -nworst 200 > $RPT_OUT/timing.max.rpt

# ========= Path buckets: in→reg / reg→reg / reg→out / in→out =========
set REG_Q [get_pins -of_objects [all_registers] -filter "direction==out"]
set REG_D [all_registers -data_pins]

if {[sizeof_collection $REG_Q] == 0} {
  echo "WARNING: REG_Q is empty. Check all_registers / get_pins filter."
}
if {[sizeof_collection $REG_D] == 0} {
  echo "WARNING: REG_D is empty. Check all_registers -data_pins."
}
# in → reg
report_timing -path full -net -cap -input -tran -delay max \
  -from [all_inputs] -to [all_registers -data_pins] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2reg.max.rpt
report_timing -path full -net -cap -input -tran -delay min \
  -from [all_inputs] -to [all_registers -data_pins] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2reg.min.rpt

# reg → reg (setup)
report_timing -path full -net -cap -input -tran -delay max \
  -from $REG_Q -to $REG_D \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2reg.max.rpt

# reg → reg (hold)
report_timing -path full -net -cap -input -tran -delay min \
  -from $REG_Q -to $REG_D \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2reg.min.rpt

# reg → out (setup)
report_timing -path full -net -cap -input -tran -delay max \
  -from $REG_Q -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2out.max.rpt

# reg → out (hold)
report_timing -path full -net -cap -input -tran -delay min \
  -from $REG_Q -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2out.min.rpt


# in → out
report_timing -path full -net -cap -input -tran -delay max \
  -from [all_inputs] -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2out.max.rpt
report_timing -path full -net -cap -input -tran -delay min \
  -from [all_inputs] -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2out.min.rpt
report_power > $RPT_OUT/power.rpt

set bus_naming_style {%s[%d]} 
write_file -f verilog -hierarchy -output $DATA_OUT/$working_design.v
write_sdf -version 2.1 $DATA_OUT/$working_design.sdf
write_file -f ddc -hierarchy -output $DATA_OUT/$working_design.ddc
write_sdc $DATA_OUT/$working_design.sdc

file delete ./command.log
file delete ./filenames.log

exit