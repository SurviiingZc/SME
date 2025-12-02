set SCRIPT_FILE     script
source ./$SCRIPT_FILE/set_env.tcl

source -echo ./$SCRIPT_FILE/file_create.tcl

set cache_write  WORK/$file_version
set cache_read   WORK/$file_version

set_host_options -max_cores 16




set search_path [list \
                /simulation/wangjialong/2508TO_SRC/Library/Symbol/\
                /simulation/wangjialong/2508TO_SRC/Library/StdCell/1.8v/\
                /simulation/wangjialong/2508TO_SRC/Library/PAD/\
                /simulation/wangjialong/2508TO_SRC/Library/Analog/db/
                ]
set target_library   [list ${lib_slow}.db ]
set link_library     [list "*" ${lib_slow}.db SP018R_V1p1_typ.db FeRAM_16Kb.db]
set synthetic_library [list ${lib_slow}.db]
set symbol_library [list ${lib_symbol}.sdb]


define_design_lib WORK -path ./WORK/$file_version


set script_dir [file dirname [info script]]
set lst_file_path [file join $script_dir filelist.lst]
set source_file [sh cat $lst_file_path]

analyze -format sverilog -lib work ${source_file}
elaborate $working_design
report_attributes -design
current_design $working_design
link

source -echo ./$SCRIPT_FILE/set_parameter.tcl
source -echo ./$SCRIPT_FILE/constraint_sdc.tcl
source -echo ./$SCRIPT_FILE/dont_touch.tcl   ;

current_design $working_design

set_app_var compile_enable_constant_propagation_with_no_boundary_opt false
set_app_var timing_enable_multiple_clocks_per_reg true
set_app_var enable_recovery_removal_arcs true

set_max_transition 0.60 [current_design]

set_fix_multiple_port_nets -all -buffer_constants

set_ungroup [get_designs -hierarchical *] false


compile       > $RPT_OUT/compile.rpt
compile -inc  > $RPT_OUT/compile_inc.rpt
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
# in → reg
report_timing -path full -net -cap -input -tran -delay max \
  -from [all_inputs] -to [all_registers -data_pins] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2reg.max.rpt
report_timing -path full -net -cap -input -tran -delay min \
  -from [all_inputs] -to [all_registers -data_pins] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2reg.min.rpt

# reg → reg
# 以触发器的时钟脚作为起点集合、数据脚作为终点集合（更标准的寄存器到寄存器数据路径）
report_timing -path full -net -cap -input -tran -delay max \
  -from [all_registers -clock_pins] -to [all_registers -data_pins] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2reg.max.rpt
report_timing -path full -net -cap -input -tran -delay min \
  -from [all_registers -clock_pins] -to [all_registers -data_pins] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2reg.min.rpt

# reg → out
report_timing -path full -net -cap -input -tran -delay max \
  -from [all_registers -clock_pins] -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2out.max.rpt
report_timing -path full -net -cap -input -tran -delay min \
  -from [all_registers -clock_pins] -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.reg2out.min.rpt

# in → out
report_timing -path full -net -cap -input -tran -delay max \
  -from [all_inputs] -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2out.max.rpt
report_timing -path full -net -cap -input -tran -delay min \
  -from [all_inputs] -to [all_outputs] \
  -max_paths 200 -nworst 200 > $RPT_OUT/timing.in2out.min.rpt


report_power > $RPT_OUT/power.rpt

# Fanout 报告
report_net_fanout -threshold 50 > $RPT_OUT/fanout_over50.rpt
report_net_fanout -threshold 1  > $RPT_OUT/fanout_all.rpt


###################################################################
## Saving Hierarchy
###################################################################
set bus_naming_style {%s[%d]} 
write_file -f verilog -hierarchy -output $DATA_OUT/$working_design.v
write_sdf -version 2.1 $DATA_OUT/$working_design.sdf
write_file -f ddc -hierarchy -output $DATA_OUT/$working_design.ddc
write_sdc $DATA_OUT/$working_design.sdc
set_svf $DATA_OUT/$working_design.svf

file delete ./command.log
file delete ./filenames.log
