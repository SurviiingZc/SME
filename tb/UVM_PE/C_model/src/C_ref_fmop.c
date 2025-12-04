#include "C_ref_fmop.h"

// FPMulAdd_ZA 函数实现
//该函数接口与伪代码一样，输入数据均为 uin32_t; N是默认输入(需在SV中判断当前精度后赋值)，其中FPCR寄存器低20位有效
//add_sub = 1 加 ; add_sub = 0 减
uint32_t FPMulAdd_ZA(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N, uint32_t fpcr_in, uint8_t add_sub) {
    
    // 验证N的有效性
    assert(N == 16 || N == 32);

    FPCR_Type fpcr = assign_FPCR(fpcr_in);//运行一次，将uin32_t的fpcr转为FPCR_Type类型

    bool fpexc = false;
    fpcr.DN = 1;

    // 解包三个操作数
    FPType typeA, type1, type2;
    uint8_t signA, sign1, sign2;
    float valueA, value1, value2;
    
    FPUnpack(addend, N, fpcr, fpexc, &typeA, &signA, &valueA);
    FPUnpack(op1, N, fpcr, fpexc, &type1, &sign1, &value1);
    FPUnpack(op2, N, fpcr, fpexc, &type2, &sign2, &value2);
    
    // 获取舍入模式
    FPRounding rounding = FPRoundingMode(fpcr);
    
    // 检查操作数类型
    bool inf1 = (type1 == FPType_Infinity);
    bool zero1 = (type1 == FPType_Zero);
    bool inf2 = (type2 == FPType_Infinity);
    bool zero2 = (type2 == FPType_Zero);
    
    // 处理NaN
    uint32_t result = 0;
    bool done = FPProcessNaNs3(typeA, type1, type2, addend, op1, op2, fpcr, fpexc, N, &result);
    
    // 检查AFP特性和无效操作
    if (!(1 && fpcr.AH == 1)) {
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
        // 正常计算
        else {
            result = FMOPA_Normal_Compute(valueA, value1, value2, N, fpcr, rounding, fpexc ,add_sub);
        }
    }
    
    return result;
}

// FPMulAdd 函数实现
//该函数为测试函数
uint32_t FPMulAdd(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N, FPCR_Type fpcr, bool fpexc, uint8_t add_sub) {
    
    // 验证N的有效性
    assert(N == 16 || N == 32);

    fpexc = false;
    fpcr.DN = 1;

    // 解包三个操作数
    FPType typeA, type1, type2;
    uint8_t signA, sign1, sign2;
    float valueA, value1, value2;
    
    FPUnpack(addend, N, fpcr, fpexc, &typeA, &signA, &valueA);
    FPUnpack(op1, N, fpcr, fpexc, &type1, &sign1, &value1);
    FPUnpack(op2, N, fpcr, fpexc, &type2, &sign2, &value2);
    
    // 获取舍入模式
    FPRounding rounding = FPRoundingMode(fpcr);
    
    // 检查操作数类型
    bool inf1 = (type1 == FPType_Infinity);
    bool zero1 = (type1 == FPType_Zero);
    bool inf2 = (type2 == FPType_Infinity);
    bool zero2 = (type2 == FPType_Zero);
    
    // 处理NaN
    uint32_t result = 0;
    bool done = FPProcessNaNs3(typeA, type1, type2, addend, op1, op2, fpcr, fpexc, N, &result);
    
    // 检查AFP特性和无效操作
    if (!(1 && fpcr.AH == 1)) {
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
        // 正常计算
        else {
            result = FMOPA_Normal_Compute(valueA, value1, value2, N, fpcr, rounding, fpexc, add_sub);
        }
    }
    
    return result;
}

// FPZero函数 - 返回标准的零值
uint32_t FPZero(uint8_t sign, uint8_t N) {
    // 检查N的有效性
    assert(N == 16 || N == 32);
    
    int E, F;
    uint32_t exp, frac, result;
    
    // 根据N确定指数位和尾数位的长度
    if (N == 16) {
        E = 5;
        F = 10;
    } else { // (N == 32) 
        E = 8;
        F = 23;
    } 
    
    // 创建全0的指数部分
    exp = 0;
    
    // 创建全0的尾数部分
    frac = 0;
    sign = sign & 0x1;
    // 组合符号位、指数部分和尾数部分
    result = ((uint32_t)sign << (E + F)) | (exp << F) | frac;
    
    return result;
}

bool IsZero(uint32_t x, int n) {
    return (x & ((1 << n) - 1)) == 0;
}

bool IsOnes(uint32_t x, int n) {
    // 使用无符号比较避免符号警告
    uint32_t mask = (1U << n) - 1;
    return (x & mask) == mask;
}


uint32_t Replicate(uint32_t x, int m, int n) {
    uint32_t result = 0;
    for (int i = 0; i < n; i++) {
        result = (result << m) | (x & ((1 << m) - 1));
    }
    return result;
}

