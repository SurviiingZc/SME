`ifndef PE_COV_COLLECTOR_SV
`define PE_COV_COLLECTOR_SV

class PE_cov_collector extends uvm_component;
    `uvm_component_utils(PE_cov_collector)
    
    uvm_analysis_imp #(PE_seq_item, PE_cov_collector) cov_export;
    
    // 当前和上一次的事务，用于检测时序相关的Hazard
    PE_seq_item current_tr;
    PE_seq_item prev_tr;

    // 辅助变量：用于存储解析后的浮点类型
    typedef enum {FP_ZERO, FP_DENORM, FP_NORM, FP_INF, FP_NAN, FP_UNKNOWN} fp_type_e;
    fp_type_e op_a_type, op_b_type, op_c_type;

    // ========================================================================
    // Group 1: ISA 配置覆盖率 (Instruction Set Architecture)
    // 覆盖基本的指令字段及其交叉组合
    // ========================================================================
    covergroup cg_isa_config;
        option.per_instance = 1;
        option.comment = "Covers basic instruction configurations";

        // 精度模式
        cp_prec: coverpoint current_tr.i_Compute_Precision {
            bins fp32  = {3'b000};
            bins fp16  = {3'b001};
            bins int16 = {3'b010};
            bins bf16  = {3'b011};
            bins int8  = {3'b100};
            ignore_bins invalid = {3'b101, 3'b110, 3'b111};
        }

        // 计算模式 (Inner/Outer)
        cp_mode: coverpoint current_tr.i_Compute_Mode {
            bins inner = {0};
            bins outer = {1};
        }

        // Widening
        cp_widen: coverpoint current_tr.i_Is_Widening;

        // 加减控制
        cp_addsub: coverpoint current_tr.i_Add_or_Subtract;

        // 符号位控制
        cp_zm_sign: coverpoint current_tr.i_ZmIsSigned;
        cp_zn_sign: coverpoint current_tr.i_ZnIsSigned;

        // 交叉覆盖：确保每种精度下都测试了Inner/Outer和Widening的组合
        cross_prec_mode: cross cp_prec, cp_mode;
        cross_prec_widen: cross cp_prec, cp_widen;
    endgroup

    // ========================================================================
    // Group 2: 向量组配置覆盖率 (Vector Group Config)
    // 专门针对 Inner Product 模式下的复杂配置
    // ========================================================================
    covergroup cg_vector_config;
        option.per_instance = 1;
        
        // 仅在 Inner Product (mode==0) 时采样
        cp_num_vec: coverpoint current_tr.i_Num_of_Vector_Group iff (current_tr.i_Compute_Mode == 0) {
            bins two_vec = {0};  // VGx2
            bins four_vec = {1}; // VGx4
        }
        
        cp_vec_num: coverpoint current_tr.i_Vector_Group_Num iff (current_tr.i_Compute_Mode == 0) {
            bins single = {2'b00};
            bins double = {2'b01};
            bins quad   = {2'b10};
            ignore_bins invalid = {2'b11};
        }

        // 交叉覆盖：覆盖 Vector Group 的所有合法组合
        cross_vec_cfg: cross cp_num_vec, cp_vec_num;
    endgroup

    // ========================================================================
    // Group 3: 算术边界覆盖率 (Arithmetic Corners)
    // 验证是否生成了特殊值 (NaN, Inf, Subnormal)
    // ========================================================================
    covergroup cg_arithmetic_corners;
        option.per_instance = 1;

        // 【修复点】：在这里重新定义 cp_prec，以便进行本地交叉覆盖
        cp_prec: coverpoint current_tr.i_Compute_Precision {
            bins fp32  = {3'b000};
            bins fp16  = {3'b001};
            bins int16 = {3'b010};
            bins bf16  = {3'b011};
            bins int8  = {3'b100};
            ignore_bins invalid = {3'b101, 3'b110, 3'b111};
        }

        // 操作数 A 的类型分布
        cp_opA_type: coverpoint op_a_type {
            bins is_zero   = {FP_ZERO};
            bins is_denorm = {FP_DENORM}; // 验证 Denormal 处理
            bins is_norm   = {FP_NORM};
            bins is_inf    = {FP_INF};    // 验证 Overflow/Inf 处理
            bins is_nan    = {FP_NAN};    // 验证 NaN 传播
        }

        // 操作数 B 的类型分布
        cp_opB_type: coverpoint op_b_type {
            bins is_zero   = {FP_ZERO};
            bins is_denorm = {FP_DENORM};
            bins is_norm   = {FP_NORM};
            bins is_inf    = {FP_INF};
            bins is_nan    = {FP_NAN};
        }

        // 交叉覆盖：验证特殊值的组合运算，例如 0 * Inf (Invalid) 或 Inf * Inf
        cross_opA_opB: cross cp_opA_type, cp_opB_type;
        
        // 【修复点】：现在交叉使用的是本地定义的 cp_prec
        cross_prec_opA: cross cp_prec, cp_opA_type;
    endgroup

    // ========================================================================
    // Group 4: 流水线冲突覆盖率 (Pipeline Hazards)
    // 验证连续指令访问同一 ZA Tile 的情况
    // ========================================================================
    covergroup cg_pipeline_hazards;
        option.per_instance = 1;

        // 覆盖是否发生了地址冲突 (RAW Hazard)
        // 只有当有前一条指令时才有效
        cp_hazard: coverpoint (prev_tr != null && current_tr.i_ZA_Base_Address == prev_tr.i_ZA_Base_Address) {
            bins hazard_hit = {1}; // 命中冲突，预期硬件会插入Bubble
            bins no_hazard  = {0}; // 无冲突，背靠背执行
        }

        // 覆盖地址是否在变化，验证 Tile 轮转测试
        cp_addr_change: coverpoint (prev_tr != null && current_tr.i_ZA_Base_Address != prev_tr.i_ZA_Base_Address) {
            bins addr_changed = {1};
        }
    endgroup

    // ========================================================================
    // Group 5: 异常控制覆盖率 (Exception Control)
    // 验证 FPCR 寄存器的不同配置
    // ========================================================================
    covergroup cg_exception_ctrl;
        option.per_instance = 1;

        // Rounding Mode
        cp_rmode: coverpoint current_tr.i_Exception_Handling[16:15] {
            bins rn = {2'b00}; // Nearest
            bins rp = {2'b01}; // Plus Inf
            bins rm = {2'b10}; // Minus Inf
            bins rz = {2'b11}; // Zero
        }

        // Flush-to-Zero
        cp_ftz: coverpoint current_tr.i_Exception_Handling[17];
        
        // Default NaN Mode
        cp_dn: coverpoint current_tr.i_Exception_Handling[18];

        cross_rmode_ftz: cross cp_rmode, cp_ftz;
    endgroup

    // ========================================================================
    // 组件实现
    // ========================================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cov_export = new("cov_export", this);
        
        // 实例化所有 Covergroups
        cg_isa_config = new();
        cg_vector_config = new();
        cg_arithmetic_corners = new();
        cg_pipeline_hazards = new();
        cg_exception_ctrl = new();
    endfunction
    
    // 分析端口写入方法：Monitor 每采集到一个 Transaction 都会调用此方法
    function void write(PE_seq_item tr);
        current_tr = tr;

        // 1. 预处理：解析操作数类型 (针对当前精度)
        analyze_operands();

        // 2. 采样所有覆盖组
        cg_isa_config.sample();
        cg_vector_config.sample();
        cg_arithmetic_corners.sample();
        cg_exception_ctrl.sample();
        
        // 仅当不是第一个包时，才能检测 Hazard
        if (prev_tr != null) begin
            cg_pipeline_hazards.sample();
        end

        // 3. 更新历史记录
        // 注意：需要深拷贝，因为 Monitor可能会复用对象，或者对象随后被修改
        if (prev_tr == null) 
            prev_tr = PE_seq_item::type_id::create("prev_tr");
        prev_tr.copy(current_tr);
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV", $sformatf("Coverage collection completed."), UVM_LOW)
    endfunction

    // ========================================================================
    // 辅助函数：浮点数分类逻辑
    // ========================================================================
    function void analyze_operands();
        // 初始化
        op_a_type = FP_UNKNOWN;
        op_b_type = FP_UNKNOWN;

        case (current_tr.i_Compute_Precision)
            3'b000: begin // FP32
                op_a_type = get_fp32_type(current_tr.i_Operand_A);
                op_b_type = get_fp32_type(current_tr.i_Operand_B);
            end
            3'b001, 3'b011: begin // FP16 or BF16
                op_a_type = get_fp16_type(current_tr.i_Operand_A[15:0]);
                op_b_type = get_fp16_type(current_tr.i_Operand_B[15:0]);
            end
            default: begin // Integer
                op_a_type = FP_NORM; 
                op_b_type = FP_NORM;
            end
        endcase
    endfunction

    // FP32 分类逻辑
    function fp_type_e get_fp32_type(bit [31:0] val);
        bit [7:0] exp = val[30:23];
        bit [22:0] mant = val[22:0];
        
        if (exp == 0 && mant == 0) return FP_ZERO;
        if (exp == 0 && mant != 0) return FP_DENORM;
        if (exp == 8'hFF && mant == 0) return FP_INF;
        if (exp == 8'hFF && mant != 0) return FP_NAN;
        return FP_NORM;
    endfunction

    // FP16 分类逻辑
    function fp_type_e get_fp16_type(bit [15:0] val);
        bit [4:0] exp = val[14:10];
        bit [9:0] mant = val[9:0];
        
        if (exp == 0 && mant == 0) return FP_ZERO;
        if (exp == 0 && mant != 0) return FP_DENORM;
        if (exp == 5'h1F && mant == 0) return FP_INF;
        if (exp == 5'h1F && mant != 0) return FP_NAN;
        return FP_NORM;
    endfunction

endclass

`endif // PE_COV_COLLECTOR_SV