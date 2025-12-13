#include "C_ref_bfmop.h"
//返回值为uint32_t 输入值addend为uint32_t; 四个输入值op为uint32_t,低16位有效(有效位宽应只有16位)
uint32_t BFDotAdd(uint32_t addend, uint32_t op1_a, uint32_t op1_b, uint32_t op2_a, uint32_t op2_b, 
                     uint32_t fpcr_in, uint8_t add_sub) {
    uint8_t N = 32;
    assert(N == 32);
    FPCR_Type fpcr = assign_FPCR(fpcr_in);//运行一次，将uin32_t的fpcr转为FPCR_Type类型
    
    uint32_t prod;
    uint32_t result;

    if(fpcr.EBF == 0){  // 标准的 BFloat16 行为(!IsFeatureImplemented(FEAT_EBF16) = 0)
        prod = FPAdd_BF16(BFMulH(op1_a, op2_a, fpcr, N/2), BFMulH(op1_b, op2_b, fpcr, N/2), fpcr, N, 1);
        result = FPAdd_BF16(addend, prod, fpcr, N, add_sub);
    }
    else{
        bool isbfloat16 = true;
        bool fpexc = false;
        fpcr.DN = 1; 
        prod = FPDot(op1_a, op1_b, op2_a, op2_b, fpcr, isbfloat16, fpexc, N);
        // printf("A1B1+A2B2 = %08X\n", prod);
        result = FPAdd(addend, prod, fpcr, fpexc, N, add_sub);
    }
    return result;
}

//N应为16
uint32_t BFMulH(uint32_t op1, uint32_t op2, FPCR_Type fpcr, uint8_t N){
    assert(N == 16);

    uint32_t result;
    FPType  type1, type2;
    uint8_t sign1, sign2;
    float value1, value2;
    bool inf1, inf2, zero1, zero2;
    BFUnpack(op1, &type1, &sign1, &value1, N);
    BFUnpack(op2, &type2, &sign2, &value2, N);
    if(type1 == FPType_QNaN || type2 == FPType_QNaN){
        result = FPDefaultNaN(fpcr, 2*N);
    }
    else{
        inf1 = (type1 == FPType_Infinity);
        inf2 = (type2 == FPType_Infinity);
        zero1 = (type1 == FPType_Zero);
        zero2 = (type2 == FPType_Zero);
        if ((inf1 && zero2) || (zero1 && inf2) )
            result = FPDefaultNaN(fpcr, 2*N);
        else if(inf1 || inf2)
            result = FPInfinity((sign1||sign2), 2*N);
        else if(zero1 || zero2)
            result = FPZero((sign1 || sign2), 2*N);
        else
            result = BFRound(value1, value2, 2*N);
    }

    return result;
}

