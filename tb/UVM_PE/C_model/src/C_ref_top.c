#include "C_ref_top.h"

int Compute_func_sel(   
    int       i_Compute_Mode          ,       
    int       i_Compute_Precision     ,  
    int       i_Is_Widening           ,
    int       i_Add_or_Subtract       ,
    int       i_Vector_Group_Num             
){
    //进行C计算模型的选择
    int compute_func;

    if(i_Compute_Mode == Outer_Product){
        switch(i_Compute_Precision){
            case INT32: 
            case INT16:
            case INT8: {
                compute_func = INT_CALC;
                break;
            }

            case FP32:
            case FP16: {
		        if(!i_Is_Widening){
                    compute_func = (i_Add_or_Subtract == Addition_Operation) ? FMOPA : FMOPS;
		        }
		        else {
			        compute_func = (i_Add_or_Subtract == Addition_Operation) ? FMOPA_W : FMOPS_W;
		        }
                break;	 
            }

            case BF16: {
                compute_func =  (i_Add_or_Subtract == Addition_Operation) ? BFMOPA : BFMOPS;
                break;
            }

            case FP8: {
                break;
            }

            default: 
                break;
        }
    }
    else{
        switch(i_Compute_Precision){
            case INT32: 
            case INT16:
            case INT8: {
                compute_func = INT_CALC;
                break;
            }

            case FP32:
            case FP16: {
		        if(i_Is_Widening == Operands_Is_Not_Widening){
                    compute_func = FMLA;
                }
                else{
                    if(i_Vector_Group_Num == Single_Vector_Group){
                        compute_func = FDOT;
                    }
                    else{
                        compute_func = FMLAL;
                    }
                }
                break;	 
            }

            case BF16: {
                break;
            }

            case FP8: {
                break;
            }

            default: 
                break;
        }
    }
    return compute_func;
}

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
){
    int compute_func = 0;

    compute_func = Compute_func_sel(i_Compute_Mode, i_Compute_Precision, i_Is_Widening, i_Add_or_Subtract, i_Vector_Group_Num);

    switch(compute_func){
        case INT_CALC: {
            C_ref_int(
                i_Operand_A, 
                i_Operand_B,
                i_Operand_C,      // 128位加数
                i_ZmIsSigned,            // Zm符号控制
                i_ZnIsSigned,            // Zn符号控制
                i_Compute_Mode,      // 计算模式
                i_Num_of_Vector_Group,   // 向量组内向量的数量
                i_Compute_Precision, // 计算精度
                i_Add_or_Subtract,              // 运算符
                o_Result          // 128位输出结果
            );

            break;
        }

        case FMOPA:{
            o_Result[0] = FPMulAdd_ZA(i_Operand_C[0], i_Operand_A, i_Operand_B, 32, i_Exception_Handling,1);
            o_Result[1] = o_Result[0];
            o_Result[2] = o_Result[0];
            o_Result[3] = o_Result[0];
        }
        case FMOPS:{
            o_Result[0] = FPMulAdd_ZA(i_Operand_C[0], i_Operand_A, i_Operand_B, 32, i_Exception_Handling,0);
            o_Result[1] = o_Result[0];
            o_Result[2] = o_Result[0];
            o_Result[3] = o_Result[0];
            break;
        }

        default: break;
    }
}