// FPUnpackBase函数 (带isbfloat16参数)
void FPUnpackBase(uint32_t fpval, uint8_t N, FPCR_Type fpcr_in, bool fpexc, bool isbfloat16, 
                    FPType* type, uint8_t* sign, float* value) 
{
    assert(N == 16 || N == 32 || N == 64);

    FPCR_Type fpcr_local = fpcr_in;

    bool altfp = 1;
    bool fiz = altfp && (fpcr_local.FIZ == '1');
    bool fz = (fpcr_local.FZ == '1') && !(altfp && (fpcr_local.AH == '1'));

    if (N == 16 && !isbfloat16) {
        // 处理16位半精度浮点数
        uint16_t fp16_val = uint32_to_fp16(fpval); // 提取低16位
        *sign = (fp16_val >> 15) & 0x1;
        uint8_t exp16 = (fp16_val >> 10) & 0x1F;
        uint16_t frac16 = fp16_val & 0x3FF;

        if (IsZero(exp16, 5)) {
            if (IsZero(frac16, 10) || fpcr_local.FZ16 == 1) {
                *type = FPType_Zero;
                *value = 0.0;
            } 
            else {
                *type = FPType_Denormal;
                // 使用精确的计算方法
                *value = (float)frac16 * powf(2.0f, -24.0f);
                if (*sign == 1) {
                    *value = -*value;
                }
            }
        } 
        else if (IsOnes(exp16, 5) && fpcr_local.AHP == 0) {
            if (IsZero(frac16, 10)) {
                *type = FPType_Infinity;
                *value = HUGE_VAL;
            } else {
                *type = (frac16 & 0x200) ? FPType_QNaN : FPType_SNaN;
                *value = NAN;
            }
        } else {
            *type = FPType_Nonzero;
            // 使用fp16_to_float确保精度
            *value = fp16_to_float(fp16_val);
        }
    }
    else if (N == 32 || isbfloat16) {
        // 处理32位单精度浮点数或bfloat16
        uint8_t exp32;
        uint32_t frac32;

        if (isbfloat16) {
            *sign = (fpval >> 15) & 0x1;
            exp32 = (fpval >> 7) & 0xFF;
            frac32 = (fpval & 0x7F) << 16; // 将7位尾数放在高位，低位填充0
        } else {
            *sign = (fpval >> 31) & 0x1;
            exp32 = (fpval >> 23) & 0xFF;
            frac32 = fpval & 0x7FFFFF;
        }
        if (IsZero(exp32, 8)) {
            if (IsZero(frac32, isbfloat16 ? 7 : 23)) {
               *type = FPType_Zero;
               *value = 0.0;
            } else if (fz || fiz) {
               *type = FPType_Zero;
               *value = 0.0;
               if (fz && fpexc) {
                //    FPProcessException(FPExc_InputDenorm, fpcr_local);
               }
            } else {
               *type = FPType_Denormal;
               *value = pow(2.0, -126) * (frac32 * pow(2.0, isbfloat16 ? -7 : -23));
            }
        } else if (IsOnes(exp32, 8)) {
            if (IsZero(frac32, isbfloat16 ? 7 : 23)) {
               *type = FPType_Infinity;
               *value = HUGE_VAL;
            } else {
               *type = (frac32 & (isbfloat16 ? 0x400000 : 0x400000)) ? FPType_QNaN : FPType_SNaN;
               *value = NAN;
            }
        } else {
            *type = FPType_Nonzero;
            *value = pow(2.0, exp32 - 127) * (1.0 + frac32 * pow(2.0, isbfloat16 ? -7 : -23));
        }

        if (*sign == 1) {
        *value = -*value;
    }
    }
}

// FPUnpackBase1函数 (无isbfloat16参数)
void FPUnpackBase1(uint32_t fpval, uint8_t N, FPCR_Type fpcr_in, bool fpexc, 
                    FPType* type, uint8_t* sign, float* value) 
{
    bool isbfloat16 = false;
    FPUnpackBase(fpval, N, fpcr_in, fpexc, isbfloat16, type, sign, value);
}

void FPUnpack(uint32_t fpval, uint8_t N, FPCR_Type fpcr_in, bool fpexc,
                FPType* fptype, uint8_t* sign, float* value)
{
    FPCR_Type fpcr_local = fpcr_in;
    fpcr_local.AHP = 0; // AHP位设置为0，选择IEEE标准半精度格式

    FPUnpackBase1(fpval, N, fpcr_local, fpexc, fptype, sign, value);
}

FPRounding FPDecodeRounding(uint8_t rmode) {
    switch (rmode) {
        case 0: // '00'
            return FPRounding_TIEEVEN; // 向最接近的偶数舍入
        case 1: // '01'
            return FPRounding_POSINF;  // 向正无穷方向舍入
        case 2: // '10'
            return FPRounding_NEGINF;  // 向负无穷方向舍入
        case 3: // '11'
            return FPRounding_ZERO;    // 向零方向舍入
        default:
            // 默认情况下返回最常用的舍入模式
            return FPRounding_TIEEVEN;
    }
}

// FPRoundingMode 函数
// 返回当前的浮点数舍入模式
FPRounding FPRoundingMode(FPCR_Type fpcr) {
    return FPDecodeRounding(fpcr.RMode);
}

/******************************************************************************
 * 函数名称: [assign_FPCR]
 * 
 * 功能描述: 
 *   [将输入的uint32 fpcr值赋值给预先定义的结构体，便于调用，在最开始运行一次即可]
 * 
 * 参数说明:
 *   [in] uint32_t FPCR_IN: [从SV输入的20位FPCR值，低20位有效]
 * 
 * 返回值:无，直接赋值结构体
 ******************************************************************************/
