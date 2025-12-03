#ifndef FMLAL_H
#define FMLAL_H

#include "C_ref_fmop.h"
#include "C_ref_fmop_w.h"


bool FPProcessNaNs3H(FPType type1, FPType type2, FPType type3,
                    uint32_t op1, uint32_t op2, uint32_t op3,
                    FPCR_Type fpcr, bool fpexc, uint8_t N,
                    uint32_t* result);
uint32_t FPMulAddH(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N,
                           FPCR_Type fpcr, bool fpexc);
uint32_t FPMulAddH_ZA(uint32_t addend, uint32_t op1, uint32_t op2, uint8_t N, uint32_t fpcr_in);

#endif