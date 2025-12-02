#!/bin/bash

# 清空覆盖率数据库
rm -rf cov_db

# 运行多种配置的测试
CONFIGURATIONS=(
    "SEED=1 VERB=UVM_LOW num_random_tests=1000"
    "SEED=42 VERB=UVM_LOW num_random_tests=5000"
    "SEED=999 VERB=UVM_LOW num_random_tests=10000"
)

for config in "${CONFIGURATIONS[@]}"; do
    echo "Running test with $config"
    make clean
    eval "make comp $config"
    eval "make sim $config"
done

# 合并覆盖率
urg -dir cov_db -report coverage_report -format both
echo "Coverage report generated at coverage_report/"