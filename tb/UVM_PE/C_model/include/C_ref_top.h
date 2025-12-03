//==================PE_C_MODEL_H====================//
//C reference model顶层的头文件 包含不同指令验证模式的宏定义

#ifndef PE_C_MODEL_H
#define PE_C_MODEL_H

#include "C_ref_fmop.h"
#include "C_ref_int.h"
#include "param.h"

int Compute_func_sel(   
    int       i_Compute_Mode          ,       
    int       i_Compute_Precision     ,  
    int       i_Is_Widening           ,
    int       i_Add_or_Subtract       ,
    int       i_Vector_Group_Num      
);

void PE_C_top(
    int       i_Compute_Mode          ,       
    int       i_Compute_Precision     ,  
    int       i_Is_Widening           ,
    int       i_Add_or_Subtract       ,
    int       i_ZmIsSigned            ,
    int       i_ZnIsSigned            ,
    int       i_Num_of_Vector_Group   ,
    int       i_Vector_Group_Num      ,
    int       i_Exception_Handling    ,//要拆分成寄存器
    int       i_Active_Element_A      ,//4bit的有效指示
    int       i_Active_Element_B      ,
    int       i_ZA_Base_Address       ,
    uint32_t  i_Operand_A             ,
    uint32_t  i_Operand_B             ,
    uint32_t  i_Operand_C[4]          ,
    uint32_t  o_Result[4]                //o_Result[0] = (sv)o_Result[31:0]
);
#endif