//N应为16
void BFUnpack(uint32_t fpval, FPType* fptype, uint8_t *sign, float* value, uint8_t N) {
    assert(N == 16 || N == 32);

    uint8_t sign_bit;
    uint8_t exp_bits;
    uint32_t frac_bits;

    // 根据N提取符号位、指数位和分数位[1,2](@ref)
    if (N == 16) {
        sign_bit = (fpval >> 15) & 0x1;
        exp_bits = (fpval >> 7) & 0xFF;
        frac_bits = (fpval & 0x7F) << 16; // 将7位分数左移16位，低16位补0[1](@ref)
    } else { // N == 32
        sign_bit = (fpval >> 31) & 0x1;
        exp_bits = (fpval >> 23) & 0xFF;
        frac_bits = fpval & 0x7FFFFF;
    }

    // 判断浮点数类型并计算值[1,2](@ref)
    if (exp_bits == 0) {
        *fptype = FPType_Zero;
        *value = 0.0;
    } else if (exp_bits == 0xFF) {
        if (frac_bits == 0) {
            *fptype = FPType_Infinity;
            *value = pow(2.0, 1000000); // 表示无穷大
        } else {
            *fptype = FPType_QNaN;
            *value = 0.0; // QNaN的值设为0.0
        }
    } else {
        *fptype = FPType_Nonzero;
        int exp_int = (int)exp_bits - 127; // 计算指数[1](@ref)
        double frac_double = 1.0 + ((double)frac_bits) * pow(2.0, -23); // 计算尾数部分[1](@ref)
        *value = pow(2.0, exp_int) * frac_double;
    }

    // 处理符号位[1](@ref)
    if (sign_bit == 1) {
        *value = -(*value);
    }
    *sign = sign_bit;
}
//N=32
uint32_t BFRound(float value1, float value2, uint8_t N){
    //先计算出精确的A*B
    mpfr_t mpfr_A, mpfr_B, mpfr_op;
    mpfr_prec_t prec = 512;
    mpfr_inits2(prec, mpfr_A, mpfr_B, mpfr_op, NULL);

    // 清除之前的异常标志
    mpfr_clear_flags();

    // 将float值转换为MPFR高精度表示
    mpfr_set_flt(mpfr_A, value1, MPFR_RNDN);
    mpfr_set_flt(mpfr_B, value2, MPFR_RNDN);

    // 精确计算 A * B = mpfr_op
    mpfr_mul(mpfr_op, mpfr_A, mpfr_B, MPFR_RNDN);

    //这里进入伪代码的 BFRound() 函数
    assert(N == 32);

    uint32_t result;

    const int minimum_exp = -126;
    const int E = 8;
    const int F = 23;

    bool sign;
    int exponent = 0; // 指数
    mpfr_t mantissa; // 尾数 (使用 MPFR 类型,确保精度)
    mpfr_init2(mantissa, prec);

    if (mpfr_sgn(mpfr_op) < 0) {
        sign = 1;
        mpfr_abs(mantissa, mpfr_op, MPFR_RNDN); //取op绝对值赋值给mantissa
    } else {
        sign = 0;
        mpfr_set(mantissa, mpfr_op, MPFR_RNDN); //op赋值给mantissa
    }

    //NormalizeReal实现
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

    // 固定 Flush-to-zero.
    if (exponent < minimum_exp) 
        return FPZero(sign, N);

    int biased_exp;
    if((exponent - minimum_exp + 1) > 0)
        biased_exp = exponent - minimum_exp + 1;
    else 
        biased_exp = 0;
    
    if(biased_exp == 0){
        int exp_diff = minimum_exp - exponent;
        if (exp_diff > 0) 
            // 除以2的正数次幂
            mpfr_div_2exp(mantissa, mantissa, (unsigned long)exp_diff, MPFR_RNDN);
        else if (exp_diff < 0) 
            // 除以2的负数次幂等价于乘以2的正数次幂
            mpfr_mul_2exp(mantissa, mantissa, (unsigned long)(-exp_diff), MPFR_RNDN);
    }

    mpfr_t mantissa_scaled,error;
    mpz_t int_mant;
    mpfr_inits2(prec, mantissa_scaled, error, NULL);
    mpz_init(int_mant);

    // mantissa_scaled = mantissa * 2^F
    mpfr_mul_2exp(mantissa_scaled, mantissa, F, MPFR_RNDN);
    //int_mant = RoundDown(mantissa * 2.0^F);
    mpfr_get_z(int_mant, mantissa_scaled, MPFR_RNDD);  // 向下取整
    //error = mantissa * 2.0^F - Real(int_mant);
    mpfr_t int_mant_real;
    mpfr_init2(int_mant_real, prec);
    mpfr_set_z(int_mant_real, int_mant, MPFR_RNDN);
    mpfr_sub(error, mantissa_scaled, int_mant_real, MPFR_RNDN);
    mpfr_clear(int_mant_real);

    if ((mpfr_cmp_ui(error, 0) != 0)&&(mpz_tstbit(int_mant, 0) == 0)) 
        mpz_add_ui(int_mant, int_mant, 1);
    
    if(biased_exp >= ((1 << E) - 1))
        result = FPInfinity(sign, N);
    else {
        // 提取int_mant的低F位
        mpz_t mant_low_bits;
        mpz_init(mant_low_bits);
        // 创建掩码提取低F位
        mpz_t mask;
        mpz_init(mask);
        mpz_ui_pow_ui(mask, 2, F);    // 2^F
        mpz_sub_ui(mask, mask, 1);     // 2^F - 1，即F个1
        // 应用掩码提取低F位
        mpz_and(mant_low_bits, int_mant, mask);
        uint32_t mantissa_bits = mpz_get_ui(mant_low_bits);
        // FP32: 符号(1) + 指数(8) + 尾数(23)
        result = (sign ? 0x80000000 : 0) |          // 符号位
                 ((biased_exp & 0xFF) << 23) |      // 指数位
                 (mantissa_bits & 0x7FFFFF);        // 尾数位
        mpz_clears(mant_low_bits, mask, NULL);
    }
    // 清理所有变量
    mpfr_clears(mantissa_scaled, error, NULL);
    mpz_clear(int_mant);
    mpfr_clears(mpfr_A, mpfr_B, mpfr_op, mantissa, NULL);

    return result;
}

