debImport "-sv" "-f" "filelist.f"
debLoadSimResult /simulation/SME/simulation/PE.fsdb
wvCreateWindow
wvSetCursor -win $_nWave2 63889.823059
wvSetCursor -win $_nWave2 74253.412896
srcHBSelect "tb_PE" -win $_nTrace1
srcSetScope "tb_PE" -delim "." -win $_nTrace1
srcHBSelect "tb_PE" -win $_nTrace1
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcSetScope "tb_PE.u_PE" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcHBDrag -win $_nTrace1
srcHBDrag -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {u_PE}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/clk" "/tb_PE/u_PE/rst_n" \
           "/tb_PE/u_PE/i_Compute_Mode" \
           "/tb_PE/u_PE/i_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/i_Is_Widening" "/tb_PE/u_PE/i_Add_or_Subtract" \
           "/tb_PE/u_PE/i_ZmIsSigned" "/tb_PE/u_PE/i_ZnIsSigned" \
           "/tb_PE/u_PE/i_Num_of_Vector_Group" \
           "/tb_PE/u_PE/i_Vector_Group_Num\[1:0\]" \
           "/tb_PE/u_PE/i_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/i_ZA_Base_Address\[31:0\]" \
           "/tb_PE/u_PE/i_Active_Element_A\[3:0\]" \
           "/tb_PE/u_PE/i_Active_Element_B\[3:0\]" \
           "/tb_PE/u_PE/i_Operand_A\[31:0\]" "/tb_PE/u_PE/i_Operand_B\[31:0\]" \
           "/tb_PE/u_PE/i_Operand_C\[127:0\]" "/tb_PE/u_PE/o_Result\[127:0\]"
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 268283.805668 -snap {("u_PE" 12)}
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 180275.361481 -snap {("u_PE" 13)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 183587.507230 -snap {("u_PE" 5)}
wvSelectSignal -win $_nWave2 {( "u_PE" 4 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 3 )} 
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 46892.496495 -snap {("u_PE" 3)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
srcHBSelect "tb_PE" -win $_nTrace1
srcSetScope "tb_PE" -delim "." -win $_nTrace1
srcHBSelect "tb_PE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "ADDVA_SINT32" -line 11 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "Test_Case_Select" -line 113 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "Instructions_Select" -line 112 -pos 2 -win $_nTrace1
srcSelect -signal "Test_Case_Select" -line 113 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_send_data_start" -line 111 -pos 2 -win $_nTrace1
srcSelect -win $_nTrace1 -range {111 126 7 1 10 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "Instructions_Select" -line 112 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "Test_Case_Select" -line 113 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSelectSignal -win $_nWave2 {( "u_PE" 18 )} 
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetOptions -win $_nWave2 -leadingZeros on
wvSetCursor -win $_nWave2 360382.453331 -snap {("u_PE" 13)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 387687.620890 726320.889749
wvZoom -win $_nWave2 572178.344414 683527.775180
wvZoom -win $_nWave2 644042.161433 663713.176281
wvSelectSignal -win $_nWave2 {( "u_PE" 15 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 15 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 16 )} 
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 433577.176015 589707.156673
wvZoom -win $_nWave2 532227.969726 551958.128468
wvSelectSignal -win $_nWave2 {( "u_PE" 2 )} 
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 2
wvSelectGroup -win $_nWave2 {u_PE}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {G2}
wvSelectGroup -win $_nWave2 {G2}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 0)}
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcSetScope "tb_PE.u_PE" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Compute_Mode" -line 12 -pos 1 -win $_nTrace1
srcHBDrag -win $_nTrace1
wvRenameGroup -win $_nWave2 {G1} {u_PE}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/clk" "/tb_PE/u_PE/rst_n" \
           "/tb_PE/u_PE/i_Compute_Mode" \
           "/tb_PE/u_PE/i_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/i_Is_Widening" "/tb_PE/u_PE/i_Add_or_Subtract" \
           "/tb_PE/u_PE/i_ZmIsSigned" "/tb_PE/u_PE/i_ZnIsSigned" \
           "/tb_PE/u_PE/i_Num_of_Vector_Group" \
           "/tb_PE/u_PE/i_Vector_Group_Num\[1:0\]" \
           "/tb_PE/u_PE/i_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/i_ZA_Base_Address\[31:0\]" \
           "/tb_PE/u_PE/i_Active_Element_A\[3:0\]" \
           "/tb_PE/u_PE/i_Active_Element_B\[3:0\]" \
           "/tb_PE/u_PE/i_Operand_A\[31:0\]" "/tb_PE/u_PE/i_Operand_B\[31:0\]" \
           "/tb_PE/u_PE/i_Operand_C\[127:0\]" "/tb_PE/u_PE/o_Result\[127:0\]"
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvScrollUp -win $_nWave2 6
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 534008.899593 -snap {("u_PE" 5)}
wvScrollDown -win $_nWave2 1
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "u_PE" 3 )} 
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "u_PE" 3 )} 
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "u_PE" 4 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 5 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 4 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 5 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 6 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 6 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 8 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 7 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 3 )} 
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "u_PE" 4 )} 
wvSetOptions -win $_nWave2 -leadingZeros off
wvSetOptions -win $_nWave2 -leadingZeros on
wvSelectSignal -win $_nWave2 {( "u_PE" 4 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSetCursor -win $_nWave2 245799.226306 -snap {("u_PE" 6)}
wvSelectSignal -win $_nWave2 {( "u_PE" 3 )} 
wvSetCursor -win $_nWave2 337578.336557 -snap {("u_PE" 6)}
wvSelectSignal -win $_nWave2 {( "u_PE" 10 )} 
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "u_PE" 9 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 10 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 11 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 12 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 )} 
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "u_PE" 14 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 14 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 14 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 14 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSelectSignal -win $_nWave2 {( "u_PE" 15 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 16 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 17 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 18 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 14 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 10 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 11 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 12 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 13 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 14 )} 
wvSelectSignal -win $_nWave2 {( "u_PE" 15 )} 
wvScrollDown -win $_nWave2 0
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction.u_Instruction_ADDHA_SINT32" -win $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction.u_Instruction_FMOPA_None_Widening_FP32" -win \
           $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction.u_Instruction_FMOPA_None_Widening_FP16" -win \
           $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction.u_Instruction_FMOPA_None_Widening_FP16" -win \
           $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction.u_Instruction_FMOPA_None_Widening_FP16" -win \
           $_nTrace1
