# =========================================#
#               默认配置参数                #
# =========================================#
export FSDB_NAME ?= PE_test
SEED ?= 2
PIPELINE_DEFINE ?= +define+Is_PipLine
#=========================================#
#              Log Setting                #
#=========================================#
VERB ?= UVM_LOW #只打印错误信息
# VERB=UVM_MEDIUM #打印输入输出和结果信息
# VERB=UVM_HIGH

#=========================================#
#              Test case                  #
#=========================================#
TESTNAME ?= PE_test_all
# TESTNAME ?= PE_test_int
# TESTNAME ?= PE_test_fmop 
# TESTNAME ?= PE_test_fdot
# TESTNAME ?= PE_test_bfmop

#=========================================#
#            Pipeline 配置                 #
#=========================================#
# 默认为Pipeline模式，如果需要非Pipeline模式，在make时指定Is_Not_PipLine=1
ifneq ($(Is_Not_PipLine),)
  PIPELINE_DEFINE = 
else
  PIPELINE_DEFINE = +define+Is_PipLine
endif

#=========================================#
#               Design file               #
#=========================================#
MACRO_DEFS = ../rtl/macro_definition.svh
RTL_DIR = ../rtl

CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name simv
# 使用时间戳或唯一ID作为覆盖率目录，避免覆盖
COV_DIR = cov_$(TESTNAME)_$(shell date +%Y%m%d_%H%M%S)
CM_DIR = -cm_dir ./$(COV_DIR)
CM_MERGE_DIR = -cm_dir ./merged_cov

all: multi-seed

# 添加 MPFR 库路径配置
MPFR_INCLUDE = /usr/local/include
MPFR_LIB = /usr/local/lib

# C_include
C_INC_DIR = ../C_model/include