//N应为32
uint32_t FPAdd_BF16(uint32_t op1, uint32_t op2, FPCR_Type fpcr, uint8_t N, uint8_t add_sub){
    assert(N == 32);

    uint32_t result;
    FPType  type1, type2;
    uint8_t sign1, sign2;
    float value1, value2;
    bool inf1, inf2, zero1, zero2;
    BFUnpack(op1, &type1, &sign1, &value1, N);
    BFUnpack(op2, &type2, &sign2, &value2, N);
    if(type1 == FPType_QNaN || type2 == FPType_QNaN){
        result = FPDefaultNaN(fpcr, N);
    }
    else{
        inf1 = (type1 == FPType_Infinity);
        inf2 = (type2 == FPType_Infinity);
        zero1 = (type1 == FPType_Zero);
        zero2 = (type2 == FPType_Zero);
        if (inf1 && inf2 && (sign1 == !sign2)) 
            result = FPDefaultNaN(fpcr, N);
        else if((inf1 && sign1 == 0) || (inf2 && sign2 == 0))
            result = FPInfinity('0', N);
        else if((inf1 && sign1 == 1) || (inf2 && sign2 == 1))
            result = FPInfinity('1', N);
        else if(zero1 && zero2 && sign1 == sign2)
            result = FPZero(sign1, N);
        else 
            result = BFRound_1(value1, value2, N, add_sub);
    }
    return result;
}

