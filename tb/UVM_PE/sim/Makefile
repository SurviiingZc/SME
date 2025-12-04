export FSDB_NAME=mult
SEED=2
VERB=UVM_MEDIUM
# TESTNAME=PE_test_int
TESTNAME=PE_test_fmop 
Is_PipLine=+define+Is_PipLine
MACRO_DEFS = ../rtl/macro_definition.svh
RTL_DIR = ../rtl

CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name simv
CM_DIR = -cm_dir ./covdir.vdb

all: comp sim

# 添加 MPFR 库路径配置
MPFR_INCLUDE = /usr/local/include
MPFR_LIB = /usr/local/lib
#C_include
C_INC_DIR = ../C_model/include
# 编译C模型成共享库
# 明确列出所有C源文件
C_SRCS = $(wildcard ../C_model/src/*.c)

# 生成对应的目标文件列表  
C_OBJS = $(C_SRCS:../C_model/src/%.c=build_dir/%.o)

c_model: $(C_OBJS)
# 创建 build_dir 目录（如果不存在）
build_dir:
	mkdir -p build_dir

build_dir/%.o: ../C_model/src/%.c | build_dir
	gcc -std=c99 -I$(C_INC_DIR) -I$(MPFR_INCLUDE) -fPIC -c $< -o $@

comp: c_model
		vcs -sverilog -full64 +v2k -debug_all -timescale=1ns/1ps \
		-ntb_opts uvm-1.1 -f filelist.f -l comp.log \
		+incdir+$(RTL_DIR) $(MACRO_DEFS) \
		-cflags "-std=c99 -I$(C_INC_DIR) -I$(MPFR_INCLUDE)"  \
		$(C_OBJS) -L$(MPFR_LIB) -lmpfr -lgmp -lm \
		$(CM) $(CM_NAME) $(CM_DIR)

sim:
	rm -f *.fsdb *.fsdb.slock
	LD_LIBRARY_PATH=$(MPFR_LIB):$$LD_LIBRARY_PATH ./simv \
	    +ntb_random_seed=${SEED} \
	    +UVM_VERBOSITY=${VERB} \
		+UVM_TESTNAME=${TESTNAME} \
	    -ucli -i dump_fsdb_vcs.tcl \
	    +fsdb+autoflush \
		$(CM) $(CM_NAME) $(CM_DIR) \
	    2>&1 | tee sim.log 

verdi:
	verdi -ssf mult.fsdb -f filelist.f &
	
clean:
	rm -rf build_dir *.o *.log *.vdb *simv* *.key *.fsdb csrc*
	rm -rf csrc vdCovLog verdiLog
	