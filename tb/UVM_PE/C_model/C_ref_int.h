#ifndef C_REF_INT_H
#define C_REF_INT_H

#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "param.h"

uint64_t segmented_multiply(uint32_t i_operand1, uint32_t i_operand2,
                            int i_Calculation_precision,
                            int i_ZmIsSigned, int i_ZnIsSigned);
int32_t direct_add_32(int32_t a, int32_t b);
int32_t direct_add_33_32(int64_t product33, int32_t addend);
int32_t direct_sub_32(int32_t a, int32_t b);

void IntAdditionArray(
    uint64_t i_Product,          // 64位输入乘积
    int32_t *i_Addend,         // 128位加数
    int i_ZmIsSigned,            // Zm符号控制
    int i_ZnIsSigned,            // Zn符号控制
    int i_Calculation_mode,      // 计算模式
    int i_Num_of_Vector_Group,   // 向量组内向量的数量
    int i_Calculation_pricision, // 计算精度
    int i_Operator,              // 运算符
    int32_t *o_Output          // 128位输出结果
);

void C_ref_int(
    uint32_t i_Operand_A, 
    uint32_t i_Operand_B,
    int32_t *i_Operand_C,      // 128位加数
    int i_ZmIsSigned,            // Zm符号控制
    int i_ZnIsSigned,            // Zn符号控制
    int i_Calculation_mode,      // 计算模式
    int i_Num_of_Vector_Group,   // 向量组内向量的数量
    int i_Calculation_precision, // 计算精度
    int i_Operator,              // 运算符
    int32_t *o_Output          // 128位输出结果
);
#endif