`ifndef PE_COV_COLLECTOR_SV
`define PE_COV_COLLECTOR_SV

class PE_cov_collector extends uvm_component;
    `uvm_component_utils(PE_cov_collector)
    
    uvm_analysis_imp #(PE_seq_item, PE_cov_collector) cov_export;
    
    // 当前和上一次的事务，用于检测时序相关的Hazard
    PE_seq_item current_tr;
    PE_seq_item prev_tr;

    // 辅助变量：用于存储解析后的浮点类型
    typedef enum {FP_UNKNOWN, FPType_Zero, FPType_Denormal, FPType_Nonzero, 
                    FPType_Infinity, FPType_QNaN, FPType_SNaN} fp_type_e;
    fp_type_e op_a_type, op_b_type, op_c_type, op_c_bf_type;

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
        cp_widen: coverpoint current_tr.i_Is_Widening {
            bins No_Widening = {0};
            bins Widening = {1};
        }
        // 加减控制
        cp_addsub: coverpoint current_tr.i_Add_or_Subtract{
            bins addition = {1};
            bins subtraction = {0};
        }

        // 符号位控制
        cp_zm_sign: coverpoint current_tr.i_ZmIsSigned{
            bins Zm_signed = {1};
            bins Zm_unsigned = {0};
        }
        cp_zn_sign: coverpoint current_tr.i_ZnIsSigned{
            bins Zn_signed = {1};
            bins Zn_unsigned = {0};
        }
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

        // 精度模式
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
            bins is_zero   = {FPType_Zero};
            bins is_denorm = {FPType_Denormal}; 
            bins is_norm   = {FPType_Nonzero};
            bins is_inf    = {FPType_Infinity};    
            bins is_qnan   = {FPType_QNaN};    
            bins is_snan   = {FPType_SNaN}; 
        }

        // 操作数 B 的类型分布
        cp_opB_type: coverpoint op_b_type {
            bins is_zero   = {FPType_Zero};
            bins is_denorm = {FPType_Denormal};
            bins is_norm   = {FPType_Nonzero};
            bins is_inf    = {FPType_Infinity};
            bins is_qnan   = {FPType_QNaN};    
            bins is_snan   = {FPType_SNaN}; 
        }

        // 操作数 C 的类型分布
        cp_opC_type: coverpoint op_c_type {
            bins is_zero   = {FPType_Zero};
            bins is_denorm = {FPType_Denormal};
            bins is_norm   = {FPType_Nonzero};
            bins is_inf    = {FPType_Infinity};
            bins is_qnan   = {FPType_QNaN};    
            bins is_snan   = {FPType_SNaN}; 
        }

        cp_opC_bf_type: coverpoint op_c_bf_type {
            bins is_zero   = {FPType_Zero};
            bins is_norm   = {FPType_Nonzero};
            bins is_inf    = {FPType_Infinity};
            bins is_qnan   = {FPType_QNaN};
        }

        // FP32 下溢覆盖点 - 使用条件表达式
        cp_fp32_underflow: coverpoint (current_tr.i_Compute_Precision == 3'b000 && 
                                      op_a_type == FPType_Nonzero && 
                                      op_b_type == FPType_Nonzero &&
                                      current_tr.i_Operand_A[30:23] <= 8'd10 &&
                                      current_tr.i_Operand_B[30:23] <= 8'd10) {
            bins underflow = {1};
            bins no_underflow = {0};
        }

        // FP32 上溢覆盖点
        cp_fp32_overflow: coverpoint (current_tr.i_Compute_Precision == 3'b000 && 
                                     op_a_type == FPType_Nonzero && 
                                     op_b_type == FPType_Nonzero &&
                                     current_tr.i_Operand_A[30:23] >= 8'd224 &&
                                     current_tr.i_Operand_B[30:23] >= 8'd224) {
            bins overflow = {1};
            bins no_overflow = {0};
        }

        // FP16 下溢覆盖点
        cp_fp16_underflow: coverpoint (current_tr.i_Compute_Precision == 3'b001 && 
                                      op_a_type == FPType_Nonzero && 
                                      op_b_type == FPType_Nonzero &&
                                      current_tr.i_Operand_A[14:10] <= 5'd5 &&
                                      current_tr.i_Operand_B[14:10] <= 5'd5) {
            bins underflow = {1};
            bins no_underflow = {0};
        }

        // FP16 上溢覆盖点
        cp_fp16_overflow: coverpoint (current_tr.i_Compute_Precision == 3'b001 && 
                                     op_a_type == FPType_Nonzero && 
                                     op_b_type == FPType_Nonzero &&
                                     current_tr.i_Operand_A[14:10] >= 5'd25 &&
                                     current_tr.i_Operand_B[14:10] >= 5'd25) {
            bins overflow = {1};
            bins no_overflow = {0};
        }

        // BF16 下溢覆盖点
        cp_bf16_underflow: coverpoint (current_tr.i_Compute_Precision == 3'b011 && 
                                      op_a_type == FPType_Nonzero && 
                                      op_b_type == FPType_Nonzero &&
                                      current_tr.i_Operand_A[14:7] <= 8'd10 &&
                                      current_tr.i_Operand_B[14:7] <= 8'd10) {
            bins underflow = {1};
            bins no_underflow = {0};
        }

        // BF16 上溢覆盖点
        cp_bf16_overflow: coverpoint (current_tr.i_Compute_Precision == 3'b011 && 
                                     op_a_type == FPType_Nonzero && 
                                     op_b_type == FPType_Nonzero &&
                                     current_tr.i_Operand_A[14:7] >= 8'd224 &&
                                     current_tr.i_Operand_B[14:7] >= 8'd224) {
            bins overflow = {1};
            bins no_overflow = {0};
        }

        // 交叉覆盖：验证特殊值的组合运算，例如 0 * Inf (Invalid) 或 Inf * Inf
        cross_fp32_special: cross cp_prec, cp_opA_type, cp_opB_type, cp_opC_type {
            // 使用ignore_bins排除非FP32的情况
            ignore_bins not_fp32 = !binsof(cp_prec) intersect {3'b000};
        }
        cross_fp16_special: cross cp_prec, cp_opA_type, cp_opB_type, cp_opC_type {
            ignore_bins not_fp16 = !binsof(cp_prec) intersect {3'b001};
        }
        
        // BF16：只有4种类型任意组合
        cross_bf16_special: cross cp_prec, cp_opA_type, cp_opB_type, cp_opC_bf_type {
            // 排除非BF16的情况
            ignore_bins not_bf16 = !binsof(cp_prec) intersect {3'b011};
            
            // 限制操作数A和B在BF16时也只有4种类型
            ignore_bins ignore_a_denorm_snan = 
                binsof(cp_opA_type.is_denorm) || binsof(cp_opA_type.is_snan);

            ignore_bins ignore_b_denorm_snan = 
                binsof(cp_opB_type.is_denorm) || binsof(cp_opB_type.is_snan);
        }
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
    // Group 5: 控制寄存器覆盖率 (Exception Control)
    // 验证 FPCR 寄存器的不同配置
    // AHP;DN;Stride;Len;IDE;IXE;UFE;OFE;DZE;IOE;NEP位默认或当前未使用
    // ========================================================================
    covergroup cg_exception_ctrl;
        option.per_instance = 1;

        // Rounding Mode
        cp_rmode: coverpoint current_tr.i_Exception_Handling[16:15] {
            bins FPRounding_TIEEVEN = {2'b00}; // Nearest
            bins FPRounding_POSINF  = {2'b01}; // Plus Inf
            bins FPRounding_NEGINF  = {2'b10}; // Minus Inf
            bins FPRounding_ZERO    = {2'b11}; // Zero
        }

        // Flush-to-Zero
        cp_fz: coverpoint current_tr.i_Exception_Handling[17]{
            bins FZ_1 = {1};
            bins FZ_0 = {0};
        }

        // Flush-to-Zero_16
        cp_fz_16: coverpoint current_tr.i_Exception_Handling[12]{
            bins FZ16_1 = {1};
            bins FZ16_0 = {0};
        }

        // EBF
        cp_ebf: coverpoint current_tr.i_Exception_Handling[8]{
            bins EBF_1 = {1};
            bins EBF_0 = {0};
        }

        // AH
        cp_ah: coverpoint current_tr.i_Exception_Handling[1]{
            bins AH_1 = {1};
            bins AH_0 = {0};
        }

        // FIZ
        cp_fiz: coverpoint current_tr.i_Exception_Handling[0]{
            bins FIZ_1 = {1};
            bins FIZ_0 = {0};
        }
    
        cross_rmode_ftz: cross cp_rmode, cp_fz;
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
        op_c_type = get_fp32_type(current_tr.i_Operand_C[31:0]);
        op_c_bf_type = get_c_bf16_type(current_tr.i_Operand_C[31:0]);
        case (current_tr.i_Compute_Precision)
            3'b000: begin // FP32
                op_a_type = get_fp32_type(current_tr.i_Operand_A);
                op_b_type = get_fp32_type(current_tr.i_Operand_B);
            end
            3'b001: begin // FP16 
                op_a_type = get_fp16_type(current_tr.i_Operand_A[15:0]);
                op_b_type = get_fp16_type(current_tr.i_Operand_B[15:0]);
            end
            3'b011: begin // BF16 
                op_a_type = get_bf16_type(current_tr.i_Operand_A[15:0]);
                op_b_type = get_bf16_type(current_tr.i_Operand_B[15:0]);
            end
            default: begin // Integer
                op_a_type = FPType_Nonzero; 
                op_b_type = FPType_Nonzero;
            end
        endcase
    endfunction

    // FP32 分类逻辑
    function fp_type_e get_fp32_type(bit [31:0] val);
        bit [7:0] exp = val[30:23];
        bit [22:0] mant = val[22:0];
        bit mant_msb = mant[22];  // 尾数最高位，用于区分 QNaN/SNaN
        // 1. 检查零值
        if (exp == 8'h00 && mant == 23'h0) begin
            return FPType_Zero;
        end
        // 2. 检查非规格化数
        else if (exp == 8'h00 && mant != 23'h0) begin
            return FPType_Denormal;
        end
        // 3. 检查无穷大
        else if (exp == 8'hFF && mant == 23'h0) begin
            return FPType_Infinity;
        end
        // 4. 检查 NaN (指数全1且尾数非0)
        else if (exp == 8'hFF && mant != 23'h0) begin
            // 根据尾数最高位区分 QNaN/SNaN
            if (mant_msb == 1'b1) begin
                return FPType_QNaN;  // QNaN: 尾数最高位=1
            end else begin
                return FPType_SNaN;  // SNaN: 尾数最高位=0
            end
        end
        // 5. 规格化非零数 (指数非全0且非全1)
        else begin
            return FPType_Nonzero;
        end
    endfunction

    // FP16 分类逻辑
    function fp_type_e get_fp16_type(bit [15:0] val);
        bit [4:0] exp = val[14:10];
        bit [9:0] mant = val[9:0];
        bit mant_msb = mant[9];  // 尾数最高位，用于区分 QNaN/SNaN

        // 1. 检查零值
        if (exp == 5'h00 && mant == 10'h0) begin
            return FPType_Zero;
        end
        // 2. 检查非规格化数
        else if (exp == 5'h00 && mant != 10'h0) begin
            return FPType_Denormal;
        end
        // 3. 检查无穷大
        else if (exp == 5'h1F && mant == 10'h0) begin
            return FPType_Infinity;
        end
        // 4. 检查 NaN (指数全1且尾数非0)
        else if (exp == 5'h1F && mant != 10'h0) begin
            // 根据尾数最高位区分 QNaN/SNaN
            if (mant_msb == 1'b1) begin
                return FPType_QNaN;  // QNaN: 尾数最高位=1
            end else begin
                return FPType_SNaN;  // SNaN: 尾数最高位=0
            end
        end
        // 5. 规格化非零数 (指数非全0且非全1)
        else begin
            return FPType_Nonzero;
        end
    endfunction

    function fp_type_e get_bf16_type(bit [15:0] val);
        bit [7:0] exp = val[14:7];   // BF16: 位[14:7]是指数
        bit [6:0] mant = val[6:0];   // BF16: 位[6:0]是尾数（高7位）
        // 1. 检查指数全0：固定视为零（Flush to Zero）
        if (exp == 8'h00) begin
            return FPType_Zero;  // 指数全0固定为Zero，不考虑尾数
        end
        // 2. 检查指数全1
        else if (exp == 8'hFF) begin
            if (mant == 7'h00) begin
                return FPType_Infinity;  // 无穷大
            end else begin
                return FPType_QNaN;      // 所有NaN都当作QNaN，没有SNaN
            end
        end
        // 3. 其他情况：规格化非零数
        else begin
            return FPType_Nonzero;
        end
    endfunction

    function fp_type_e get_c_bf16_type(bit [31:0] val);
        bit [7:0] exp = val[30:23];   
        bit [22:0] mant = val[22:0];   
        // 1. 检查指数全0：固定视为零（Flush to Zero）
        if (exp == 8'h00) begin
            return FPType_Zero;  // 指数全0固定为Zero，不考虑尾数
        end
        // 2. 检查指数全1
        else if (exp == 8'hFF) begin
            if (mant == 0) begin
                return FPType_Infinity;  // 无穷大
            end else begin
                return FPType_QNaN;      // 所有NaN都当作QNaN，没有SNaN
            end
        end
        // 3. 其他情况：规格化非零数
        else begin
            return FPType_Nonzero;
        end
    endfunction

endclass

`endif // PE_COV_COLLECTOR_SV