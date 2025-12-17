#include "C_ref_int.h"
uint64_t segmented_multiply(uint32_t i_operand1, uint32_t i_operand2,
                            int i_Calculation_precision,
                            int i_ZmIsSigned, int i_ZnIsSigned)
{
    // 验证输入精度
    if (i_Calculation_precision != 2 && i_Calculation_precision != 4)
    {
        return 0; // 无效输入
    }

    const int segment_bits = i_Calculation_precision == 2 ? 16 : 8;
    const int num_segments = i_Calculation_precision;
    uint64_t result = 0;

    for (int seg_idx = 0; seg_idx < num_segments; seg_idx++)
    {
        // 提取第一个操作数的当前分段
        uint32_t seg_val1 = (i_operand1 >> (seg_idx * segment_bits)) &
                            ((1UL << segment_bits) - 1);

        // 提取第二个操作数的当前分段
        uint32_t seg_val2 = (i_operand2 >> (seg_idx * segment_bits)) &
                            ((1UL << segment_bits) - 1);

        // 计算乘积
        int64_t segment_product; // 使用有符号类型以确保正确处理负数

        // 8位分段处理
        if (segment_bits == 8)
        {
            if (i_ZmIsSigned)
            {
                if (i_ZnIsSigned)
                {
                    segment_product = (int8_t)seg_val1 * (int8_t)seg_val2;
                }
                else
                {
                    segment_product = (int8_t)seg_val1 * (uint8_t)seg_val2;
                }
            }
            else
            {
                if (i_ZnIsSigned)
                {
                    segment_product = (uint8_t)seg_val1 * (int8_t)seg_val2;
                }
                else
                {
                    segment_product = (uint8_t)seg_val1 * (uint8_t)seg_val2;
                }
            }
        }
        // 16位分段处理
        else
        {
            if (i_ZmIsSigned)
            {
                if (i_ZnIsSigned)
                {
                    segment_product = (int16_t)seg_val1 * (int16_t)seg_val2;
                }
                else
                {
                    segment_product = (int16_t)seg_val1 * (uint16_t)seg_val2;
                }
            }
            else
            {
                if (i_ZnIsSigned)
                {
                    segment_product = (uint16_t)seg_val1 * (int16_t)seg_val2;
                }
                else
                {
                    segment_product = (uint16_t)seg_val1 * (uint16_t)seg_val2;
                }
            }
        }

        // 计算移位量 (结果位宽为segment_bits * 2)
        const int shift = seg_idx * (segment_bits * 2);

        // 检查移位是否在有效范围内
        if (shift < 64)
        {
            // 扩展乘积为64位后再移位
            uint64_t shifted_product = (uint64_t)(int64_t)segment_product;
            shifted_product &= (1ULL << (segment_bits * 2)) - 1;
            result |= shifted_product << shift;
        }
    }

    return result;
}

// 32位直接加法（截断）
int32_t direct_add_32(int32_t a, int32_t b)
{
    return a + b;
}

// 32位直接减法（截断）
int32_t direct_sub_32(int32_t a, int32_t b)
{
    return a - b;
}

// 33位+32位直接加法（截断）
int32_t direct_add_33_32(int64_t product33, int32_t addend)
{
    return (int32_t)(product33 + (int64_t)addend);
}

