#include "C_ref_fmlal.h"

uint32_t FPMulAddH_ZA(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N, uint32_t fpcr_in)
{
    FPCR_Type fpcr = assign_FPCR(fpcr_in);//运行一次，将uint32_t的fpcr转为FPCR_Type类型
    const bool fpexc = false;
    fpcr.DN = 1;
    uint32_t result = FPMulAddH(addend, op1, op2, N, fpcr, fpexc);
    return result;
}

// FPMulAddH 实现
uint32_t FPMulAddH(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N,
                           FPCR_Type fpcr, bool fpexc) {
    // 验证N的有效性（根据伪代码，这里应该是32）
    assert(N == 32);
    
    // 获取舍入模式
    FPRounding rounding = FPRoundingMode(fpcr);
    
    // 解包三个操作数
    // addend是32位，op1和op2是16位
    FPType typeA, type1, type2;
    uint8_t signA, sign1, sign2;
    float valueA, value1, value2;
    
    // 解包32位加数
    FPUnpack(addend, N, fpcr, fpexc, &typeA, &signA, &valueA);
    // 解包16位操作数
    FPUnpack(op1, 16, fpcr, fpexc, &type1, &sign1, &value1);
    FPUnpack(op2, 16, fpcr, fpexc, &type2, &sign2, &value2);
    
    // 检查操作数类型
    bool inf1 = (type1 == FPType_Infinity);
    bool zero1 = (type1 == FPType_Zero);
    bool inf2 = (type2 == FPType_Infinity);
    bool zero2 = (type2 == FPType_Zero);
    
    // 处理NaN
    uint32_t result = 0;
    bool done = FPProcessNaNs3H(typeA, type1, type2, addend, op1, op2, 
                               fpcr, fpexc, N, &result);
    
    // 检查AFP特性和无效操作
    if (!(FEAT_AFP && fpcr.AH == 1)) {
        if (typeA == FPType_QNaN && ((inf1 && zero2) || (zero1 && inf2))) {
            result = FPDefaultNaN(fpcr, N);
            // if (fpexc) {
            //     FPProcessException(FPExc_InvalidOp, fpcr);
            // }
        }
    }
    
    if (!done) {
        bool infA = (typeA == FPType_Infinity);
        bool zeroA = (typeA == FPType_Zero);
        
        // 确定乘积的符号和类型
        uint8_t signP = sign1 ^ sign2; // 异或
        bool infP = inf1 || inf2;
        bool zeroP = zero1 || zero2;
        
        // 检查无效操作
        bool invalidop = (inf1 && zero2) || (zero1 && inf2) || 
                        (infA && infP && (signA != signP));
        
        if (invalidop) {
            result = FPDefaultNaN(fpcr, N);
            // if (fpexc) {
            //     FPProcessException(FPExc_InvalidOp, fpcr);
            // }
        }
        // 处理正无穷大
        else if ((infA && signA == 0) || (infP && signP == 0)) {
            result = FPInfinity(0, N);
        }
        // 处理负无穷大
        else if ((infA && signA == 1) || (infP && signP == 1)) {
            result = FPInfinity(1, N);
        }
        // 处理相同符号的零相加
        else if (zeroA && zeroP && signA == signP) {
            result = FPZero(signA, N);
        }
        // 正常计算：使用MPFR进行精确计算
        else {
            // 内联正常计算逻辑
            fpcr.AHP = 0;
            (void)fpexc;  // 标记参数为未使用
            
            bool satoflo = false;
            bool altfp = FEAT_AFP && fpcr.AH == 1;
            bool sign;
            int E;
            int biased_exp;
            bool overflow_to_inf;
            
            mpfr_rnd_t rounding_mode = roundmode_converter(rounding);
            
            // 初始化高精度MPFR变量
            mpfr_t mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum;
            mpfr_prec_t prec = 512;
            
            mpfr_inits2(prec, mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, NULL);
            mpfr_t result_fp32;
            mpfr_init2(result_fp32, 24); // FP32有24位有效数字
            
            // 清除之前的异常标志
            mpfr_clear_flags();
            
            // 将float值转换为MPFR高精度表示
            mpfr_set_flt(mpfr_A, value1, MPFR_RNDN);  // 16位操作数1
            mpfr_set_flt(mpfr_B, value2, MPFR_RNDN);  // 16位操作数2  
            mpfr_set_flt(mpfr_C, valueA, MPFR_RNDN);  // 32位加数
            
            // 精确计算 value1 * value2
            mpfr_mul(mpfr_product, mpfr_A, mpfr_B, MPFR_RNDN);
            // 精确计算 valueA + (value1 * value2)
            mpfr_add(mpfr_sum, mpfr_C, mpfr_product, MPFR_RNDN);
            
            if (mpfr_zero_p(mpfr_sum)) {
                // 精确零结果：符号取决于舍入模式
                uint8_t result_sign = (rounding == FPRounding_NEGINF) ? 1 : 0;
                result = FPZero(result_sign, N);
            } else {
                // 首先进行下溢处理
                if (overflow_handling(mpfr_sum, fpcr, N, prec, altfp, rounding, 
                                     &sign, &biased_exp, &overflow_to_inf, satoflo, &E)) {
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
                    // 将精确结果舍入到FP32精度（24位有效数字）
                    mpfr_set(result_fp32, mpfr_sum, rounding_mode);
                    result = mpfr_to_uint32(result_fp32);
                }
            }
            
            // 清理MPFR变量
            mpfr_clears(mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, result_fp32, NULL);
        }
    }
    
    return result;
}

