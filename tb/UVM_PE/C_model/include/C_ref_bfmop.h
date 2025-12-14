#ifndef BFMOPA_WIDENING_H
#define BFMOPA_WIDENING_H

#include "C_ref_fmop.h"
#include "C_ref_fmop_w.h"

uint32_t BFDotAdd(uint32_t addend, uint32_t op1_a, uint32_t op1_b, uint32_t op2_a, uint32_t op2_b, 
                uint32_t fpcr_in, uint8_t add_sub);
uint32_t BFMulH(uint32_t op1, uint32_t op2, FPCR_Type fpcr, uint8_t N);

void BFUnpack(uint32_t fpval, FPType* fptype, uint8_t *sign, float* value, uint8_t N);
uint32_t BFRound(float value1, float value2, uint8_t N);
uint32_t FPAdd_BF16(uint32_t op1, uint32_t op2, FPCR_Type fpcr, uint8_t N);
uint32_t BFRound_1(float value1, float value2, uint8_t N);

#endif