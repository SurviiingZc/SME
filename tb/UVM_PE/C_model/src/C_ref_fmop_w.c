#include "C_ref_fmop.h"
#include "C_ref_fmop_w.h"
#include "C_ref_bfmop.h"

// FPDotAdd_ZA 函数实现
// 半精度2路点积并加到单精度，用于SME ZA目标指令
//四个op低16位有效; N只为32(不输入); add_sub = 1 加 ; add_sub = 0 减
uint32_t FPDotAdd_ZA(uint32_t addend, uint32_t op1_a, uint32_t op1_b, 
                    uint32_t op2_a, uint32_t op2_b, uint32_t fpcr_in, uint8_t add_sub) {

    FPCR_Type fpcr = assign_FPCR(fpcr_in);//运行一次，将uin32_t的fpcr转为FPCR_Type类型
    
    // 验证N的有效性（N=32）
    uint8_t N = 32;
    assert(N == 32);
    
    uint32_t prod;
    uint32_t result;
    
    // 常量设置
    bool isbfloat16 = false;  // 不使用BFloat16
    bool fpexc = false;       // 不生成浮点异常
    
    // 设置DN位为1（生成默认NaN值）
    fpcr.DN = 1;
    
    // 计算点积
    prod = FPDot(op1_a, op1_b, op2_a, op2_b, fpcr, isbfloat16, fpexc, N);
    
    // 将点积结果与加数相加
    result = FPAdd(addend, prod, fpcr, fpexc, N, add_sub);
    
    return result;
}


// FPConvertNaN 函数实现
uint32_t FPConvertNaN(uint32_t op, uint8_t N, uint8_t M) {
    // 验证输入和输出精度的有效性
    assert((N == 16 || N == 32) && (M == 16 || M == 32));
    
    uint32_t result = 0;
    uint8_t sign;
    uint64_t frac = 0; // 使用64位存储扩展的尾数
    
    // 提取符号位
    if (N == 16) {
        sign = (op >> 15) & 0x1;
    } else { // N == 32
        sign = (op >> 31) & 0x1;
    }
    
    // 从输入NaN解包有效载荷
    switch (N) {
        case 16: {
            // 16位: 提取9位尾数，扩展到51位
            uint16_t frac16 = op & 0x1FF; // 低9位
            frac = (uint64_t)frac16 << 42; // 左移42位，低位补0
            break;
        }
        case 32: {
            // 32位: 提取22位尾数，扩展到51位
            uint32_t frac32 = op & 0x3FFFFF; // 低22位
            frac = (uint64_t)frac32 << 29; // 左移29位，低位补0
            break;
        }
    }
    
    // 重新打包有效载荷到输出NaN
    switch (M) {
        case 16: {
            // 16位: 符号位 + 5位指数(全1) + 10位尾数
            // 取frac的高9位(50:42)，确保是QNaN(最高尾数位为1)
            uint16_t frac_out = (frac >> 42) & 0x1FF;
            
            // 确保是QNaN - 设置尾数最高位为1
            frac_out |= 0x200; // 第9位为1
            
            result = ((uint32_t)sign << 15) | (0x1F << 10) | frac_out;
            break;
        }
        case 32: {
            // 32位: 符号位 + 8位指数(全1) + 23位尾数
            // 取frac的高22位(50:29)，确保是QNaN(最高尾数位为1)
            uint32_t frac_out = (frac >> 29) & 0x3FFFFF;
            
            // 确保是QNaN - 设置尾数最高位为1
            frac_out |= 0x400000; // 第22位为1
            
            result = ((uint32_t)sign << 31) | (0xFF << 23) | frac_out;
            break;
        }
    }
    
    return result;
}

