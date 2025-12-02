set RTL_FILE        source_file
set working_design  PE
set file_version    1010v1
set do_scan	   0 

set RPT_DIR         RPT
set OUT_DIR         OUT

set RPT_OUT  [format "%s%s" $RPT_DIR/ $file_version]
set DATA_OUT [format "%s%s" $OUT_DIR/ $file_version]

#set lib_slow     scc018v3ebcd_hs50_rvt_ff_v1p98_0c_basic
#set lib_slow     scc018v3ebcd_hs50_rvt_ff_v1p98_0c_basic
set  lib_slow     tcbn28hpcplusbwp7t35p140ssg0p81v125c_ccs
#set lib_fast     fast
#set lib_symbol   scc018ug_uhd_rvt
#set lib_link    SP018R_V1p1_min