FPCR_Type assign_FPCR(uint32_t FPCR_IN) {
    FPCR_Type fpcr;
    
    // 提取各个位字段 (只取低20位)
    uint32_t fpcr_value = FPCR_IN & 0xFFFFF; // 确保只使用低20位
    
    fpcr.AHP = (fpcr_value >> 19) & 0x1;     // Bit[19] -> AHP
    fpcr.DN = (fpcr_value >> 18) & 0x1;       // Bit[18] -> DN
    fpcr.FZ = (fpcr_value >> 17) & 0x1;       // Bit[17] -> FZ
    fpcr.RMode = (fpcr_value >> 15) & 0x3;    // Bits[16:15] -> RMode (2位)
    fpcr.Stride = (fpcr_value >> 13) & 0x3;   // Bits[14:13] -> Stride (2位)
    fpcr.FZ16 = (fpcr_value >> 12) & 0x1;     // Bit[12] -> FZ16
    fpcr.Len = (fpcr_value >> 10) & 0x3;      // Bits[11:10] -> Len (2位)
    fpcr.IDE = (fpcr_value >> 9) & 0x1;       // Bit[9] -> IDE
    fpcr.EBF = (fpcr_value >> 8) & 0x1;       // Bit[8] -> EBF
    fpcr.IXE = (fpcr_value >> 7) & 0x1;       // Bit[7] -> IXE
    fpcr.UFE = (fpcr_value >> 6) & 0x1;       // Bit[6] -> UFE
    fpcr.OFE = (fpcr_value >> 5) & 0x1;       // Bit[5] -> OFE
    fpcr.DZE = (fpcr_value >> 4) & 0x1;       // Bit[4] -> DZE
    fpcr.IOE = (fpcr_value >> 3) & 0x1;       // Bit[3] -> IOE
    fpcr.NEP = (fpcr_value >> 2) & 0x1;       // Bit[2] -> NEP
    fpcr.AH = (fpcr_value >> 1) & 0x1;        // Bit[1] -> AH
    fpcr.FIZ = fpcr_value & 0x1;              // Bit[0] -> FIZ
    
    return fpcr;
}

// FPBits 函数实现
FPBitsType FPBits(uint8_t N, bool isbfloat16) {
    FPBitsType result;
    
    if (N == 16) {
        // 16位半精度浮点数
        result.minimum_exp = -14;
        result.F = 10;
    } else if (N == 32 && isbfloat16) {
        // 32位存储的bfloat16格式
        result.minimum_exp = -126;
        result.F = 7;
    } else if (N == 32) {
        // 32位单精度浮点数
        result.minimum_exp = -126;
        result.F = 23;
    } else { // N == 64
        // 64位双精度浮点数
        result.minimum_exp = -1022;
        result.F = 52;
    }
    
    return result;
}

mpfr_rnd_t roundmode_converter(FPRounding rounding){
    switch (rounding){
        case FPRounding_TIEEVEN: // 向最接近的偶数舍入
                    return MPFR_RNDN;
        case FPRounding_POSINF: // 向正无穷方向舍入
                    return MPFR_RNDU;
        case FPRounding_NEGINF: // 向负无穷方向舍入
                    return MPFR_RNDD;
        case FPRounding_ZERO:    // 向零方向舍入
                    return MPFR_RNDZ;
        default:                 // 默认情况下返回最常用的舍入模式
                    return MPFR_RNDN;
    }
}

