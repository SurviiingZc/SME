global env

fsdbDumpfile "$env(FSDB_NAME).fsdb"
# 只记录关键信号，避免记录所有变量
fsdbDumpvars 0 "PE_tb" "+mda"
# 限制波形记录深度
fsdbDumpvars +fsdbfile+autoflush
fsdbDumpon
run 

exit
