#!/bin/csh -f

cd /simulation/wangjialong/SME_TPU_PE/Public_SME/SME/tb/simulation

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/apps/synopsys/vcs-all_vR-2020.12-SP2/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