// overflow_handling 函数
bool overflow_handling(mpfr_t mpfr_sum, FPCR_Type fpcr, uint8_t N, mpfr_prec_t prec,
                      bool altfp, FPRounding rounding, bool* sign_ptr, 
                      int* biased_exp_ptr, bool* overflow_to_inf_ptr, bool satoflo, int* E_ptr) {
    FPBitsType FPBits_32 = FPBits(N, false);   
    
    // 计算格式参数
    int F = FPBits_32.F;  // 尾数位数
    int minimum_exp = FPBits_32.minimum_exp;
    *E_ptr = N - (F + 1);  // 指数位数
    
    int exponent = 0; // 指数
    mpfr_t mantissa; // 尾数 (使用 MPFR 类型)
    
    // 初始化尾数变量（使用相同的精度）
    mpfr_init2(mantissa, prec); 

    if (mpfr_sgn(mpfr_sum) < 0) {
        *sign_ptr = 1;
        mpfr_abs(mantissa, mpfr_sum, MPFR_RNDN);
    } else {
        *sign_ptr = 0;
        mpfr_set(mantissa, mpfr_sum, MPFR_RNDN);
    }

    mpfr_t one, two;
    mpfr_inits2(prec, one, two, NULL);
    mpfr_set_d(one, 1.0, MPFR_RNDN);
    mpfr_set_d(two, 2.0, MPFR_RNDN);
    
    // 当尾数 < 1.0 时：乘以 2，指数减 1
    while (mpfr_less_p(mantissa, one)) {
        mpfr_mul_ui(mantissa, mantissa, 2, MPFR_RNDN);
        exponent--;
    }
    // 当尾数 >= 2.0 时：除以 2，指数加 1
    while (mpfr_greaterequal_p(mantissa, two)) {
        mpfr_div_ui(mantissa, mantissa, 2, MPFR_RNDN);
        exponent++;
    }
    // 清理临时变量
    mpfr_clears(one, two, NULL);

    if (!altfp && ((fpcr.FZ == 1 && N != 16) || (fpcr.FZ16 == 1 && N == 16)) && exponent < minimum_exp){
        mpfr_clear(mantissa);
        return 1;  //直接返回     
    }

    // 计算未约束的偏置指数和尾数
    int biased_exp_unconstrained = (exponent - minimum_exp) + 1;

    // 初始化相关变量(下溢)
    mpfr_t mantissa_scaled, int_part, error_unconstrained;
    mpfr_inits2(prec, mantissa_scaled, int_part, error_unconstrained, NULL);
    
    // mantissa_scaled = mantissa * 2^F
    mpfr_mul_2exp(mantissa_scaled, mantissa, F, MPFR_RNDN);
    // int_part = int_mant_unconstrained
    mpfr_floor(int_part, mantissa_scaled);
    //将 int_part 转为长整型
    long long int_mant_unconstrained = mpfr_get_si(int_part, MPFR_RNDN);
    // 计算 error_unconstrained
    mpfr_sub(error_unconstrained, mantissa_scaled, int_part, MPFR_RNDN);
    //将 error_unconstrained 转为 double类型
    double error_val = mpfr_get_d(error_unconstrained, MPFR_RNDN);

    // 初始化相关变量(上溢)
    mpfr_t mantissa_scaled_1, int_part_1, error_unconstrained_1;
    mpfr_inits2(prec, mantissa_scaled_1, int_part_1, error_unconstrained_1, NULL);

    int biased_exp_local;
    if((exponent - minimum_exp + 1) > 0)
        biased_exp_local = exponent - minimum_exp + 1;
    else 
        biased_exp_local = 0;

    if(biased_exp_local == 0){
        int exp_diff = minimum_exp - exponent;
        if (exp_diff > 0) 
            // 除以2的正数次幂
            mpfr_div_2exp(mantissa, mantissa, (unsigned long)exp_diff, MPFR_RNDN);
        else if (exp_diff < 0) 
            // 除以2的负数次幂等价于乘以2的正数次幂
            mpfr_mul_2exp(mantissa, mantissa, (unsigned long)(-exp_diff), MPFR_RNDN);
    }
    // mantissa_scaled_1 = mantissa * 2^F
    mpfr_mul_2exp(mantissa_scaled_1, mantissa, F, MPFR_RNDN);
    // int_part_1 = int_mant
    mpfr_floor(int_part_1, mantissa_scaled_1);
    //将 int_mant 转为长整型
    long long int_mant = mpfr_get_si(int_part_1, MPFR_RNDN);
    // 计算 error
    mpfr_sub(error_unconstrained_1, mantissa_scaled_1, int_part_1, MPFR_RNDN);
    //将 error_unconstrained 转为 double类型
    double error = mpfr_get_d(error_unconstrained_1, MPFR_RNDN);

    // 根据舍入模式决定是否向上舍入
    bool round_up_unconstrained;
    bool round_up;
    if(altfp){
        switch (rounding) {
            case FPRounding_TIEEVEN:
                round_up_unconstrained = (error_val > 0.5 || 
                    (error_val == 0.5 && (int_mant_unconstrained & 1)));
                round_up = (error > 0.5 || (error == 0.5 && (int_mant & 1)));
                *overflow_to_inf_ptr = !satoflo;
                break;
            case FPRounding_POSINF:
                round_up_unconstrained = (error_val != 0.0 && *sign_ptr == 0);
                round_up = (error != 0.0 && *sign_ptr == 0);
                *overflow_to_inf_ptr = (*sign_ptr == 0);
                break;
            case FPRounding_NEGINF:
                round_up_unconstrained = (error_val != 0.0 && *sign_ptr == 1);
                round_up = (error != 0.0 && *sign_ptr == 1);
                *overflow_to_inf_ptr = (*sign_ptr == 1);
                break;
            case FPRounding_ZERO:
                round_up_unconstrained = false;
                round_up = false;
                *overflow_to_inf_ptr = false;
                break;
            default:
                round_up_unconstrained = false;
                round_up = false;
                *overflow_to_inf_ptr = false;
                break;
        }
        
        if (round_up_unconstrained) {
            int_mant_unconstrained = int_mant_unconstrained + 1;
            if (int_mant_unconstrained == (1LL << (F + 1))) { //2^(F+1)
                biased_exp_unconstrained = biased_exp_unconstrained + 1;
                int_mant_unconstrained >>= 1; //DIV 2
            }
        }

        if (biased_exp_unconstrained < 1 && int_mant_unconstrained != 0) {
            if ((fpcr.FZ == 1 && N != 16) || (fpcr.FZ16 == 1 && N == 16)) {
                mpfr_clears(mantissa_scaled, int_part, error_unconstrained, mantissa, NULL);
                mpfr_clears(mantissa_scaled_1, int_part_1, error_unconstrained_1, NULL);
                return 1;
            } 
        }
        mpfr_clears(mantissa_scaled, int_part, error_unconstrained, mantissa_scaled_1, int_part_1, error_unconstrained_1,NULL);
    }
    else{ // altfp == FALSE
        switch (rounding) {
            case FPRounding_TIEEVEN:
                round_up = (error > 0.5 || (error == 0.5 && (int_mant & 1)));
                *overflow_to_inf_ptr = !satoflo;
                break;
            case FPRounding_POSINF:
                round_up = (error != 0.0 && *sign_ptr == 0);
                *overflow_to_inf_ptr = (*sign_ptr == 0);
                break;
            case FPRounding_NEGINF:
                round_up = (error != 0.0 && *sign_ptr == 1);
                *overflow_to_inf_ptr = (*sign_ptr == 1);
                break;
            case FPRounding_ZERO:
                round_up = false;
                *overflow_to_inf_ptr = false;
                break;
            default:
                round_up = false;
                *overflow_to_inf_ptr = false;
                break;
        }
    }
    if(round_up){
        int_mant = int_mant + 1;
        if(int_mant == (1LL << F))
            biased_exp_local = 1;
        if (int_mant == (1LL << (F + 1))) {
            biased_exp_local = biased_exp_local + 1;
            int_mant = int_mant / 2; 
        }
    }
    
    *biased_exp_ptr = biased_exp_local;
    
    mpfr_clears(mantissa_scaled, int_part, error_unconstrained, mantissa_scaled_1, 
                int_part_1, error_unconstrained_1, mantissa, NULL);
    return 0;
}

uint32_t mpfr_to_uint32(mpfr_t result_fp) {
    float f = mpfr_get_flt(result_fp, MPFR_RNDN);
    
    // 使用联合体进行类型转换
    union {
        float f;
        uint32_t u;
    } converter;
    
    converter.f = f;
    return converter.u;
}

// FP16专用的MPFR转换函数
uint32_t mpfr_to_fp16(mpfr_t result_fp, mpfr_rnd_t rounding_mode) {
    float f = mpfr_get_flt(result_fp, rounding_mode); // 使用传入的舍入模式
    uint16_t fp16_bits = float_to_fp16(f);            // 注意：float_to_fp16 也需要修改以支持舍入模式
    return fp16_to_uint32(fp16_bits);
}