//N=32
uint32_t BFRound_1(float value1, float value2, uint8_t N, uint8_t add_sub){
    //先计算出精确的A+B
    mpfr_t mpfr_A, mpfr_B, mpfr_op;
    mpfr_prec_t prec = 512;
    mpfr_inits2(prec, mpfr_A, mpfr_B, mpfr_op, NULL);

    // 清除之前的异常标志
    mpfr_clear_flags();

    // 将float值转换为MPFR高精度表示
    mpfr_set_flt(mpfr_A, value1, MPFR_RNDN);
    mpfr_set_flt(mpfr_B, value2, MPFR_RNDN);

    // 根据add_sub位选择加法或减法
    if (add_sub == 1) 
        mpfr_add(mpfr_op, mpfr_A, mpfr_B, MPFR_RNDN);
    else if(add_sub == 0) 
        mpfr_sub(mpfr_op, mpfr_A, mpfr_B, MPFR_RNDN);
    else
        fprintf(stderr, "错误:add_sub的值无效!期望0或1,但得到%d\n", add_sub);

    uint32_t result;
    if(mpfr_zero_p(mpfr_op))
        return result = FPZero(0, N);

    //这里进入伪代码的 BFRound() 函数
    assert(N == 32);
 
    const int minimum_exp = -126;
    const int E = 8;
    const int F = 23;
 
    bool sign;
    int exponent = 0; // 指数
    mpfr_t mantissa; // 尾数 (使用 MPFR 类型,确保精度)
    mpfr_init2(mantissa, prec);
 
    if (mpfr_sgn(mpfr_op) < 0) {
        sign = 1;
        mpfr_abs(mantissa, mpfr_op, MPFR_RNDN); //取op绝对值赋值给mantissa
    } else {
        sign = 0;
        mpfr_set(mantissa, mpfr_op, MPFR_RNDN); //op赋值给mantissa
    }
 
    //NormalizeReal实现
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
 
    // 固定 Flush-to-zero.
    if (exponent < minimum_exp) 
        return FPZero(sign, N);
 
    int biased_exp;
    if((exponent - minimum_exp + 1) > 0)
        biased_exp = exponent - minimum_exp + 1;
    else 
        biased_exp = 0;
    
    if(biased_exp == 0){
        int exp_diff = minimum_exp - exponent;
        if (exp_diff > 0) 
            // 除以2的正数次幂
            mpfr_div_2exp(mantissa, mantissa, (unsigned long)exp_diff, MPFR_RNDN);
        else if (exp_diff < 0) 
            // 除以2的负数次幂等价于乘以2的正数次幂
            mpfr_mul_2exp(mantissa, mantissa, (unsigned long)(-exp_diff), MPFR_RNDN);
    }
 
    mpfr_t mantissa_scaled,error;
    mpz_t int_mant;
    mpfr_inits2(prec, mantissa_scaled, error, NULL);
    mpz_init(int_mant);
 
    // mantissa_scaled = mantissa * 2^F
    mpfr_mul_2exp(mantissa_scaled, mantissa, F, MPFR_RNDN);
    //int_mant = RoundDown(mantissa * 2.0^F);
    mpfr_get_z(int_mant, mantissa_scaled, MPFR_RNDD);  // 向下取整
    //error = mantissa * 2.0^F - Real(int_mant);
    mpfr_t int_mant_real;
    mpfr_init2(int_mant_real, prec);
    mpfr_set_z(int_mant_real, int_mant, MPFR_RNDN);
    mpfr_sub(error, mantissa_scaled, int_mant_real, MPFR_RNDN);
    mpfr_clear(int_mant_real);
 
    if ((mpfr_cmp_ui(error, 0) != 0)&&(mpz_tstbit(int_mant, 0) == 0)) 
        mpz_add_ui(int_mant, int_mant, 1);
    
    if(biased_exp >= ((1 << E) - 1))
        result = FPInfinity(sign, N);
    else {
        // 提取int_mant的低F位
        mpz_t mant_low_bits;
        mpz_init(mant_low_bits);
        // 创建掩码提取低F位
        mpz_t mask;
        mpz_init(mask);
        mpz_ui_pow_ui(mask, 2, F);    // 2^F
        mpz_sub_ui(mask, mask, 1);     // 2^F - 1，即F个1
        // 应用掩码提取低F位
        mpz_and(mant_low_bits, int_mant, mask);
        uint32_t mantissa_bits = mpz_get_ui(mant_low_bits);
        // FP32: 符号(1) + 指数(8) + 尾数(23)
        result = (sign ? 0x80000000 : 0) |          // 符号位
                 ((biased_exp & 0xFF) << 23) |      // 指数位
                 (mantissa_bits & 0x7FFFFF);        // 尾数位
        mpz_clears(mant_low_bits, mask, NULL);
    }
    // 清理所有变量
    mpfr_clears(mantissa_scaled, error, NULL);
    mpz_clear(int_mant);
    mpfr_clears(mpfr_A, mpfr_B, mpfr_op, mantissa, NULL);
 
    return result;
}