# 编译C模型成共享库
C_SRCS = $(wildcard ../C_model/src/*.c)
C_OBJS = $(C_SRCS:../C_model/src/%.c=build_dir/%.o)

# 显示配置信息
show-config:
	@echo "当前配置:"
	@echo "  TESTNAME    = $(TESTNAME)"
	@echo "  SEED        = $(SEED)"
	@echo "  VERB        = $(VERB)"
	@echo "  FSDB_NAME   = $(FSDB_NAME)"
	@echo "  Is_PipLine  = $(Is_PipLine)"
	@echo "  Pipeline定义 = $(PIPELINE_DEFINE)"
	@echo "  覆盖率目录   = $(COV_DIR)"

c_model: $(C_OBJS)

# 创建 build_dir 目录（如果不存在）
build_dir:
	mkdir -p build_dir

build_dir/%.o: ../C_model/src/%.c | build_dir
	gcc -std=c99 -I$(C_INC_DIR) -I$(MPFR_INCLUDE) -fPIC -c $< -o $@

comp: c_model
	vcs -sverilog -full64 +v2k -debug_all -timescale=1ns/1ps $(PIPELINE_DEFINE) \
	-ntb_opts uvm-1.1 -f filelist.f -l comp.log \
	+incdir+$(RTL_DIR) $(MACRO_DEFS) \
	-cflags "-std=c99 -I$(C_INC_DIR) -I$(MPFR_INCLUDE)"  \
	$(C_OBJS) -L$(MPFR_LIB) -lmpfr -lgmp -lm \
	$(CM) $(CM_NAME) $(CM_DIR)

sim:
	rm -f *.fsdb *.fsdb.slock
	@echo "覆盖率数据将保存到: $(COV_DIR)"
	LD_LIBRARY_PATH=$(MPFR_LIB):$$LD_LIBRARY_PATH ./simv \
	    +ntb_random_seed=$(SEED) \
	    +UVM_VERBOSITY=$(VERB) \
		+UVM_TESTNAME=$(TESTNAME) \
	    -ucli -i dump_fsdb_vcs.tcl \
	    +fsdb+autoflush \
		$(CM) $(CM_NAME) $(CM_DIR) \
	    2>&1 | tee sim.log

# 批量测试多个种子，并将覆盖率合并
multi-seed:
	@echo "开始批量测试多个种子，覆盖率数据将合并..."
	@rm -rf merged_cov.vdb  # 清理旧的合并目录
	@for seed in 1 2 3 4 5; do \
		echo "========================================"; \
		echo "运行测试: TESTNAME=$(TESTNAME), SEED=$$seed"; \
		echo "========================================"; \
		make comp TESTNAME=$(TESTNAME) SEED=$$seed VERB=UVM_LOW CM_NAME="-cm_name simv_seed$$seed" CM_DIR="-cm_dir ./cov_seed$$seed"; \
		make sim TESTNAME=$(TESTNAME) SEED=$$seed VERB=UVM_LOW CM_NAME="-cm_name simv_seed$$seed" CM_DIR="-cm_dir ./cov_seed$$seed" || exit 1; \
		echo "种子 $$seed 完成"; \
	done
	@echo "正在合并覆盖率数据..."
	@urg -dir cov_seed1 cov_seed2 cov_seed3 cov_seed4 cov_seed5 -dbname merged_cov/merged -report merged_cov_report
	@echo "覆盖率合并完成！查看报告: merged_cov_report"
	@echo "使用 'make view-merged-cov' 查看合并的覆盖率报告"

# 快捷命令：批量运行并合并覆盖率
test-all-seeds:
	$(MAKE) multi-seed TESTNAME=$(TESTNAME)

# 查看合并的覆盖率报告
view-merged-cov:
	verdi -cov -covdir merged_cov.vdb &

# 使用urg生成HTML覆盖率报告
gen-html-report:
	@echo "生成HTML覆盖率报告..."
	@urg -dir cov_seed* -report html_report -format both
	@echo "HTML报告生成完成！打开 html_report/dashboard.html 查看"

# 常用快捷命令
test-int:
	$(MAKE) comp sim TESTNAME=PE_test_int SEED=$(or $(SEED),2)

test-fmop:
	$(MAKE) comp sim TESTNAME=PE_test_fmop SEED=$(or $(SEED),2)

test-fdot:
	$(MAKE) comp sim TESTNAME=PE_test_fdot SEED=$(or $(SEED),2)

test-bfmop:
	$(MAKE) comp sim TESTNAME=PE_test_bfmop SEED=$(or $(SEED),2)

test-all:
	$(MAKE) comp sim TESTNAME=PE_test_all SEED=$(or $(SEED),2)

# 批量测试特定测试用例的多个种子
multi-seed-int:
	$(MAKE) multi-seed TESTNAME=PE_test_int

multi-seed-fmop:
	$(MAKE) multi-seed TESTNAME=PE_test_fmop

multi-seed-fdot:
	$(MAKE) multi-seed TESTNAME=PE_test_fdot

multi-seed-bfmop:
	$(MAKE) multi-seed TESTNAME=PE_test_bfmop

# 使用不同的种子范围
multi-seed-range:
	@echo "请输入起始种子号:" && read start_seed; \
	echo "请输入结束种子号:" && read end_seed; \
	echo "从种子 $$start_seed 到 $$end_seed 运行测试..."; \
	rm -rf merged_cov; \
	mkdir -p merged_cov; \
	for seed in `seq $$start_seed $$end_seed`; do \
		echo "运行测试: SEED=$$seed"; \
		make comp TESTNAME=$(TESTNAME) SEED=$$seed VERB=UVM_LOW CM_NAME="-cm_name simv_seed$$seed" CM_DIR="-cm_dir ./cov_seed$$seed"; \
		make sim TESTNAME=$(TESTNAME) SEED=$$seed VERB=UVM_LOW CM_NAME="-cm_name simv_seed$$seed" CM_DIR="-cm_dir ./cov_seed$$seed" || exit 1; \
	done; \
	cov_dirs=`ls -d cov_seed* 2>/dev/null`; \
	if [ -n "$$cov_dirs" ]; then \
		echo "合并覆盖率数据..."; \
		urg -dir $$cov_dirs -dbname merged_cov/merged -report merged_cov_report; \
		echo "覆盖率合并完成！"; \
	else \
		echo "没有找到覆盖率目录"; \
	fi

verdi:
	verdi -ssf $(or $(FSDB_NAME),PE_test).fsdb -f filelist.f &

cov:
	verdi -cov

clean:
	rm -rf build_dir *.o *.log *.vdb *simv* *.key *.fsdb csrc*
	rm -rf csrc vdCovLog verdi* *Debug* *.png cov_seed* merged_cov* html_report

# 清理编译结果但保留日志和覆盖率
clean-comp:
	rm -rf *simv* csrc ucli.key
	rm -rf build_dir/*.o

# 仅清理覆盖率数据
clean-cov:
	rm -rf cov_seed* merged_cov* html_report *.vdb

.PHONY: all comp sim verdi cov clean show-config test-int test-fmop test-fdot test-bfmop test-all multi-seed multi-seed-int multi-seed-fmop multi-seed-fdot multi-seed-bfmop multi-seed-range view-merged-cov gen-html-report clean-comp clean-cov test-all-seeds