uint32_t FMOPA_Normal_Compute(float valueA, float value1, float value2, uint8_t N, FPCR_Type fpcr_in,
                                FPRounding rounding, bool fpexc, uint8_t add_sub) {
    FPCR_Type fpcr =  fpcr_in;
    fpcr.AHP = 0;
    // bool isbfloat16 = false;
    (void)fpexc;  // 标记参数为未使用
    bool satoflo = false;
    assert(N == 16 || N == 32);
    bool altfp = 1 && fpcr.AH == 1;
    bool sign;
    int E;
    int biased_exp;
    bool overflow_to_inf;
    uint32_t result;    //最终返回结果
    mpfr_rnd_t rounding_mode;
    rounding_mode = roundmode_converter(rounding);
    // 初始化高精度MPFR变量
    mpfr_t mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum;
    mpfr_prec_t prec = 512;
    if(N==32){  //计算value1*value2+valueA
        mpfr_t result_fp32;
        mpfr_inits2(prec, mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, NULL);
        mpfr_init2(result_fp32, 24); // FP32有24位有效数字（23位显式+1位隐含）
         // 清除之前的异常标志
        mpfr_clear_flags();
        
        // 将float值转换为MPFR高精度表示
        mpfr_set_flt(mpfr_A, value1, MPFR_RNDN);
        mpfr_set_flt(mpfr_B, value2, MPFR_RNDN);
        mpfr_set_flt(mpfr_C, valueA, MPFR_RNDN);

        // 精确计算 A * B
        mpfr_mul(mpfr_product, mpfr_A, mpfr_B, MPFR_RNDN);
        // 根据add_sub位选择加法或减法
        if (add_sub == 1) //c + (a*b)
            mpfr_add(mpfr_sum, mpfr_C, mpfr_product, MPFR_RNDN);
        else if(add_sub == 0) //c - (a*b)
            mpfr_sub(mpfr_sum, mpfr_C, mpfr_product, MPFR_RNDN);
        else
            fprintf(stderr, "错误:add_sub的值无效!期望0或1,但得到%d\n", add_sub);

        if(mpfr_zero_p(mpfr_sum)){ 
            uint8_t result_sign=1;
            if(rounding == FPRounding_NEGINF)
                result_sign = 1;
            else
                result_sign = 0;
            return result = FPZero(result_sign, N);  //直接返回
        }
        else{
            //首先进行下溢处理
            if(overflow_handling(mpfr_sum, fpcr, N, prec, altfp, rounding, &sign, &biased_exp, &overflow_to_inf, satoflo, &E)){ 
                    return result = FPZero(sign, N);
            }

            if (is_denormal_range(mpfr_sum, N))
            {
                result = handle_denormal_rounding(mpfr_sum, N, rounding, fpcr);
                mpfr_clears(mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, result_fp32, NULL);
                return result;
            }

            //Single, double or IEEE half precision
            if(N != 16 || fpcr.AHP == 0){
                if(biased_exp >= (1 << E) - 1){
                    if(overflow_to_inf)
                        result = FPInfinity(sign, N);
                    else
                        result = FPMaxNormal(sign, N);
                }
                else {  //无上溢情况，直接用MPFR库的舍入
                    // 将精确结果舍入到FP32精度（24位有效数字）
                    mpfr_set(result_fp32, mpfr_sum, rounding_mode);
                    result = mpfr_to_uint32(result_fp32);
                }
            }
        }
        // 清理MPFR变量
        mpfr_clears(mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, result_fp32, NULL);
    }
    else if (N == 16) {
        // FP16处理逻辑
        mpfr_t result_fp16;
        mpfr_inits2(prec, mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, NULL);
        mpfr_init2(result_fp16, 11); // FP16有11位有效数字
        
        mpfr_clear_flags();
        
        // 将float值转换为MPFR高精度表示
        mpfr_set_flt(mpfr_A, value1, MPFR_RNDN);
        mpfr_set_flt(mpfr_B, value2, MPFR_RNDN);
        mpfr_set_flt(mpfr_C, valueA, MPFR_RNDN);

        // 精确计算 A * B
        mpfr_mul(mpfr_product, mpfr_A, mpfr_B, MPFR_RNDN);
        // 根据add_sub位选择加法或减法
        if (add_sub == 1) //c + (a*b)
            mpfr_add(mpfr_sum, mpfr_product, mpfr_C, MPFR_RNDN);
        else if(add_sub == 0) //c - (a*b)
            mpfr_sub(mpfr_sum, mpfr_C, mpfr_product, MPFR_RNDN);
        else
            fprintf(stderr, "错误:add_sub的值无效!期望0或1,但得到%d\n", add_sub);

        if (mpfr_zero_p(mpfr_sum)) { 
            uint8_t result_sign = 1;
            if (rounding == FPRounding_NEGINF)
                result_sign = 1;
            else
                result_sign = 0;
            result = FPZero(result_sign, N);
        } 
        else {
            // 首先进行下溢处理
            if (overflow_handling(mpfr_sum, fpcr, N, prec, altfp, rounding, &sign, &biased_exp, &overflow_to_inf, satoflo, &E)) { 
                result = FPZero(sign, N);
            }

            if (is_denormal_range(mpfr_sum, N)) {
                result = handle_denormal_rounding(mpfr_sum, N, rounding, fpcr);
                mpfr_clears(mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, result_fp16, NULL);
                return result;
            }

            else {
                // IEEE half precision
                if (fpcr.AHP == 0) {
                    if (biased_exp >= (1 << E) - 1) {
                        if (overflow_to_inf)
                            result = FPInfinity(sign, N);
                        else
                            result = FPMaxNormal(sign, N);
                    } else {
                        // 无上溢情况，使用FP16专用的转换
                        mpfr_set(result_fp16, mpfr_sum, rounding_mode);
                        result = mpfr_to_fp16(result_fp16, rounding_mode);
                    }
                }
                // //Alternative half precision（处理存疑）
                // else {
                //     if(biased_exp >= (1 << E)){
                //         // 提取符号位的最低有效位（0或1）并扩展到32位
                //         uint32_t sign_extended = (sign & 1) ? 0xFFFFFFFF : 0;
                //         // 生成一个低31位全1的掩码
                //         uint32_t ones_mask = (1U << 31) - 1;
                //         // 组合结果：符号位放在最高位，其余31位为1
                //         result = (sign_extended & 0x80000000) | ones_mask;
                //     }
                //     else{
                //         mpfr_set(result_fp32, mpfr_sum, rounding_mode);
                //         result = mpfr_to_uint32(result_fp32);
                //     }
                // }
            }
        }
        
        // 清理MPFR变量
        mpfr_clears(mpfr_A, mpfr_B, mpfr_C, mpfr_product, mpfr_sum, result_fp16, NULL);
    }
    return result;

}

