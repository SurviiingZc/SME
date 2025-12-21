# ----------------------------------------
# Design Compiler 调试辅助脚本（基于主脚本环境）
# 用于快速发现 unresolved reference、link 错误、未映射 net
# ----------------------------------------

set SCRIPT_FILE     script
source ./$SCRIPT_FILE/set_env.tcl     ;# 设置环境变量如 $file_version、$working_design
source -echo ./$SCRIPT_FILE/file_create.tcl

define_design_lib WORK -path ./WORK/$file_version

# === 读入 filelist.lst 并 analyze ===
set script_dir [file dirname [info script]]
set lst_file_path [file join $script_dir filelist.lst]
set source_file [sh cat $lst_file_path]

analyze -format sverilog -lib WORK ${source_file}

# === elaborate 顶层并设定当前设计 ===
elaborate $working_design
current_design $working_design

# === 尝试 link 并生成检查报告 ===
link
uniquify -force

# === 结构检查 ===
check_design > $RPT_OUT/debug_check_design.rpt
report_design_warnings > $RPT_OUT/debug_warnings.rpt
report_reference > $RPT_OUT/debug_reference.rpt
report_hierarchy > $RPT_OUT/debug_hierarchy.rpt
report_qor > $RPT_OUT/debug_qor.rpt

# === 输出提示信息 ===
echo "✅ 调试完成，请查看以下文件："
echo "    - $RPT_OUT/debug_check_design.rpt     （结构完整性/未连接检查）"
echo "    - $RPT_OUT/debug_warnings.rpt         （语法或黑盒等警告）"
echo "    - $RPT_OUT/debug_reference.rpt        （模块调用情况）"
echo "    - $RPT_OUT/debug_hierarchy.rpt        （设计层级结构）"
echo "    - $RPT_OUT/debug_qor.rpt              （质量报告）"
