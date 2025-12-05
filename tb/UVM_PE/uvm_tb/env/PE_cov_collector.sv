`ifndef PE_COV_COLLECTOR_SV
`define PE_COV_COLLECTOR_SV

class PE_cov_collector extends uvm_component;
    `uvm_component_utils(PE_cov_collector)
    
    uvm_analysis_imp #(PE_seq_item, PE_cov_collector) cov_export;
    real coverage_percentage;
    
    // 覆盖组定义（汇总所有事务）
    covergroup cov_summary;
        cp_total_trans: coverpoint 1 {
            bins total_trans[1000000] = {1}; // 用于计数总事务
        }
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cov_export = new("cov_export", this);
        cov_summary = new();
    endfunction
    
    // 分析端口写入方法
    function void write(PE_seq_item tr);
        cov_summary.sample(); // 采样全局覆盖组
    endfunction
    
    // 报告阶段计算覆盖率
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        coverage_percentage = cov_summary.get_coverage();
        `uvm_info("COV", $sformatf("Functional coverage: %.2f%%", coverage_percentage), UVM_LOW)
    endfunction
    endclass

`endif // PE_COV_COLLECTOR_SV