// FPDefaultNaN 函数实现
uint32_t FPDefaultNaN(FPCR_Type fpcr, uint8_t N) {
    // 检查 N 的有效性
    assert(N == 16 || N == 32);
    
    int E, F;
    uint32_t sign, exp, frac, result;
    
    // 根据 N 确定指数位和尾数位的长度
    if (N == 16) {
        E = 5;
        F = 10;
    } else { // (N == 32) 
        E = 8;
        F = 23;
    } 
    
    // 确定符号位
    if (1) { // FEAT_AFP 假设为 1
        sign = fpcr.AH;
    } else {
        sign = 0;
    }
    
    // 创建全1的指数部分
    exp = (1ULL << E) - 1;
    
    // 创建尾数部分：最高位为1，其余为0
    frac = 1ULL << (F - 1); // 设置最高位为1
    
    // 组合符号位、指数部分和尾数部分
    result = (sign << (E + F)) | (exp << F) | frac;
    
    return result;
}

// FPInfinity函数 - 返回一个标准的无穷大值
uint32_t FPInfinity(uint8_t sign, uint8_t N) {
    // 检查N的有效性
    assert(N == 16 || N == 32);
    
    int E, F;
    uint32_t exp, frac, result;
    
    // 根据N确定指数位和尾数位的长度
    if (N == 16) {
        E = 5;
        F = 10;
    } else {//(N == 32) 
        E = 8;
        F = 23;
    }
    
    // 创建全1的指数部分
    exp = (1ULL << E) - 1;
    
    // 创建全0的尾数部分
    frac = 0;
    sign = sign & 0x1;
    // 组合符号位、指数部分和尾数部分
    result = ((uint32_t)sign << (E + F)) | (exp << F) | frac;
    
    return result;
}

uint32_t Zeros(uint8_t N) {
    (void)N;  // 标记参数为未使用
    return 0;
}

uint32_t FPMaxNormal(uint8_t sign, uint8_t N) {
    // 验证 N 的有效值（只支持 16 和 32 位）
    assert(N == 16 || N == 32);
    
    int E, F;
    // 根据 N 确定指数位和尾数位的长度
    if (N == 16) {
        E = 5;
        F = 10;
    } else { // N == 32
        E = 8;
        F = 23;
    }
    
    // 清理符号位（只保留最低有效位）
    uint32_t clean_sign = (sign & 1) ? 1 : 0;
    
    // 构建指数部分：E-1 个 1 后跟一个 0
    uint32_t exp = ((1U << (E - 1)) - 1) << 1;
    
    // 构建尾数部分：F 个 1
    uint32_t frac = (1U << F) - 1;
    
    // 组合各部分：符号位 | 指数部分 | 尾数部分
    return (clean_sign << (E + F)) | (exp << F) | frac;
}


// FPProcessNaN 函数 (4参数版本)
uint32_t FPProcessNaN(FPType fptype, uint32_t op, FPCR_Type fpcr, bool fpexc, uint8_t N) {
    // 检查参数有效性
    assert(N == 16 || N == 32);
    assert(fptype == FPType_QNaN || fptype == FPType_SNaN);
    (void)fpexc;  // 标记参数为未使用
    int topfrac;
    uint32_t result = op;
    
    // 根据N确定topfrac的位置
    switch (N) {
        case 16:
            topfrac = 9;
            break;
        case 32:
            topfrac = 22;
            break;
        case 64:
            topfrac = 51;
            break;
        default:
            topfrac = 0; // 不应该发生，因为有assert
    }
    
    // 处理SNaN
    if (fptype == FPType_SNaN) {
        // 将第topfrac位设置为1，将SNaN转换为QNaN
        result |= (1U << topfrac);
    
    }
    
    // 检查是否使用默认NaN
    if (fpcr.DN == 1) {
        result = FPDefaultNaN(fpcr, N);
    }
    
    return result;
}