// FPProcessNaNs3H 函数实现
bool FPProcessNaNs3H(FPType type1, FPType type2, FPType type3,
                    uint32_t op1, uint32_t op2, uint32_t op3,
                    FPCR_Type fpcr, bool fpexc, uint8_t N,
                    uint32_t* result) {
    // 验证N的有效性（根据伪代码，这里应该是32或64）
    assert(N == 32 || N == 64);
    
    // 当TRUE时，使用替代NaN传播规则
    bool altfp = FEAT_AFP && fpcr.AH == 1; // 假设不使用AArch32
    
    bool op1_nan = (type1 == FPType_SNaN || type1 == FPType_QNaN);
    bool op2_nan = (type2 == FPType_SNaN || type2 == FPType_QNaN);
    bool op3_nan = (type3 == FPType_SNaN || type3 == FPType_QNaN);
    
    FPType type_nan;
    if (altfp) {
        if (type1 == FPType_SNaN || type2 == FPType_SNaN || type3 == FPType_SNaN) {
            type_nan = FPType_SNaN;
        } else {
            type_nan = FPType_QNaN;
        }
    }
    
    bool done = false;
    
    // 处理多个操作数都是NaN的情况
    if (altfp && op1_nan && op2_nan && op3_nan) {
        // <n> register NaN selected
        done = true;
        uint32_t processed_nan = FPProcessNaN(type_nan, op2, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (altfp && op2_nan && (op1_nan || op3_nan)) {
        // <n> register NaN selected
        done = true;
        uint32_t processed_nan = FPProcessNaN(type_nan, op2, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (altfp && op3_nan && op1_nan) {
        // <m> register NaN selected
        done = true;
        uint32_t processed_nan = FPProcessNaN(type_nan, op3, fpcr, fpexc, N/2);
        *result = FPConvertNaN(processed_nan, N/2, N);
    }
    else if (type1 == FPType_SNaN) {
        done = true;
        *result = FPProcessNaN(type1, op1, fpcr, fpexc, N); // op1已经是N位，不需要转换
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
    else if (type1 == FPType_QNaN) {
        done = true;
        *result = FPProcessNaN(type1, op1, fpcr, fpexc, N); // op1已经是N位，不需要转换
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
    else {
        done = false;
        *result = Zeros(N); // 'Don't care' result
    }
    
    return done;
}