srcSetScope "tb_PE.u_All_Instruction.u_Instruction_FMOPA_None_Widening_FP16" \
           -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction.u_Instruction_FMOPA_None_Widening_FP16" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "Test_Instruction" -line 25 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Active_Element_A" -line 19 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("u_PE" 7)}
wvSetPosition -win $_nWave2 {("u_PE" 9)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_All_Instruction/u_Instruction_FMOPA_None_Widening_FP16/o_Active_Element_A\[3:0\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSetRadix -win $_nWave2 -format Bin
wvSelectSignal -win $_nWave2 {( "u_PE" 13 )} 
wvSelectGroup -win $_nWave2 {G2}
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
srcHBSelect "tb_PE" -win $_nTrace1
srcSetScope "tb_PE" -delim "." -win $_nTrace1
srcHBSelect "tb_PE" -win $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction" -win $_nTrace1
srcSetScope "tb_PE.u_All_Instruction" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_All_Instruction" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Active_Element_A" -line 18 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 16)}
wvSetPosition -win $_nWave2 {("u_PE" 17)}
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvAddSignal -win $_nWave2 "/tb_PE/u_All_Instruction/o_Active_Element_A\[3:0\]"
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSelectSignal -win $_nWave2 {( "G2" 2 )} 
wvSetRadix -win $_nWave2 -format Bin
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Active_Element_A" -line 18 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "Instructions_Select" -line 5 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("u_PE" 13)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvAddSignal -win $_nWave2 "/tb_PE/u_All_Instruction/Instructions_Select\[6:0\]"
wvSetPosition -win $_nWave2 {("G2" 2)}
wvSetPosition -win $_nWave2 {("G2" 3)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvSetRadix -win $_nWave2 -format UDec
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_send_data_start" -line 32 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "Test_Case_Select" -line 34 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "T_Operand_A          \[2\]" -line 142 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "T_Exception_Handling \[3\]" -line 166 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "T_Add_or_Subtract    \[3\]" -line 161 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "T_Compute_Mode       \[4\]" -line 186 -pos 1 -win $_nTrace1
wvSetCursor -win $_nWave2 246326.692456 -snap {("G3" 0)}
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G2" 3 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 2)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoom -win $_nWave2 213623.791103 353402.321083
wvScrollUp -win $_nWave2 1
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 371336.170213 -snap {("u_PE" 12)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSelectSignal -win $_nWave2 {( "G2" 2 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSelectGroup -win $_nWave2 {G2}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("u_PE" 18)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 476829.400387 -snap {("u_PE" 12)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcSetScope "tb_PE.u_PE" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvZoom -win $_nWave2 195162.475822 260568.278530
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
wvScrollUp -win $_nWave2 6
wvScrollDown -win $_nWave2 6
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C1_FPMultiplyComb" -line 254 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("u_PE" 8)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 16)}
wvSetPosition -win $_nWave2 {("u_PE" 17)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/P0_Compute_Mode" \
           "/tb_PE/u_PE/P0_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/P0_Is_Widening" "/tb_PE/u_PE/P0_Add_or_Subtract" \
           "/tb_PE/u_PE/P0_ZmIsSigned" "/tb_PE/u_PE/P0_ZnIsSigned" \
           "/tb_PE/u_PE/P0_Num_of_Vector_Group" \
           "/tb_PE/u_PE/P0_Vector_Group_Num\[1:0\]" \
           "/tb_PE/u_PE/P0_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/P0_ZA_Base_Address\[31:0\]" \
           "/tb_PE/u_PE/P0_Active_Element_A\[3:0\]" \
           "/tb_PE/u_PE/P0_Active_Element_B\[3:0\]" \
           "/tb_PE/u_PE/P0_Operand_A\[31:0\]" \
           "/tb_PE/u_PE/P0_Operand_B\[31:0\]" \
           "/tb_PE/u_PE/P0_Operand_C\[127:0\]" \
           "/tb_PE/u_PE/P0_Precision_Addend\[2:0\]" \
           "/tb_PE/u_PE/P0_Mant\[191:0\]" "/tb_PE/u_PE/P0_Result\[127:0\]" \
           "/tb_PE/u_PE/P0_OutSign\[3:0\]" "/tb_PE/u_PE/P0_OutExpo\[35:0\]" \
           "/tb_PE/u_PE/P0_IsBfloat16" "/tb_PE/u_PE/P0_N"
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G3" 22)}
wvSetPosition -win $_nWave2 {("G3" 22)}
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "u_PE" 18 )} 
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_IntAdditionAarry" -line 350 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 10)}
wvSetPosition -win $_nWave2 {("G3" 9)}
wvSetPosition -win $_nWave2 {("G3" 8)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G3" 19)}
wvSetPosition -win $_nWave2 {("G3" 20)}
wvSetPosition -win $_nWave2 {("G3" 21)}
wvSetPosition -win $_nWave2 {("G3" 22)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/P1_Int_Product\[63:0\]" \
           "/tb_PE/u_PE/Forward_Added\[127:0\]" "/tb_PE/u_PE/P1_ZmIsSigned" \
           "/tb_PE/u_PE/P1_ZnIsSigned" "/tb_PE/u_PE/P1_Compute_Mode" \
           "/tb_PE/u_PE/P1_Num_of_Vector_Group" \
           "/tb_PE/u_PE/P1_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/P1_Add_or_Subtract" \
           "/tb_PE/u_PE/P1_Int_Result\[127:0\]"
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G4" 9)}
wvSetPosition -win $_nWave2 {("G4" 9)}
wvSetCursor -win $_nWave2 214940.245951 -snap {("G4" 3)}
wvSelectSignal -win $_nWave2 {( "G4" 1 )} 
wvSelectSignal -win $_nWave2 {( "G4" 2 )} 
wvSelectSignal -win $_nWave2 {( "G4" 9 )} 
wvSelectGroup -win $_nWave2 {G4}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 22)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_Gen_FuseAdd" -line 386 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 13)}
wvSetPosition -win $_nWave2 {("G3" 17)}
wvSetPosition -win $_nWave2 {("G3" 18)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G3" 22)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/P1_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/P1_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/P1_FuseAdd_SelfAdd"
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G5" 3)}
wvSetPosition -win $_nWave2 {("G5" 3)}
wvSelectGroup -win $_nWave2 {G5}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 22)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C3_FPADDComb" -line 468 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 11)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G3" 20)}
wvSetPosition -win $_nWave2 {("G3" 22)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/P2_Compute_Mode" \
           "/tb_PE/u_PE/P2_Is_Widening" \
           "/tb_PE/u_PE/P2_Vector_Group_Num\[1:0\]" \
           "/tb_PE/u_PE/P2_Precision_Addend\[2:0\]" \
           "/tb_PE/u_PE/P2_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/P2_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/P2_Rounded_result\[31:0\]" \
           "/tb_PE/u_PE/P2_Rounded_result\[127:96\]" \
           "/tb_PE/u_PE/P2_FuseAdd_SelfAdd" "/tb_PE/u_PE/P2_Temp_Sign1" \
           "/tb_PE/u_PE/P2_Temp_Sign2" "/tb_PE/u_PE/P2_Temp_Expo1\[9:0\]" \
           "/tb_PE/u_PE/P2_Temp_Expo2\[9:0\]" \
           "/tb_PE/u_PE/P2_Temp_Mant1\[47:0\]" \
           "/tb_PE/u_PE/P2_Temp_Mant2\[47:0\]" "/tb_PE/u_PE/P2_Temp_Sign" \
           "/tb_PE/u_PE/P2_Temp_Expo\[9:0\]" \
           "/tb_PE/u_PE/P2_Temp_Mant\[72:0\]" "/tb_PE/u_PE/P2_Mant\[48:0\]" \
           "/tb_PE/u_PE/P2_Fault_Result\[31:0\]" "/tb_PE/u_PE/P2_IsBfloat16" \
           "/tb_PE/u_PE/P2_N" "/tb_PE/u_PE/P2_Sum_Expo\[7:0\]" \
           "/tb_PE/u_PE/P2_Sum_Sign"
wvSetPosition -win $_nWave2 {("G4" 0)}
wvSetPosition -win $_nWave2 {("G4" 24)}
wvSetPosition -win $_nWave2 {("G4" 24)}
wvSetCursor -win $_nWave2 13367.917123 -snap {("G4" 17)}
wvScrollDown -win $_nWave2 1
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 199382.205029 -snap {("G4" 18)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 222063.249516 -snap {("G4" 15)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C4_Round_InnerProduct" -line 562 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G4" 15)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/P3_Temp_Mant\[48:0\]" \
           "/tb_PE/u_PE/P3_Temp_Expo\[9:0\]" "/tb_PE/u_PE/P3_Temp_Sign" \
           "/tb_PE/u_PE/P3_Exception_Handling\[19:0\]" "/tb_PE/u_PE/P3_N" \
           "/tb_PE/u_PE/P3_IsBfloat16" "/tb_PE/u_PE/P3_Inner_Result\[31:0\]"
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G5" 7)}
wvSetPosition -win $_nWave2 {("G5" 7)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C4_Gen_OuterSign" -line 575 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G4" 22)}
wvSetPosition -win $_nWave2 {("G5" 2)}
wvSetPosition -win $_nWave2 {("G5" 3)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("u_PE" 0)}
wvSetPosition -win $_nWave2 {("G6" 0)}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/P3_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/P3_Is_Widening" "/tb_PE/u_PE/P3_OuterSign"
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G6" 3)}
wvSetPosition -win $_nWave2 {("G6" 3)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_Pipline_4" -line 605 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 644 -pos 23 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPADDComb" -line 646 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G5" 6)}
wvSetPosition -win $_nWave2 {("G6" 1)}
wvSetPosition -win $_nWave2 {("G6" 2)}
wvSetPosition -win $_nWave2 {("G6" 3)}
wvSetPosition -win $_nWave2 {("G7" 0)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Precision_Addend" -line 650 -pos 1 -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[3\]" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G4" 24)}
wvSetPosition -win $_nWave2 {("G5" 0)}
wvSetPosition -win $_nWave2 {("G5" 6)}
wvSetPosition -win $_nWave2 {("G5" 7)}
wvSetPosition -win $_nWave2 {("G6" 1)}
wvSetPosition -win $_nWave2 {("G7" 0)}
wvRenameGroup -win $_nWave2 {G7} {Add_ZA[0]}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G5" 1)}
wvSetPosition -win $_nWave2 {("G5" 3)}
wvSetPosition -win $_nWave2 {("G5" 4)}
wvSetPosition -win $_nWave2 {("G5" 5)}
wvSetPosition -win $_nWave2 {("G5" 6)}
wvSetPosition -win $_nWave2 {("G5" 7)}
wvSetPosition -win $_nWave2 {("G6" 0)}
wvSetPosition -win $_nWave2 {("G6" 2)}
wvSetPosition -win $_nWave2 {("G6" 3)}
wvSetPosition -win $_nWave2 {("Add_ZA[0]" 0)}
wvRenameGroup -win $_nWave2 {Add_ZA[0]} {Add_ZA[0]#1}
wvSelectGroup -win $_nWave2 {Add_ZA[0]#1}
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\]" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPADDComb" -line 646 -pos 1 -win $_nTrace1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "G6" 1 )} 
wvSelectSignal -win $_nWave2 {( "G6" 3 )} 
wvSelectGroup -win $_nWave2 {Add_ZA[0]#1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Temp_Sign\[i\]" -line 663 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Temp_Mant\[i\]" -line 665 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSelectSignal -win $_nWave2 {( "Add_ZA[0]#1" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("Add_ZA[0]#1" 0)}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPADDComb" -line 646 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Compute_Mode" -line 647 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPADDComb" -line 646 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 644 -pos 34 -win $_nTrace1
wvSelectGroup -win $_nWave2 {Add_ZA[0]#1}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("G6" 3)}
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[1\]" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\]" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G5" 7)}
wvSetPosition -win $_nWave2 {("G6" 1)}
wvSetPosition -win $_nWave2 {("G6" 2)}
wvSetPosition -win $_nWave2 {("G6" 3)}
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("G6" 3)}
wvSetPosition -win $_nWave2 {("G7" 0)}
wvRenameGroup -win $_nWave2 {G7} {u_C5_FPADDComb}
wvAddSignal -win $_nWave2 "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Compute_Mode" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Is_Widening" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Vector_Group_Num\[1:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Precision_Addend\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Value1\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Value2\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_FuseAdd_SelfAdd" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Sign1" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Sign2" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Expo1\[9:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Expo2\[9:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Mant1\[47:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Mant2\[47:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Temp_Sign" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Temp_Expo\[9:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Temp_Mant\[72:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Mant\[48:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Fault_Result\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_IsBfloat16" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_N" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Sum_Expo\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_Sum_Sign"
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 24)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 24)}
wvSetCursor -win $_nWave2 325446.615087 -snap {("u_C5_FPADDComb" 20)}
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 203601.934236 -snap {("u_C5_FPADDComb" 16)}
wvSetCursor -win $_nWave2 231557.640232 -snap {("u_C5_FPADDComb" 14)}
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 15 )} 
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 14
wvScrollDown -win $_nWave2 13
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 24 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 19 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 18 )} 
wvZoom -win $_nWave2 46417.021277 295908.510638
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 17 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 18 )} 
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Temp_Mant" -line 26 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Temp_Mant" -line 26 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Mant" -line 96 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Fault_Result" -line 76 -pos 1 -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -delim "." \
           -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 3
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 8
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 4
wvScrollDown -win $_nWave2 28
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 18 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 19 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 20 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 21 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 22 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 23 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 23 )} 
wvSelectSignal -win $_nWave2 {( "u_C5_FPADDComb" 17 )} 
wvScrollDown -win $_nWave2 0
wvSelectAll -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvSelectGroup -win $_nWave2 {u_PE}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvSelectGroup -win $_nWave2 {G3}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvSelectGroup -win $_nWave2 {G5}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvSelectGroup -win $_nWave2 {G6}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvSetPosition -win $_nWave2 {("u_C5_FPADDComb" 0)}
wvSelectGroup -win $_nWave2 {u_C5_FPADDComb}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G7" 0)}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 0)}
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Compute_Mode" -line 8 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Is_Widening" -line 9 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Is_Widening" -line 9 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Vector_Group_Num" -line 10 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Precision_Addend" -line 11 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Compute_Precision" -line 12 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Exception_Handling" -line 13 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Value1" -line 14 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Value2" -line 15 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G1}
wvSelectGroup -win $_nWave2 {G1}
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSelectSignal -win $_nWave2 {( "G1" 1 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 0)}
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\]" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\]" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Sign\[0\]" -line 656 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPADDComb" -line 646 -pos 1 -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Vector_Group_Num" -line 649 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[30:23\]" -line 659 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Sign\[0\]" -line 656 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[31\]" -line 657 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Exp\[9:0\]" -line 658 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Compute_Precision" -line 651 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Fuse_MultiAdd_Result\[i*32+:32\]" -line 653 -pos 1 -win \
          $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Fuse_MultiAdd_Result\[i*32+:32\]" -line 653 -pos 1 -win \
          $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[i*32+:32\]" -line 654 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Sign\[0\]" -line 656 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[31\]" -line 657 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Exp\[9:0\]" -line 658 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[30:23\]" -line 659 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Mantissa\[47:0\]" -line 660 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[22:0\]" -line 661 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Mantissa\[47:0\]" -line 660 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[30:23\]" -line 659 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Mantissa\[47:0\]" -line 660 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Fuse_MultiAdd_Result\[i*32+:32\]" -line 653 -pos 1 -win \
          $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[22:0\]" -line 661 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Temp_Sign\[i\]" -line 663 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Temp_Mant\[i\]" -line 665 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Mant\[i*49+:49\]" -line 666 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Fault_Result\[i*32+:32\]" -line 667 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Sum_Expo\[i*8+:8\]" -line 670 -pos 1 -partailSelPos 12 -win \
          $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_IsBfloat16\[i*1+:1\]" -line 668 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Fault_Result\[i*32+:32\]" -line 667 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Exp\[9:0\]" -line 658 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Sign\[0\]" -line 656 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Sign\[0\]" -line 656 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Operand_C\[31\]" -line 657 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Exp\[9:0\]" -line 658 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Exp\[9:0\]" -line 658 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "P4_Normal_Exp\[9:0\]" -line 658 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 658 -pos 2 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G1" 1)}
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Expo2\[9:0\]"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvMoveSelected -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 3)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Temp_Mant1" -line 660 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Temp_Mant1" -line 660 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 660 -pos 2 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G1" 2)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 3)}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Mant2\[47:0\]"
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Temp_Mant1" -line 660 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G1" 3)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G1" 4)}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Temp_Mant1\[47:0\]"
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSetPosition -win $_nWave2 {("G1" 5)}
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Temp_Expo2" -line 21 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Temp_Mant2" -line 23 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Temp_Mant1" -line 91 -pos 2 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPAddition" -line 79 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_C5_FPAddition" -line 79 -pos 1 -win $_nTrace1
srcAction -pos 78 2 2 -win $_nTrace1 -name "u_C5_FPAddition" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "i_Mant2" -line 13 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -word -line 6 -pos 2 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G1" 4)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 0)}
wvAddSubGroup -win $_nWave2 -holdpost {u_C5_FPAddition}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Sign1" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Expo1\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Mant1\[23:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Sign2" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Expo2\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Mant2\[23:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_FuseAdd_SelfAdd" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Temp_Sign1" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Temp_Sign2" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Temp_Expo1\[9:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Temp_Expo2\[9:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Temp_Mant1\[47:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/i_Temp_Mant2\[47:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/o_Temp_Sign" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/o_Temp_Expo\[9:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/o_Temp_Mant\[72:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/o_Sum_Mant\[48:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/o_Sum_Expo\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/o_Sum_Sign"
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 0)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 19)}
wvSetCursor -win $_nWave2 138196.131528 -snap {("u_C5_FPAddition" 10)}
wvSelectSignal -win $_nWave2 {( "G2/u_C5_FPAddition" 15 )} 
wvSelectSignal -win $_nWave2 {( "G2/u_C5_FPAddition" 16 )} 
wvScrollUp -win $_nWave2 3
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Sum_Mant" -line 26 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_Sum_Mant" -line 106 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "is_Comp" -line 106 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 12)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 19)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 19)}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_C5_FPAddition/is_Comp"
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 19)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 20)}
wvSelectSignal -win $_nWave2 {( "G2/u_C5_FPAddition" 20 )} 
wvSelectSignal -win $_nWave2 {( "G2/u_C5_FPAddition" 19 )} 
wvSelectSignal -win $_nWave2 {( "G2/u_C5_FPAddition" 20 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 19)}
srcDeselectAll -win $_nTrace1
srcSelect -signal "is_Comp" -line 106 -pos 1 -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -delim "." -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "T_Sign1" -line 37 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "u_FPUnpackAll" -line 46 -pos 1 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 16)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 17)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 18)}
wvSetPosition -win $_nWave2 {("G2/u_C5_FPAddition" 19)}
wvSetPosition -win $_nWave2 {("G3" 0)}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Precision_Addend\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Value1\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/i_Value2\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Type1\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Sign1" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Expo1\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Mant1\[23:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Type2\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Sign2" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Expo2\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/T_Mant2\[23:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_IsBfloat16" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/o_N"
wvSetPosition -win $_nWave2 {("G3" 0)}
wvSetPosition -win $_nWave2 {("G3" 15)}
wvSetPosition -win $_nWave2 {("G3" 15)}
wvSetCursor -win $_nWave2 244744.294004 -snap {("G3" 7)}
wvSetCursor -win $_nWave2 23735.976789 -snap {("G3" 7)}
wvSelectSignal -win $_nWave2 {( "G3" 6 )} 
wvSelectSignal -win $_nWave2 {( "G3" 7 )} 
wvSelectSignal -win $_nWave2 {( "G3" 8 )} 
wvSelectSignal -win $_nWave2 {( "G3" 9 )} 
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -delim "." \
           -win $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_C5_FPAddition" -win \
           $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_FPUnpackAll" -win $_nTrace1
srcSetScope "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_FPUnpackAll" -delim "." -win \
           $_nTrace1
srcHBSelect "tb_PE.u_PE.Add_ZA\[0\].u_C5_FPADDComb.u_FPUnpackAll" -win $_nTrace1
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("G3" 11)}
wvSetPosition -win $_nWave2 {("G3" 14)}
wvSetPosition -win $_nWave2 {("G3" 15)}
wvSetPosition -win $_nWave2 {("G4" 0)}
wvRenameGroup -win $_nWave2 {G4} {u_FPUnpackAll}
wvAddSignal -win $_nWave2 \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/i_Compute_Precision\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/i_Precision_Addend\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/i_Exception_Handling\[19:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/i_Value1\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/i_Value2\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Type1\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Sign1" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Expo1\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Mant1\[23:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Value1\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Type2\[2:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Sign2" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Expo2\[7:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Mant2\[23:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_Value2\[31:0\]" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_IsBfloat16" \
           "/tb_PE/u_PE/Add_ZA\[0\]/u_C5_FPADDComb/u_FPUnpackAll/o_N"
wvSetPosition -win $_nWave2 {("u_FPUnpackAll" 0)}
wvSetPosition -win $_nWave2 {("u_FPUnpackAll" 17)}
wvSetPosition -win $_nWave2 {("u_FPUnpackAll" 17)}
wvScrollUp -win $_nWave2 6
wvScrollDown -win $_nWave2 6
wvScrollDown -win $_nWave2 1
wvSelectAll -win $_nWave2
wvScrollUp -win $_nWave2 10
wvScrollDown -win $_nWave2 8
wvScrollDown -win $_nWave2 2
wvSelectSignal -win $_nWave2 {( "u_FPUnpackAll" 16 )} 
wvScrollUp -win $_nWave2 9
wvScrollDown -win $_nWave2 3
wvScrollUp -win $_nWave2 1
srcDeselectAll -win $_nTrace1
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvScrollUp -win $_nWave2 1
wvSetCursor -win $_nWave2 762188.588008 -snap {("G3" 6)}
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSaveSignal -win $_nWave2 "/simulation/SME/simulation/signal.rc"
debExit