// FPProcessNaNs4 函数实现
bool FPProcessNaNs4(FPType type1, FPType type2, FPType type3, FPType type4,
                   uint32_t op1, uint32_t op2, uint32_t op3, uint32_t op4,
                   FPCR_Type fpcr, bool fpexc, uint8_t N,
                   uint32_t* result) {
    // 验证N的有效性（根据伪代码，这里应该是32）
    assert(N == 32);
    
    bool done = false;
    *result = 0;
    
    // FPCR.AH控制不影响这些检查
    if (type1 == FPType_SNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type1, op1, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type2 == FPType_SNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type2, op2, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type3 == FPType_SNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type3, op3, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type4 == FPType_SNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type4, op4, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type1 == FPType_QNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type1, op1, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type2 == FPType_QNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type2, op2, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type3 == FPType_QNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type3, op3, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type4 == FPType_QNaN) {
        done = true;
        uint32_t processed_nan = FPProcessNaN(type4, op4, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else {
        done = false;
        *result = Zeros(N); // 'Don't care' result
    }
    
    return done;
}

// FPDot函数实现
uint32_t FPDot(uint32_t op1_a, uint32_t op1_b, uint32_t op2_a, uint32_t op2_b,
                       FPCR_Type fpcr_in, bool isbfloat16, bool fpexc, uint8_t N) {
    // 验证N的有效性
    assert(N == 32);
    
    FPCR_Type fpcr = fpcr_in;
    fpcr.AHP = 0; // 忽略替代半精度选项
    
    uint32_t result = 0;
    bool done = false;
    
    // 获取舍入模式
    FPRounding rounding = FPRoundingMode(fpcr);
    
    // 解包四个操作数
    FPType type1_a, type1_b, type2_a, type2_b;
    uint8_t sign1_a, sign1_b, sign2_a, sign2_b;
    float value1_a, value1_b, value2_a, value2_b;
    
    FPUnpackBase(op1_a, 16, fpcr, fpexc, isbfloat16, &type1_a, &sign1_a, &value1_a);
    FPUnpackBase(op1_b, 16, fpcr, fpexc, isbfloat16, &type1_b, &sign1_b, &value1_b);
    FPUnpackBase(op2_a, 16, fpcr, fpexc, isbfloat16, &type2_a, &sign2_a, &value2_a);
    FPUnpackBase(op2_b, 16, fpcr, fpexc, isbfloat16, &type2_b, &sign2_b, &value2_b);
    
    // 检查操作数类型
    bool inf1_a = (type1_a == FPType_Infinity);
    bool zero1_a = (type1_a == FPType_Zero);
    bool inf1_b = (type1_b == FPType_Infinity);
    bool zero1_b = (type1_b == FPType_Zero);
    bool inf2_a = (type2_a == FPType_Infinity);
    bool zero2_a = (type2_a == FPType_Zero);
    bool inf2_b = (type2_b == FPType_Infinity);
    bool zero2_b = (type2_b == FPType_Zero);
    
    // 处理NaN
    done = FPProcessNaNs4(type1_a, type1_b, type2_a, type2_b,
                         op1_a, op1_b, op2_a, op2_b, fpcr, fpexc, N, &result);
    
    if (!done) {
        // 确定乘积的符号和类型
        uint8_t signPa = sign1_a ^ sign2_a; // 异或
        uint8_t signPb = sign1_b ^ sign2_b; // 异或
        bool infPa = inf1_a || inf2_a;
        bool infPb = inf1_b || inf2_b;
        bool zeroPa = zero1_a || zero2_a;
        bool zeroPb = zero1_b || zero2_b;
        
        // 检查无效操作：零乘以无穷大和相反符号的无穷大相加
        bool invalidop = ((inf1_a && zero2_a) || (zero1_a && inf2_a) ||
                         (inf1_b && zero2_b) || (zero1_b && inf2_b) ||
                         (infPa && infPb && (signPa != signPb)));
        
        if (invalidop) {
            result = FPDefaultNaN(fpcr, N);
            // if (fpexc) {
            //     FPProcessException(FPExc_InvalidOp, fpcr);
            // }
        }
        // 处理正无穷大
        else if ((infPa && signPa == 0) || (infPb && signPb == 0)) {
            result = FPInfinity(0, N);
        }
        // 处理负无穷大
        else if ((infPa && signPa == 1) || (infPb && signPb == 1)) {
            result = FPInfinity(1, N);
        }
        // 处理相同符号的零相加
        else if (zeroPa && zeroPb && signPa == signPb) {
            result = FPZero(signPa, N);
        }
        // 正常计算：计算融合乘积和并舍入
        else {
            // 使用MPFR进行精确计算
            mpfr_t mpfr1_a, mpfr1_b, mpfr2_a, mpfr2_b;
            mpfr_t mpfr_product1, mpfr_product2, mpfr_sum;
            mpfr_prec_t prec = 512;
            
            mpfr_inits2(prec, mpfr1_a, mpfr1_b, mpfr2_a, mpfr2_b, 
                       mpfr_product1, mpfr_product2, mpfr_sum, NULL);
            
            // 清除之前的异常标志
            mpfr_clear_flags();
            
            // 将float值转换为MPFR高精度表示
            mpfr_set_flt(mpfr1_a, value1_a, MPFR_RNDN);
            mpfr_set_flt(mpfr1_b, value1_b, MPFR_RNDN);
            mpfr_set_flt(mpfr2_a, value2_a, MPFR_RNDN);
            mpfr_set_flt(mpfr2_b, value2_b, MPFR_RNDN);
            
            // 精确计算两个乘积
            mpfr_mul(mpfr_product1, mpfr1_a, mpfr2_a, MPFR_RNDN);
            mpfr_mul(mpfr_product2, mpfr1_b, mpfr2_b, MPFR_RNDN);
            
            // 精确计算乘积和
            mpfr_add(mpfr_sum, mpfr_product1, mpfr_product2, MPFR_RNDN);
            
            if (mpfr_zero_p(mpfr_sum)) {
                // 精确零结果：符号取决于舍入模式
                uint8_t result_sign = (rounding == FPRounding_NEGINF) ? 1 : 0;
                result = FPZero(result_sign, N);
            } else {
                // 内联舍入逻辑 - 直接处理舍入
                bool altfp = 1 && fpcr.AH == 1; // FPDot不使用替代浮点格式
                bool satoflo = false;
                bool sign;
                int E;
                int biased_exp;
                bool overflow_to_inf;
                
                // 首先进行下溢处理
                if (overflow_handling(mpfr_sum, fpcr, N, prec, altfp, rounding, &sign, &biased_exp, &overflow_to_inf, satoflo, &E)) {
                    result = FPZero(sign, N);
                }
                // 检查是否在非规格化范围内
                else if (is_denormal_range(mpfr_sum, N)) {
                    result = handle_denormal_rounding(mpfr_sum, N, rounding, fpcr);
                }
                // 检查上溢
                else if (biased_exp >= (1 << E) - 1) {
                    if (overflow_to_inf) {
                        result = FPInfinity(sign, N);
                    } else {
                        result = FPMaxNormal(sign, N);
                    }
                }
                // 正常情况：使用MPFR进行舍入
                else {
                    mpfr_t result_fp;
                    mpfr_init2(result_fp, 24); // FP32有24位有效数字
                    
                    // 转换为MPFR舍入模式
                    mpfr_rnd_t mpfr_rounding = roundmode_converter(rounding);
                    
                    // 执行舍入
                    mpfr_set(result_fp, mpfr_sum, mpfr_rounding);
                    
                    // 转换为uint32_t格式
                    result = mpfr_to_uint32(result_fp);
                    
                    mpfr_clear(result_fp);
                }
            }
            
            // 清理MPFR变量
            mpfr_clears(mpfr1_a, mpfr1_b, mpfr2_a, mpfr2_b, 
                       mpfr_product1, mpfr_product2, mpfr_sum, NULL);
        }
    }
    
    return result;
}


// FPProcessNaNs 函数实现 - 完整版本
bool FPProcessNaNs(FPType type1, FPType type2, uint32_t op1, uint32_t op2,
                           FPCR_Type fpcr, bool fpexc, uint8_t N, uint32_t* result) {
    // 验证N的有效性
    assert(N == 16 || N == 32 || N == 64);
    
    bool done;
    bool altfp = 1 && fpcr.AH == 1; // 假设FEAT_AFP已实现且不使用AArch32
    
    bool op1_nan = (type1 == FPType_SNaN || type1 == FPType_QNaN);
    bool op2_nan = (type2 == FPType_SNaN || type2 == FPType_QNaN);
    bool any_snan = (type1 == FPType_SNaN || type2 == FPType_SNaN);
    
    FPType type_nan = any_snan ? FPType_SNaN : FPType_QNaN;
    
    if (altfp && op1_nan && op2_nan) {
        // <n> register NaN selected
        done = true;
        *result = FPProcessNaN(type_nan, op1, fpcr, fpexc, N);
    }
    else if (type1 == FPType_SNaN) {
        done = true;
        *result = FPProcessNaN(type1, op1, fpcr, fpexc, N);
    }
    else if (type2 == FPType_SNaN) {
        done = true;
        *result = FPProcessNaN(type2, op2, fpcr, fpexc, N);
    }
    else if (type1 == FPType_QNaN) {
        done = true;
        *result = FPProcessNaN(type1, op1, fpcr, fpexc, N);
    }
    else if (type2 == FPType_QNaN) {
        done = true;
        *result = FPProcessNaN(type2, op2, fpcr, fpexc, N);
    }
    else {
        done = false;
        *result = Zeros(N); // 'Don't care' result
    }
    
    return done;
}

// FPAdd 函数实现
//op1为addend  op2为四个FP16乘加结果
uint32_t FPAdd(uint32_t op1, uint32_t op2, FPCR_Type fpcr, bool fpexc, uint8_t N, uint8_t add_sub) {
    // 验证N的有效性
    assert(N == 16 || N == 32 || N == 64);
    
    uint32_t result = 0;
    bool done = false;
    
    // 获取舍入模式
    FPRounding rounding = FPRoundingMode(fpcr);
    
    // 解包两个操作数
    FPType type1, type2;
    uint8_t sign1, sign2;
    float value1, value2;
    
    FPUnpack(op1, N, fpcr, fpexc, &type1, &sign1, &value1);
    FPUnpack(op2, N, fpcr, fpexc, &type2, &sign2, &value2);
    
    // 处理NaN
    done = FPProcessNaNs(type1, type2, op1, op2, fpcr, fpexc, N, &result);
    
    if (!done) {
        bool inf1 = (type1 == FPType_Infinity);
        bool inf2 = (type2 == FPType_Infinity);
        bool zero1 = (type1 == FPType_Zero);
        bool zero2 = (type2 == FPType_Zero);
        
        // 检查相反符号的无穷大相加（无效操作）
        if (inf1 && inf2 && sign1 != sign2) {
            result = FPDefaultNaN(fpcr, N);
            // if (fpexc) {
            //     FPProcessException(FPExc_InvalidOp, fpcr);
            // }
        }
        // 处理正无穷大
        else if ((inf1 && sign1 == 0) || (inf2 && sign2 == 0)) {
            result = FPInfinity(0, N);
        }
        // 处理负无穷大
        else if ((inf1 && sign1 == 1) || (inf2 && sign2 == 1)) {
            result = FPInfinity(1, N);
        }
        // 处理相同符号的零相加
        else if (zero1 && zero2 && sign1 == sign2) {
            result = FPZero(sign1, N);
        }
        // 正常计算：加法并舍入
        else {
            // 使用MPFR进行精确计算
            mpfr_t mpfr1, mpfr2, mpfr_sum;
            mpfr_prec_t prec = 512;
            
            mpfr_inits2(prec, mpfr1, mpfr2, mpfr_sum, NULL);
            
            // 清除之前的异常标志
            mpfr_clear_flags();
            
            // 将float值转换为MPFR高精度表示
            mpfr_set_flt(mpfr1, value1, MPFR_RNDN);
            mpfr_set_flt(mpfr2, value2, MPFR_RNDN);
            
            // 根据add_sub位选择加法或减法
            if (add_sub == 1) //addend + (a1*b1+a2*b2)
                mpfr_add(mpfr_sum, mpfr1, mpfr2, MPFR_RNDN);
            else if(add_sub == 0) //addend - (a1*b1+a2*b2)
                mpfr_sub(mpfr_sum, mpfr1, mpfr2, MPFR_RNDN);
            else
                fprintf(stderr, "错误:add_sub的值无效!期望0或1,但得到%d\n", add_sub);
            
            if (mpfr_zero_p(mpfr_sum)) {
                // 精确零结果：符号取决于舍入模式
                uint8_t result_sign = (rounding == FPRounding_NEGINF) ? 1 : 0;
                result = FPZero(result_sign, N);
            } else {
                // 内联舍入逻辑 - 直接处理舍入
                bool altfp = 1 && fpcr.AH == 1; // FPAdd不使用替代浮点格式
                bool satoflo = false;
                bool sign;
                int E;
                int biased_exp;
                bool overflow_to_inf;
                
                // 首先进行下溢处理
                if (overflow_handling(mpfr_sum, fpcr, N, prec, altfp, rounding, &sign, &biased_exp, &overflow_to_inf, satoflo, &E)) {
                    result = FPZero(sign, N);
                }
                // 检查是否在非规格化范围内
                else if (is_denormal_range(mpfr_sum, N)) {
                    result = handle_denormal_rounding(mpfr_sum, N, rounding, fpcr);
                }
                // 检查上溢
                else if (biased_exp >= (1 << E) - 1) {
                    if (overflow_to_inf) {
                        result = FPInfinity(sign, N);
                    } else {
                        result = FPMaxNormal(sign, N);
                    }
                }
                // 正常情况：使用MPFR进行舍入
                else {
                    mpfr_t result_fp;
                    int result_precision;
                    
                    // 根据N确定精度
                    if (N == 16) {
                        result_precision = 11; // FP16有11位有效数字
                    } else if (N == 32) {
                        result_precision = 24; // FP32有24位有效数字
                    }
                    
                    mpfr_init2(result_fp, result_precision);
                    
                    // 转换为MPFR舍入模式
                    mpfr_rnd_t mpfr_rounding = roundmode_converter(rounding);
                    
                    // 执行舍入
                    mpfr_set(result_fp, mpfr_sum, mpfr_rounding);
                    
                    // 转换为对应的格式
                    if (N == 16) {
                        result = mpfr_to_fp16(result_fp, mpfr_rounding);
                    } else if (N == 32) {
                        result = mpfr_to_uint32(result_fp);
                    }
                    
                    mpfr_clear(result_fp);
                }
            }
            
            // 清理MPFR变量
            mpfr_clears(mpfr1, mpfr2, mpfr_sum, NULL);
            
            // 处理非规格化数异常（如果启用）
            // if (fpexc) {
            //     FPProcessDenorms(type1, type2, N, fpcr);
            // }
        }
    }
    
    return result;
}