// FPProcessNaNs3 函数
bool FPProcessNaNs3(FPType type1, FPType type2, FPType type3,
                   uint32_t op1, uint32_t op2, uint32_t op3,
                   FPCR_Type fpcr, bool fpexc, int N,
                   uint32_t* result) {
    // 检查 N 的有效性
    assert(N == 16 || N == 32 || N == 64);
    
    // 检查操作数是否为 NaN
    bool op1_nan = (type1 == FPType_SNaN || type1 == FPType_QNaN);
    bool op2_nan = (type2 == FPType_SNaN || type2 == FPType_QNaN);
    bool op3_nan = (type3 == FPType_SNaN || type3 == FPType_QNaN);
    
    // 检查是否实现了 AFP 特性
    bool altfp = 1 && fpcr.AH == 1;
    
    FPType type_nan;
    if (altfp) {
        if (type1 == FPType_SNaN || type2 == FPType_SNaN || type3 == FPType_SNaN) {
            type_nan = FPType_SNaN;
        } else {
            type_nan = FPType_QNaN;
        }
    }
    
    bool done = false;
    
    // 处理多个操作数都是 NaN 的情况
    if (altfp && op1_nan && op2_nan && op3_nan) {
        // <n> register NaN selected
        done = true;
        *result = FPProcessNaN(type_nan, op2, fpcr, fpexc, N);
    } else if (altfp && op2_nan && (op1_nan || op3_nan)) {
        // <n> register NaN selected
        done = true;
        *result = FPProcessNaN(type_nan, op2, fpcr, fpexc, N);
    } else if (altfp && op3_nan && op1_nan) {
        // <m> register NaN selected
        done = true;
        *result = FPProcessNaN(type_nan, op3, fpcr, fpexc, N);
    } else if (type1 == FPType_SNaN) {
        done = true;
        *result = FPProcessNaN(type1, op1, fpcr, fpexc, N);
    } else if (type2 == FPType_SNaN) {
        done = true;
        *result = FPProcessNaN(type2, op2, fpcr, fpexc, N);
    } else if (type3 == FPType_SNaN) {
        done = true;
        *result = FPProcessNaN(type3, op3, fpcr, fpexc, N);
    } else if (type1 == FPType_QNaN) {
        done = true;
        *result = FPProcessNaN(type1, op1, fpcr, fpexc, N);
    } else if (type2 == FPType_QNaN) {
        done = true;
        *result = FPProcessNaN(type2, op2, fpcr, fpexc, N);
    } else if (type3 == FPType_QNaN) {
        done = true;
        *result = FPProcessNaN(type3, op3, fpcr, fpexc, N);
    } else {
        done = false;
        *result = Zeros(N); // 'Don't care' result
    }
    
    return done;
}

/**
 * 将FP16位模式转换为float值
 */
float fp16_to_float(uint16_t fp16_bits) {
    // 提取符号、指数和尾数
    int sign = (fp16_bits >> 15) & 1;
    int exponent = (fp16_bits >> 10) & 0x1F;
    uint16_t mantissa = fp16_bits & 0x3FF;
    
    // 处理特殊值
    if (exponent == 0x1F) {
        if (mantissa == 0) {
            return sign ? -INFINITY : INFINITY;
        } else {
            return NAN;
        }
    }
    
    // 处理零
    if (exponent == 0 && mantissa == 0) {
        return sign ? -0.0f : 0.0f;
    }
    
    float result;
    if (exponent == 0) {
        // 非正规数：使用更精确的计算
        result = (float)mantissa * (float)pow(2.0, -24.0);
    } else {
        // 正规数
        result = (1.0f + (float)mantissa * (float)pow(2.0, -10.0)) * 
                 (float)pow(2.0, exponent - 15);
    }
    
    return sign ? -result : result;
}

/**
 * 将float值转换为FP16位模式
 */
uint16_t float_to_fp16(float value) {
    if (isnan(value)) {
        return FP16_QUIET_NAN;
    }
    
    if (isinf(value)) {
        return (value < 0) ? FP16_NEGATIVE_INFINITY : FP16_POSITIVE_INFINITY;
    }
    
    if (value == 0.0f) {
        return (signbit(value) ? 0x8000 : 0x0000);
    }
    
    int sign = signbit(value) ? 1 : 0;
    value = fabsf(value);
    
    // 处理溢出
    if (value > FP16_MAX) {
        return sign ? FP16_NEGATIVE_INFINITY : FP16_POSITIVE_INFINITY;
    }
    
    // 更精确的非正规数处理
    if (value < FP16_MIN_NORMAL) {
        if (value < FP16_MIN_DENORMAL) {
            return sign ? 0x8000 : 0x0000;  // 下溢到零
        }
        // 非正规数：直接计算尾数
        uint16_t mantissa = (uint16_t)(value * 16777216.0f + 0.5f); // 2^24
        return (sign << 15) | mantissa;
    }
    
    // 正规数处理
    int exponent;
    float normalized = frexpf(value, &exponent);
    int fp16_exponent = exponent - 1 + 15;
    
    if (fp16_exponent >= 31) {
        return sign ? FP16_NEGATIVE_INFINITY : FP16_POSITIVE_INFINITY;
    }
    
    uint16_t mantissa = (uint16_t)((normalized * 2.0f - 1.0f) * 1024.0f + 0.5f);
    return (sign << 15) | (fp16_exponent << 10) | mantissa;
}

/**
 * 将FP16值转换为uint32_t（低16位有效，高16位为0）
 */
uint32_t fp16_to_uint32(uint16_t fp16_value) {
    return (uint32_t)fp16_value;
}

/**
 * 从uint32_t中提取FP16值（取低16位）
 */
uint16_t uint32_to_fp16(uint32_t value) {
    return (uint16_t)(value & 0xFFFF);
}


// 判断值是否在非规格化数范围内
bool is_denormal_range(mpfr_t value, uint8_t N) {
    mpfr_t abs_value, min_normal, min_denormal;
    mpfr_inits2(512, abs_value, min_normal, min_denormal, NULL);
    
    mpfr_abs(abs_value, value, MPFR_RNDN);
    
    if (N == 32) {
        // 使用精确的FP32边界值
        mpfr_set_d(min_normal, 1.1754943508222875e-38, MPFR_RNDN);   // 精确的0x00800000
        mpfr_set_d(min_denormal, 1.401298464324817e-45, MPFR_RNDN);  // 精确的0x00000001
    } else {
        // FP16边界值
        mpfr_set_d(min_normal, 6.103515625e-05, MPFR_RNDN);          // 0x0400
        mpfr_set_d(min_denormal, 5.960464477539063e-08, MPFR_RNDN);  // 0x0001
    }
    
    // 检查是否在非规格化范围内
    bool is_above_min_denormal = (mpfr_cmp(abs_value, min_denormal) >= 0);
    bool is_below_min_normal = (mpfr_cmp(abs_value, min_normal) < 0);
    
    bool result = is_above_min_denormal && is_below_min_normal;
    
    mpfr_clears(abs_value, min_normal, min_denormal, NULL);
    return result;
}

