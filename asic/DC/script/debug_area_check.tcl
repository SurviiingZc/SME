# ----------------------------------------
# Design Compiler 面积检查专用脚本
# 不使用时钟约束，仅为确认设计是否能映射出有效面积/cell
# ----------------------------------------

# === 初始化环境变量 ===
set SCRIPT_FILE script
source ./$SCRIPT_FILE/set_env.tcl
source -echo ./$SCRIPT_FILE/file_create.tcl

define_design_lib WORK -path ./WORK/$file_version

# === 加载 RTL 文件 ===
set script_dir [file dirname [info script]]
set lst_file_path [file join $script_dir filelist.lst]
set source_file [sh cat $lst_file_path]

analyze -format sverilog -lib WORK ${source_file}

# === elaborate 顶层并设为当前设计 ===
elaborate $working_design
current_design $working_design

# === link 并进行映射准备 ===
link
uniquify -force

# === 修改命名规则，避免非法字符问题 ===
change_names -rules verilog -hierarchy

# === 执行综合（无时钟）===
compile > $RPT_OUT/debug_compile.rpt

# === 再次改名处理（可选）===
change_names -rules verilog -hierarchy

# === 面积 & 单元数量报告 ===
report_area            > $RPT_OUT/debug_area.rpt
report_area -hierarchy > $RPT_OUT/debug_area_hier.rpt
report_cell            > $RPT_OUT/debug_cell.rpt
report_qor             > $RPT_OUT/debug_qor.rpt
report_design_warnings > $RPT_OUT/debug_warnings.rpt

# === 结构性检查（可选）===
check_design > $RPT_OUT/debug_check_design.rpt

# === 结束提示 ===
echo "✅ 面积检查完成。你可以查看："
echo "    $RPT_OUT/debug_area.rpt"
echo "    $RPT_OUT/debug_cell.rpt"
echo "    $RPT_OUT/debug_qor.rpt"
echo "    $RPT_OUT/debug_warnings.rpt"