// 主功能函数
void IntAdditionArray(
    uint64_t i_Product,          // 64位输入乘积
    int32_t *i_Addend,         // 128位加数
    int i_ZmIsSigned,            // Zm符号控制
    int i_ZnIsSigned,            // Zn符号控制
    int i_Calculation_mode,      // 计算模式
    int i_Vector_Group_Num,   // 向量组内向量的数量
    int i_Calculation_pricision, // 计算精度
    int i_Operator,              // 运算符
    int32_t *o_Output          // 128位输出结果
)
{
    int signflag = i_ZmIsSigned | i_ZnIsSigned;

    // 内积模式
    if (i_Calculation_mode == Inner_Product)
    {
        // INT8精度处理
        if (i_Calculation_pricision == INT8)
        {
            // 拆分4个16位乘积
            uint16_t results[4] = {
                (uint16_t)(i_Product & 0xFFFF),
                (uint16_t)((i_Product >> 16) & 0xFFFF),
                (uint16_t)((i_Product >> 32) & 0xFFFF),
                (uint16_t)((i_Product >> 48) & 0xFFFF)};

            // 根据signflag扩展为32位并直接加法
            for (int i = 0; i < 4; i++)
            {
                // 正确处理有符号16位数到32位的扩展
                int32_t ext_val = signflag ? (int32_t)(int16_t)results[i] : (int32_t)(uint16_t)results[i];
                o_Output[i] = direct_add_32(ext_val, i_Addend[i]);
            }
        }
        // INT16精度处理
        else if (i_Calculation_pricision == INT16)
        {
            // 1. 提取两个32位乘积 (低32位 和 高32位)
            uint32_t prod_low_raw = (uint32_t)(i_Product & 0xFFFFFFFF);
            uint32_t prod_high_raw = (uint32_t)(i_Product >> 32);

            // 2. 统一进行符号扩展处理，转为64位防止计算过程中溢出
            int64_t ext_low = signflag ? (int64_t)(int32_t)prod_low_raw : (int64_t)prod_low_raw;
            int64_t ext_high = signflag ? (int64_t)(int32_t)prod_high_raw : (int64_t)prod_high_raw;

            // 3. 根据向量组模式分支处理
            if (i_Vector_Group_Num == Single_Vector_Group)
            {
                // 逻辑：将乘法两个结果相加，并与 i_Addend[0] 相加
                // 注意：先将两个乘积相加(可能超过32位)，再加上Addend
                int64_t sum_products = ext_low + ext_high;
                int32_t final_result = direct_add_33_32(sum_products, i_Addend[0]);

                // 输出：将结果广播到所有输出通道 (或根据需求仅填充o_Output[0])
                o_Output[0] = o_Output[1] = o_Output[2] = o_Output[3] = final_result;
            }
            else
            { // Double_Vector_Group
                // 逻辑：分别与 i_Addend[0] 和 i_Addend[1] 相加
                // 对应关系：低位乘积 + Addend[0], 高位乘积 + Addend[1]
                int32_t res_low = direct_add_33_32(ext_low, i_Addend[0]);
                int32_t res_high = direct_add_33_32(ext_high, i_Addend[1]);

                // 输出：填充前两个结果，并按原有逻辑复制到后两个位置(128位填充)
                o_Output[0] = res_low;
                o_Output[1] = res_high;
                o_Output[2] = res_low; // 保持数据宽度的重复填充习惯
                o_Output[3] = res_high;
            }
        }
        // INT32精度处理
        else if (i_Calculation_pricision == INT32)
        {
            // 仅使用第一个乘积
            uint32_t product = (uint32_t)(i_Product & 0xFFFFFFFF);
            // 只处理无符号情况
            // 修改：根据signflag决定是否符号扩展
            uint64_t ext_val = signflag ? (uint64_t)(int32_t)product : (uint64_t)(uint32_t)product;

            // 加数选择
            int32_t addend_sel = i_Addend[0];

            // 直接加法并重复四次
            int32_t sum = direct_add_33_32(ext_val, addend_sel);
            o_Output[0] = o_Output[1] = o_Output[2] = o_Output[3] = sum;
        }
    }
    // 外积模式
    else if (i_Calculation_mode == Outer_Product)
    {
        // 拆分并扩展4个INT8乘积
        int32_t ext_results[4];
        for (int i = 0; i < 4; i++)
        {
            uint16_t part = (i_Product >> (i * 16)) & 0xFFFF;
            // 修改：根据signflag正确处理符号扩展
            ext_results[i] = signflag ? (int32_t)(int16_t)part : (int32_t)(uint16_t)part;
        }

        // 计算乘积和（32位截断）
        int32_t sum_temp = 0;
        for (int i = 0; i < 4; i++)
        {
            sum_temp = (int32_t)((int64_t)sum_temp + ext_results[i]);
        }

        // 加法/减法操作
        int32_t result;
        if (i_Operator == Addition_Operation)
        {
            result = direct_add_32(sum_temp, i_Addend[0]);
        }
        else
        {
            result = direct_sub_32(sum_temp, i_Addend[0]);
        }

        // 输出重复四次
        o_Output[0] = o_Output[1] = o_Output[2] = o_Output[3] = result;
    }
}

void C_ref_int(
    uint32_t i_Operand_A, 
    uint32_t i_Operand_B,
    int32_t *i_Operand_C,      // 128位加数
    int i_ZmIsSigned,            // Zm符号控制
    int i_ZnIsSigned,            // Zn符号控制
    int i_Calculation_mode,      // 计算模式
    int i_Vector_Group_Num,   // 向量组内向量的数量
    int i_Calculation_precision, // 计算精度
    int i_Operator,              // 运算符
    int32_t *o_Output          // 128位输出结果
){
    uint64_t i_Product = segmented_multiply(i_Operand_A, i_Operand_B, 
                            i_Calculation_precision, i_ZmIsSigned, i_ZnIsSigned);

    IntAdditionArray(
        i_Product,          // 64位输入乘积
        i_Operand_C,         // 128位加数
        i_ZmIsSigned,            // Zm符号控制
        i_ZnIsSigned,            // Zn符号控制
        i_Calculation_mode,      // 计算模式
        i_Vector_Group_Num,   // 向量组内向量的数量
        i_Calculation_precision, // 计算精度
        i_Operator,              // 运算符
        o_Output          // 128位输出结果
    );
}