// 手动处理非规格化数舍入
uint32_t handle_denormal_rounding(mpfr_t exact_value, uint8_t N, FPRounding rounding, FPCR_Type fpcr) {
    // 检查刷新到零模式
    if ((fpcr.FZ == 1 && N == 32) || (fpcr.FZ16 == 1 && N == 16)) {
        int sign = mpfr_sgn(exact_value) < 0 ? 1 : 0;
        return FPZero(sign, N);
    }
    
    int sign = mpfr_sgn(exact_value) < 0 ? 1 : 0;
    mpfr_t abs_value;
    mpfr_init2(abs_value, 256); // 使用更高精度
    mpfr_abs(abs_value, exact_value, MPFR_RNDN);
    
    uint32_t result = 0;
    
    if (N == 32) {
        // 使用MPFR精确计算FP32非规格化数
        const double min_denormal_fp32 = 1.401298464324817e-45;  // 0x00000001
        const uint32_t max_denormal_mantissa_fp32 = 0x007FFFFF;
        
        // 使用MPFR精确计算缩放值
        mpfr_t scaled, int_part, frac_part, half_ulp;
        mpfr_inits2(256, scaled, int_part, frac_part, half_ulp, NULL);
        
        // scaled = abs_value / min_denormal_fp32
        mpfr_set_d(scaled, min_denormal_fp32, MPFR_RNDN);
        mpfr_div(scaled, abs_value, scaled, MPFR_RNDN);
        
        // 获取整数部分和小数部分
        mpfr_floor(int_part, scaled);
        mpfr_sub(frac_part, scaled, int_part, MPFR_RNDN);
        
        // 计算半个ULP
        mpfr_set_d(half_ulp, 0.5, MPFR_RNDN);
        
        // 转换为整数
        long long mantissa = mpfr_get_si(int_part, MPFR_RNDN);
        
        bool round_up = false;
        switch (rounding) {
            case FPRounding_POSINF:
                // 正数且有余数时向上舍入
                round_up = (mpfr_cmp_d(frac_part, 0.0) > 0) && (sign == 0);
                break;
            case FPRounding_NEGINF:
                // 负数且有余数时向上舍入
                round_up = (mpfr_cmp_d(frac_part, 0.0) > 0) && (sign == 1);
                break;
            case FPRounding_TIEEVEN:
                if (mpfr_cmp_d(frac_part, 0.5) > 0) {
                    round_up = true;
                } else if (mpfr_cmp_d(frac_part, 0.5) == 0) {
                    // 检查是否为偶数
                    round_up = (mantissa & 1);
                }
                break;
            case FPRounding_ZERO:
                // 向零舍入，不调整
                break;
            default:
                break;
        }
        
        if (round_up) {
            mantissa++;
            // 检查进位到规格化数
            if (mantissa > max_denormal_mantissa_fp32) {
                result = (sign << 31) | 0x00800000; // 最小规格化数
            } else {
                result = (sign << 31) | mantissa;
            }
        } else {
            result = (sign << 31) | mantissa;
        }
        
        mpfr_clears(scaled, int_part, frac_part, half_ulp, NULL);
        
    } else if (N == 16) {
        // FP16部分保持不变（已经工作正常）
        const float min_denormal_fp16 = 5.96046448e-08f;  // 0x0001
        const uint16_t max_denormal_mantissa_fp16 = 0x03FF;
        
        // 使用MPFR精确计算
        mpfr_t scaled, int_part, frac_part, half_ulp;
        mpfr_inits2(256, scaled, int_part, frac_part, half_ulp, NULL);
        
        // scaled = abs_value / min_denormal_fp16
        mpfr_set_d(scaled, min_denormal_fp16, MPFR_RNDN);
        mpfr_div(scaled, abs_value, scaled, MPFR_RNDN);
        
        // 获取整数部分和小数部分
        mpfr_floor(int_part, scaled);
        mpfr_sub(frac_part, scaled, int_part, MPFR_RNDN);
        
        // 计算半个ULP
        mpfr_set_d(half_ulp, 0.5, MPFR_RNDN);
        
        // 转换为整数
        long long mantissa = mpfr_get_si(int_part, MPFR_RNDN);
        
        bool round_up = false;
        switch (rounding) {
            case FPRounding_POSINF:
                round_up = (mpfr_cmp_d(frac_part, 0.0) > 0) && (sign == 0);
                break;
            case FPRounding_NEGINF:
                round_up = (mpfr_cmp_d(frac_part, 0.0) > 0) && (sign == 1);
                break;
            case FPRounding_TIEEVEN:
                if (mpfr_cmp_d(frac_part, 0.5) > 0) {
                    round_up = true;
                } else if (mpfr_cmp_d(frac_part, 0.5) == 0) {
                    round_up = (mantissa & 1);
                }
                break;
            case FPRounding_ZERO:
                break;
            default:
                break;
        }
        
        if (round_up) {
            mantissa++;
            if (mantissa > max_denormal_mantissa_fp16) {
                result = (sign << 15) | 0x0400; // 最小规格化数
            } else {
                result = (sign << 15) | mantissa;
            }
        } else {
            result = (sign << 15) | mantissa;
        }
        
        mpfr_clears(scaled, int_part, frac_part, half_ulp, NULL);
    }
    
    mpfr_clear(abs_value);
    return result;
}
