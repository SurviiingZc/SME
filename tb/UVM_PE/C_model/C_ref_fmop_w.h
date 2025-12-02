#ifndef FMOPA_WIDENING_H
#define FMOPA_WIDENING_H

#include "C_ref_fmop.h"

uint32_t FPDotAdd_ZA(uint32_t addend, uint32_t op1_a, uint32_t op1_b, 
                    uint32_t op2_a, uint32_t op2_b, uint32_t fpcr_in, uint8_t add_sub);
uint32_t FPConvertNaN(uint32_t op, uint8_t N, uint8_t M) ;
bool FPProcessNaNs4(FPType type1, FPType type2, FPType type3, FPType type4,
                   uint32_t op1, uint32_t op2, uint32_t op3, uint32_t op4,
                   FPCR_Type fpcr, bool fpexc, uint8_t N,
                   uint32_t* result);
bool FPProcessNaNs(FPType type1, FPType type2, uint32_t op1, uint32_t op2,
                           FPCR_Type fpcr, bool fpexc, uint8_t N, uint32_t* result);
uint32_t FPDot(uint32_t op1_a, uint32_t op1_b, uint32_t op2_a, uint32_t op2_b,
                       FPCR_Type fpcr_in, bool isbfloat16, bool fpexc, uint8_t N);
uint32_t FPAdd(uint32_t op1, uint32_t op2, FPCR_Type fpcr, bool fpexc, uint8_t N, uint8_t add_sub);


#endif