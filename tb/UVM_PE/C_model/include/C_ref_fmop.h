#ifndef FMOPA_NON_WIDENING_H
#define FMOPA_NON_WIDENING_H

#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <mpfr.h>
#include <stdlib.h>

// Other constants and macros
#define FEAT_AFP 1 // Assuming AFP feature is implemented
#define CURRENT_VL 128 // Example value, adjust as needed

// Helper macros for bit manipulation
#define EXTRACT_BITS(value, start, length) (((value) >> (start)) & ((1 << (length)) - 1))
#define SET_BITS(target, start, length, value) \
    (target) = ((target) & ~(((1 << (length)) - 1) << (start))) | (((value) & ((1 << (length)) - 1)) << (start))


// FP16常量定义
#define FP16_MAX 65504.0f
#define FP16_MIN_NORMAL 6.103515625e-5f
#define FP16_MIN_DENORMAL 5.9604644775e-8f

// FP16特殊值定义
#define FP16_POSITIVE_INFINITY 0x7C00
#define FP16_NEGATIVE_INFINITY 0xFC00
#define FP16_QUIET_NAN 0x7E00


// FPCR_Type结构体定义
typedef struct {
    uint32_t AHP :      1;  // Bit 19
    uint32_t DN :       1;  // Bit 18
    uint32_t FZ :       1;  // Bit 17
    uint32_t RMode :    2;  // Bits 16-15
    uint32_t Stride :   2;  // Bits 14-13
    uint32_t FZ16 :     1;  // Bit 12
    uint32_t Len :      2;  // Bits 11-10
    uint32_t IDE :      1;  // Bit 9
    uint32_t EBF :      1;  // Bit 8
    uint32_t IXE :      1;  // Bit 7
    uint32_t UFE :      1;  // Bit 6
    uint32_t OFE :      1;  // Bit 5
    uint32_t DZE :      1;  // Bit 4
    uint32_t IOE :      1;  // Bit 3
    uint32_t NEP :      1;  // Bit 2
    uint32_t AH :       1;  // Bit 1
    uint32_t FIZ :      1;  // Bit 0
} FPCR_Type;

// FPType enumeration
typedef enum {
    FPType_Zero,     // 零值: 指数全0 + 尾数全0
    FPType_Denormal, // 非规格化数: 指数全0 + 尾数非0
    FPType_Nonzero,  // 规格化非零数: 指数非全0/全1
    FPType_Infinity, // 无穷大: 指数全1 + 尾数全0
    FPType_QNaN,     // QNaN: 指数全1 + 尾数非0 + 尾数最高位=1
    FPType_SNaN      // SNaN: 指数全1 + 尾数非0 + 尾数最高位=0
} FPType;

// FPRounding enumeration
typedef enum {
    FPRounding_TIEEVEN, // 向最接近的偶数舍入
    FPRounding_POSINF,  // 向正无穷方向舍入
    FPRounding_NEGINF,  // 向负无穷方向舍入
    FPRounding_ZERO,    // 向零方向舍入
    FPRounding_TIEAWAY, // 向远离零方向舍入
    FPRounding_ODD      // 向奇数舍入
} FPRounding;


// Floating-point exception types
typedef enum {
    FPExc_InvalidOp,   // Invalid Operation
    FPExc_DivideByZero, // Divide by Zero
    FPExc_Overflow,     // Overflow
    FPExc_Underflow,    // Underflow
    FPExc_Inexact,      // Inexact
    FPExc_InputDenorm   // Input Denormal
} FPExc_Type;

// 定义返回类型结构体
typedef struct {
    int F;           // 尾数位数
    int minimum_exp;  // 最小指数
} FPBitsType;

// FP16转换函数声明
float fp16_to_float(uint16_t fp16_bits);
uint16_t float_to_fp16(float value);
uint32_t fp16_to_uint32(uint16_t fp16_value);
uint16_t uint32_to_fp16(uint32_t value);
uint32_t mpfr_to_fp16(mpfr_t result_fp, mpfr_rnd_t rounding_mode);

FPCR_Type assign_FPCR(uint32_t FPCR_IN);
uint32_t FPMulAdd(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N, FPCR_Type fpcr, bool fpexc, uint8_t add_sub);

void FPUnpack(uint32_t fpval, uint8_t N, FPCR_Type fpcr_in, bool fpexc,
    FPType* fptype, uint8_t* sign, float* value);
void FPUnpackBase1(uint32_t fpval, uint8_t N, FPCR_Type fpcr_in, bool fpexc, 
    FPType* type, uint8_t* sign, float* value) ;
void FPUnpackBase(uint32_t fpval, uint8_t N, FPCR_Type fpcr_in, bool fpexc, bool isbfloat16, 
    FPType* type, uint8_t* sign, float* value) ;

// Function prototypes
bool IsZero(uint32_t x, int n);
bool IsOnes(uint32_t x, int n);
uint32_t Replicate(uint32_t x, int m, int n);

uint32_t FPMaxNormal(uint8_t sign, uint8_t N);
uint32_t FPInfinity(uint8_t sign, uint8_t N);
uint32_t FPZero(uint8_t sign, uint8_t N) ;
uint32_t FPDefaultNaN(FPCR_Type fpcr, uint8_t N);
uint32_t FPProcessNaN(FPType fptype, uint32_t op, FPCR_Type fpcr, bool fpexc, uint8_t N);
bool FPProcessNaNs3(FPType type1, FPType type2, FPType type3,
    uint32_t op1, uint32_t op2, uint32_t op3,
    FPCR_Type fpcr, bool fpexc, int N,
    uint32_t* result) ;
FPRounding FPRoundingMode(FPCR_Type fpcr);
uint32_t FMOPA_Normal_Compute(float valueA, float value1, float value2, uint8_t N, 
                             FPCR_Type fpcr_in, FPRounding rounding, bool fpexc);
mpfr_rnd_t roundmode_converter(FPRounding rounding);
uint32_t mpfr_to_uint32(mpfr_t result_fp32);
bool overflow_handling(mpfr_t mpfr_sum, FPCR_Type fpcr, uint8_t N, mpfr_prec_t prec,
                      bool altfp, FPRounding rounding, bool* sign_ptr, 
                      int* biased_exp_ptr, bool* overflow_to_inf_ptr, bool satoflo, int* E_ptr);
uint32_t Zeros(uint8_t N);

uint32_t handle_denormal_rounding(mpfr_t exact_value, uint8_t N, FPRounding rounding, FPCR_Type fpcr);
bool is_denormal_range(mpfr_t value, uint8_t N);


#endif // FP_HELPER_H