`timescale 1ns/1ps

/*
    Function    : Calculate A multiplied by B plus C
    Description : 

*/

module PE (
    input            clk                    ,
    input            rst_n                  ,
    input            i_Compute_Mode         ,
    input  [ 2:0]    i_Compute_Precision    ,
    input            i_Is_Widening          ,
    input            i_Add_or_Subtract      ,
    input            i_ZmIsSigned           ,
    input            i_ZnIsSigned           ,
    input            i_Num_of_Vector_Group  ,
    input  [ 1:0]    i_Vector_Group_Num     ,
    input  [19:0]    i_Exception_Handling   ,
    input  [31:0]    i_ZA_Base_Address      ,
    input  [ 3:0]    i_Active_Element_A     ,
    input  [ 3:0]    i_Active_Element_B     ,
    input  [31:0]    i_Operand_A            ,
    input  [31:0]    i_Operand_B            ,
    input  [127:0]   i_Operand_C            ,
    output [127:0]   o_Result               
);

genvar i,j,k;
wire  [63:0]    P0_Int_Product           ;
wire            P0_Compute_Mode          ;
wire  [ 2:0]    P0_Compute_Precision     ;
wire            P0_Is_Widening           ;
wire            P0_Add_or_Subtract       ;
wire            P0_ZmIsSigned            ;
wire            P0_ZnIsSigned            ;
wire            P0_Num_of_Vector_Group   ;
wire  [  1:0]   P0_Vector_Group_Num      ;
wire  [ 19:0]   P0_Exception_Handling    ;
wire  [ 31:0]   P0_ZA_Base_Address       ;
wire  [  3:0]   P0_Active_Element_A      ;
wire  [  3:0]   P0_Active_Element_B      ;
wire  [ 31:0]   P0_Operand_A             ;
wire  [ 31:0]   P0_Operand_B             ;
wire  [127:0]   P0_Operand_C             ;
wire  [  2:0]   P0_Precision_Addend      ;
wire  [191:0]   P0_Mant                  ;
wire  [127:0]   P0_Result                ;
wire  [  3:0]   P0_OutSign               ;
wire  [ 35:0]   P0_OutExpo               ;
wire            P0_IsBfloat16            ;
wire            P0_N                     ;
wire  [ 11:0]   P0_TypeA                 ;
wire  [  3:0]   P0_SignA                 ;
wire  [ 31:0]   P0_ExpoA                 ;
wire  [ 95:0]   P0_MantA                 ;
wire  [  3:0]   P0_Is_Exception          ;

wire  [63:0]    P1_Int_Product           ;
wire            P1_Compute_Mode          ;
wire  [ 2:0]    P1_Compute_Precision     ;
wire            P1_Is_Widening           ;
wire            P1_Add_or_Subtract       ;
wire            P1_ZmIsSigned            ;
wire            P1_ZnIsSigned            ;
wire            P1_Num_of_Vector_Group   ;
wire  [  1:0]   P1_Vector_Group_Num      ;
wire  [ 19:0]   P1_Exception_Handling    ;
wire  [ 31:0]   P1_ZA_Base_Address       ;
wire  [127:0]   P1_Operand_C             ;
wire  [191:0]   P1_Mant                  ;
wire  [127:0]   P1_Result                ;
wire  [  3:0]   P1_OutSign               ;
wire  [ 35:0]   P1_OutExpo               ;
wire            P1_IsBfloat16            ;
wire            P1_N                     ;
wire  [127:0]   P1_Rounded_result        ;
wire  [  2:0]   P1_Precision_Addend      ;
wire            P1_FuseAdd_SelfAdd       ;
wire  [127:0]   P1_Round_result          ;
wire            P1_Normal_sign     [3:0] ;
wire  [  9:0]   P1_Normal_exp      [3:0] ;
wire  [ 47:0]   P1_Normal_mantissa [3:0] ;
wire  [127:0]   P1_Int_Result            ;  
wire  [  3:0]   P1_Normal_Sign           ;
wire  [ 39:0]   P1_Normal_Exp            ;
wire  [191:0]   P1_Normal_Mantissa       ;
wire  [ 11:0]   P1_TypeA                 ;
wire  [  3:0]   P1_SignA                 ;
wire  [ 31:0]   P1_ExpoA                 ;
wire  [ 95:0]   P1_MantA                 ;
wire  [  3:0]   P1_Is_Exception          ;

wire  [  3:0]   P2_Normal_Sign           ;
wire  [ 39:0]   P2_Normal_Exp            ;
wire  [191:0]   P2_Normal_Mantissa       ;
wire             P2_Compute_Mode          ;
wire   [ 2:0]    P2_Compute_Precision     ;
wire             P2_Is_Widening           ;
wire             P2_Add_or_Subtract       ;
wire             P2_ZmIsSigned            ;
wire             P2_ZnIsSigned            ;
wire             P2_Num_of_Vector_Group   ;
wire   [  1:0]   P2_Vector_Group_Num      ;
wire   [ 19:0]   P2_Exception_Handling    ;
wire   [ 31:0]   P2_ZA_Base_Address       ;
wire   [127:0]   P2_Operand_C             ;
wire   [127:0]   P2_Rounded_result        ;
wire   [ 2:0]    P2_Precision_Addend      ;
wire             P2_FuseAdd_SelfAdd       ;
wire             P2_Temp_Sign1            ;
wire             P2_Temp_Sign2            ;
wire  [  9:0]    P2_Temp_Expo1            ;
wire  [  9:0]    P2_Temp_Expo2            ;
wire  [ 47:0]    P2_Temp_Mant1            ;
wire  [ 47:0]    P2_Temp_Mant2            ;
wire             P2_Temp_Sign             ;
wire [  9:0]     P2_Temp_Expo             ;
wire [ 72:0]     P2_Temp_Mant             ;
wire [ 48:0]     P2_Mant                  ;
wire [ 31:0]     P2_Fault_Result          ;
wire             P2_IsBfloat16            ;
wire             P2_N                     ;
wire [  7:0]	 P2_Sum_Expo		      ;
wire      	     P2_Sum_Sign		      ;
wire  [ 11:0]    P2_TypeA                 ;
wire  [  3:0]    P2_SignA                 ;
wire  [ 31:0]    P2_ExpoA                 ;
wire  [ 95:0]    P2_MantA                 ;
wire  [  3:0]    P2_Is_Exception          ;
wire             P2_is_Exception          ;
wire  [127:0]    P2_Refresh_Fault_Result  ;
wire  [  3:0]    P2_Refresh_Is_Exception  ;
wire  [127:0]   P2_Result                ;

wire  [ 31:0]    P3_Inner_Result          ;
wire             P3_Compute_Mode          ;
wire  [ 2:0]     P3_Compute_Precision     ;
wire             P3_Is_Widening           ;
wire             P3_Add_or_Subtract       ;
wire             P3_ZmIsSigned            ;
wire             P3_ZnIsSigned            ;
wire             P3_Num_of_Vector_Group   ;
wire  [  1:0]    P3_Vector_Group_Num      ;
wire  [ 19:0]    P3_Exception_Handling    ;
wire  [ 31:0]    P3_ZA_Base_Address       ;
wire  [127:0]    P3_Operand_C             ;
wire  [127:0]    P3_Rounded_result        ;
wire  [ 2:0]     P3_Precision_Addend      ;
wire             P3_Temp_Sign             ;
wire  [  9:0]    P3_Temp_Expo             ;
wire  [ 72:0]    P3_Temp_Mant             ;
wire  [ 48:0]    P3_Mant                  ;
wire  [ 31:0]    P3_Fault_Result          ;
wire             P3_IsBfloat16            ;
wire             P3_N                     ;
wire  [  7:0]	 P3_Sum_Expo		      ;
wire       	     P3_Sum_Sign		      ;
wire  [  3:0]    P3_Normal_Sign           ;
wire  [ 39:0]    P3_Normal_Exp            ;
wire  [191:0]    P3_Normal_Mantissa       ;
wire             P3_OuterSign             ;
wire  [127:0]    P3_Final_Result          ;
wire  [127:0]    P3_Outer_Product         ;
wire  [127:0]    P3_Round_Result          ;
wire  [ 11:0]    P3_TypeA                 ;
wire  [  3:0]    P3_SignA                 ;
wire  [ 31:0]    P3_ExpoA                 ;
wire  [ 95:0]    P3_MantA                 ;
wire  [127:0]    P3_Result                ;
wire  [  3:0]    P3_Is_Exception          ;

wire             P4_Compute_Mode            ;
wire  [ 2:0]     P4_Compute_Precision       ;
wire             P4_Is_Widening             ;
wire             P4_Add_or_Subtract         ;
wire             P4_ZmIsSigned              ;
wire             P4_ZnIsSigned              ;
wire             P4_Num_of_Vector_Group     ;
wire  [  1:0]    P4_Vector_Group_Num        ;
wire  [ 19:0]    P4_Exception_Handling      ;
wire  [ 31:0]    P4_ZA_Base_Address         ;
wire  [127:0]    P4_Operand_C               ;
wire  [127:0]    P4_Fuse_MultiAdd_Result    ;
wire  [  2:0]    P4_Precision_Addend        ;
wire  [195:0]    P4_Mant                    ;
wire  [127:0]    P4_Fault_Result            ;
wire  [  3:0]    P4_IsBfloat16              ;
wire  [  3:0]    P4_N                       ;
wire  [ 31:0]	 P4_Sum_Expo		        ;
wire  [  3:0]    P4_Sum_Sign		        ;
wire  [  3:0]    P4_Normal_Sign             ;
wire  [ 39:0]    P4_Normal_Exp              ;
wire  [191:0]    P4_Normal_Mantissa         ;
wire             P4_Temp_Sign  [3:0]        ;
wire  [  9:0]    P4_Temp_Expo  [3:0]        ;
wire  [ 72:0]    P4_Temp_Mant  [3:0]        ;
wire             P4_Sticky_Bit [3:0]        ;              
wire             P5_Sticky_Bit [3:0]        ;              
wire  [ 11:0]    P4_TypeA                   ;
wire  [  3:0]    P4_SignA                   ;
wire  [ 31:0]    P4_ExpoA                   ;
wire  [ 95:0]    P4_MantA                   ;
wire  [127:0]    P4_Result                  ;
wire  [  3:0]    P4_Is_Exception            ;
wire  [  3:0]    P4_is_Exception            ;
wire  [127:0]    P4_Refresh_Fault_Result    ;
wire  [  3:0]    P4_Refresh_Is_Exception    ;

wire             P5_Compute_Mode            ;
wire  [ 2:0]     P5_Compute_Precision       ;
wire             P5_Is_Widening             ;
wire             P5_Add_or_Subtract         ;
wire             P5_ZmIsSigned              ;
wire             P5_ZnIsSigned              ;
wire             P5_Num_of_Vector_Group     ;
wire  [  1:0]    P5_Vector_Group_Num        ;
wire  [ 19:0]    P5_Exception_Handling      ;
wire  [ 31:0]    P5_ZA_Base_Address         ;
wire  [127:0]    P5_Operand_C               ;
wire  [127:0]    P5_Fuse_MultiAdd_Result    ;
wire  [  2:0]    P5_Precision_Addend        ;
wire  [195:0]    P5_Mant                    ;
wire  [127:0]    P5_Fault_Result            ;
wire  [  3:0]    P5_IsBfloat16              ;
wire  [  3:0]    P5_N                       ;
wire  [ 39:0]	 P5_Sum_Expo		        ;
wire  [  3:0]    P5_Sum_Sign		        ;
wire  [127:0]    P5_Round_Result            ;
wire             P5_Temp_Sign               ;
wire  [  9:0]    P5_Temp_Expo               ;
wire  [ 72:0]    P5_Temp_Mant               ;
wire  [ 31:0]    P5_FP32_Result             ;
wire  [ 11:0]    P5_TypeA                   ;
wire  [  3:0]    P5_SignA                   ;
wire  [ 31:0]    P5_ExpoA                   ;
wire  [ 95:0]    P5_MantA                   ;
wire  [127:0]    P5_Result                  ;
wire  [  3:0]    P5_Is_Exception            ;
wire  [  3:0]    P5_Refresh_Is_Exception    ;
wire  [127:0]    i_Result                   ;
//=====================================================================
// Description : Pipline Level 0
//=====================================================================
Pipline_0 u_Pipline_0( 
    .clk                    ( clk                    ),
    .rst_n                  ( rst_n                  ),
    .i_Compute_Mode         ( i_Compute_Mode         ),
    .i_Compute_Precision    ( i_Compute_Precision    ),
    .i_Is_Widening          ( i_Is_Widening          ),
    .i_Add_or_Subtract      ( i_Add_or_Subtract      ),
    .i_ZmIsSigned           ( i_ZmIsSigned           ),
    .i_ZnIsSigned           ( i_ZnIsSigned           ),
    .i_Num_of_Vector_Group  ( i_Num_of_Vector_Group  ),
    .i_Vector_Group_Num     ( i_Vector_Group_Num     ),
    .i_Exception_Handling   ( i_Exception_Handling   ),
    .i_ZA_Base_Address      ( i_ZA_Base_Address      ),
    .i_Active_Element_A     ( i_Active_Element_A     ),
    .i_Active_Element_B     ( i_Active_Element_B     ),
    .i_Operand_A            ( i_Operand_A            ),
    .i_Operand_B            ( i_Operand_B            ),
    .i_Operand_C            ( i_Operand_C            ),
    .o_Compute_Mode         ( P0_Compute_Mode        ),
    .o_Compute_Precision    ( P0_Compute_Precision   ),
    .o_Is_Widening          ( P0_Is_Widening         ),
    .o_Add_or_Subtract      ( P0_Add_or_Subtract     ),
    .o_ZmIsSigned           ( P0_ZmIsSigned          ),
    .o_ZnIsSigned           ( P0_ZnIsSigned          ),
    .o_Num_of_Vector_Group  ( P0_Num_of_Vector_Group ),
    .o_Vector_Group_Num     ( P0_Vector_Group_Num    ),
    .o_Exception_Handling   ( P0_Exception_Handling  ),
    .o_ZA_Base_Address      ( P0_ZA_Base_Address     ),
    .o_Active_Element_A     ( P0_Active_Element_A    ),
    .o_Active_Element_B     ( P0_Active_Element_B    ),
    .o_Operand_A            ( P0_Operand_A           ),
    .o_Operand_B            ( P0_Operand_B           ),
    .o_Operand_C            ( P0_Operand_C           )
);

C1_FPMultiplyComb u_C1_FPMultiplyComb(
    .i_Compute_Mode         ( P0_Compute_Mode        ),
    .i_Compute_Precision    ( P0_Compute_Precision   ),
    .i_Is_Widening          ( P0_Is_Widening         ),
    .i_Add_or_Subtract      ( P0_Add_or_Subtract     ),
    .i_ZmIsSigned           ( P0_ZmIsSigned          ),
    .i_ZnIsSigned           ( P0_ZnIsSigned          ),
    .i_Num_of_Vector_Group  ( P0_Num_of_Vector_Group ),
    .i_Vector_Group_Num     ( P0_Vector_Group_Num    ),
    .i_Exception_Handling   ( P0_Exception_Handling  ),
    .i_ZA_Base_Address      ( P0_ZA_Base_Address     ),
    .i_Active_Element_A     ( P0_Active_Element_A    ),
    .i_Active_Element_B     ( P0_Active_Element_B    ),
    .i_Operand_A            ( P0_Operand_A           ),
    .i_Operand_B            ( P0_Operand_B           ),
    .i_Operand_C            ( P0_Operand_C           ),
    .o_Precision_Addend     ( P0_Precision_Addend    ),
    .o_Mant                 ( P0_Mant                ),
    .o_Result               ( P0_Result              ),
    .o_OutSign              ( P0_OutSign             ),
    .o_OutExpo              ( P0_OutExpo             ),
    .o_IsBfloat16           ( P0_IsBfloat16          ),
    .o_N                    ( P0_N                   ),
    .o_TypeA                ( P0_TypeA               ),
    .o_SignA                ( P0_SignA               ),
    .o_ExpoA                ( P0_ExpoA               ),
    .o_Is_Exception         ( P0_Is_Exception        ),
    .o_MantA                ( P0_MantA               )
);

IntMult_TOP u_IntMult_TOP(
    .i_operand1              ( P0_Operand_A              ),
    .i_operand2              ( P0_Operand_B              ),
    .i_ZmIsSigned            ( P0_ZmIsSigned             ),
    .i_ZnIsSigned            ( P0_ZnIsSigned             ),
    .i_Active_Element_A      ( P0_Active_Element_A       ),
    .i_Active_Element_B      ( P0_Active_Element_B       ),
    .i_Calculation_pricision ( P0_Compute_Precision      ),
    .o_Product               ( P0_Int_Product            )
);

//=====================================================================
// Description : Pipline Level 1
//=====================================================================

Pipline_1 u_Pipline_1(
    .clk                    ( clk                    ),
    .rst_n                  ( rst_n                  ),
    .i_Precision_Addend     ( P0_Precision_Addend    ),
    .i_Compute_Mode         ( P0_Compute_Mode        ),
    .i_Compute_Precision    ( P0_Compute_Precision   ),
    .i_Is_Widening          ( P0_Is_Widening         ),
    .i_Add_or_Subtract      ( P0_Add_or_Subtract     ),
    .i_ZmIsSigned           ( P0_ZmIsSigned          ),
    .i_ZnIsSigned           ( P0_ZnIsSigned          ),
    .i_Num_of_Vector_Group  ( P0_Num_of_Vector_Group ),
    .i_Vector_Group_Num     ( P0_Vector_Group_Num    ),
    .i_Exception_Handling   ( P0_Exception_Handling  ),
    .i_ZA_Base_Address      ( P0_ZA_Base_Address     ),
    .i_Operand_C            ( P0_Operand_C           ),
    .i_Mant                 ( P0_Mant                ),
    .i_Result               ( P0_Result              ),
    .i_OutSign              ( P0_OutSign             ),
    .i_OutExpo              ( P0_OutExpo             ),
    .i_IsBfloat16           ( P0_IsBfloat16          ),
    .i_N                    ( P0_N                   ),
    .i_Int_Product          ( P0_Int_Product         ),
    .i_TypeA                ( P0_TypeA               ),
    .i_SignA                ( P0_SignA               ),
    .i_ExpoA                ( P0_ExpoA               ),
    .i_MantA                ( P0_MantA               ),
    .i_Is_Exception         ( P0_Is_Exception        ),
    .o_Compute_Mode         ( P1_Compute_Mode        ),
    .o_Compute_Precision    ( P1_Compute_Precision   ),
    .o_Is_Widening          ( P1_Is_Widening         ),
    .o_Add_or_Subtract      ( P1_Add_or_Subtract     ),
    .o_ZmIsSigned           ( P1_ZmIsSigned          ),
    .o_ZnIsSigned           ( P1_ZnIsSigned          ),
    .o_Num_of_Vector_Group  ( P1_Num_of_Vector_Group ),
    .o_Vector_Group_Num     ( P1_Vector_Group_Num    ),
    .o_Exception_Handling   ( P1_Exception_Handling  ),
    .o_ZA_Base_Address      ( P1_ZA_Base_Address     ),
    .o_Operand_C            ( P1_Operand_C           ),
    .o_Mant                 ( P1_Mant                ),
    .o_Result               ( P1_Result              ),
    .o_OutSign              ( P1_OutSign             ),
    .o_OutExpo              ( P1_OutExpo             ),
    .o_IsBfloat16           ( P1_IsBfloat16          ),
    .o_N                    ( P1_N                   ),
    .o_Int_Product          ( P1_Int_Product         ),
    .o_Precision_Addend     ( P1_Precision_Addend    ),
    .o_TypeA                ( P1_TypeA               ),
    .o_SignA                ( P1_SignA               ),
    .o_ExpoA                ( P1_ExpoA               ),
    .o_MantA                ( P1_MantA               ),
    .o_Is_Exception         ( P1_Is_Exception        )
);
reg  [1:0]    reset_counter              ;
wire is_int_op  = ((P1_Compute_Precision == `INT32) || (P1_Compute_Precision == `INT16) || (P1_Compute_Precision == `INT8)) ? 1'b1 : 1'b0;
wire is_forward = (reset_counter == 3) && (P0_ZA_Base_Address == P1_ZA_Base_Address) ? 1'b1 : 1'b0   ;
wire [127:0] Forward_Added = is_forward ? o_Result : P1_Operand_C                                 ;

wire    [3:0]   C2_sticky_flag;

// to judge whether the int pipeline is full
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reset_counter <= 0;
    end else begin
        if (reset_counter < 3) reset_counter <= reset_counter + 1;
    end
end

IntAdditionAarry u_IntAdditionAarry(
    .i_Product               ( P1_Int_Product               ),
    .i_Addend                ( Forward_Added                ),
    .i_ZmIsSigned            ( P1_ZmIsSigned                ),
    .i_ZnIsSigned            ( P1_ZnIsSigned                ),
    .i_Calculation_mode      ( P1_Compute_Mode              ),
    .i_Num_of_Vector_Group   ( P1_Num_of_Vector_Group       ),
    .i_Calculation_pricision ( P1_Compute_Precision         ),
    .i_Operator              ( P1_Add_or_Subtract           ),
    .o_Output                ( P1_Int_Result                )
);

generate
    for(i = 0 ; i < 4 ; i = i + 1) begin : Comb2
        C2_Round#(
            .IN_WIDTH              ( 48                         ),
            .EXP_WIDTH             ( 9                          )
        )u_C2_Round(
            .i_op                  ( P1_Mant[i*48+:48]          ),
            .i_sign                ( P1_OutSign[i*1+:1]         ),
            .i_exp                 ( P1_OutExpo[i*9+:9]         ),
            .i_Exception_Handling  ( P1_Exception_Handling      ),
            .i_N                   ( P1_N                       ),
            .i_isbfloat16          ( P1_IsBfloat16              ),
            .o_sign                ( P1_Normal_sign[i]          ),
            .o_round_result        ( P1_Round_result[i*32+:32]  ),
            .o_normal_mantissa     ( P1_Normal_mantissa[i]      ),
            .sticky_flag           (C2_sticky_flag[i]           ),
            .o_normal_exp          ( P1_Normal_exp[i]           )
        );

        assign P1_Normal_Sign[i*1+:1]       = P1_Normal_sign[i]     ;
        assign P1_Normal_Exp[i*10+:10]      = P1_Normal_exp[i]      ;
        assign P1_Normal_Mantissa[i*48+:48] = P1_Normal_mantissa[i] ;
    end
endgenerate

C2_Gen_FuseAdd u_Gen_FuseAdd(
    .i_Compute_Precision   ( P1_Compute_Precision   ),
    .i_Exception_Handling  ( P1_Exception_Handling  ),
    .o_FuseAdd_SelfAdd     ( P1_FuseAdd_SelfAdd     )
);

// generate
//     for(i = 0 ; i < 4 ; i = i + 1) begin : Comb2
//         C2_FPRoundBase#(
//             .IN_WIDTH             ( 48 ),
//             .EXP_WIDTH            ( 9 )
//         )u_FPRoundBase(
//             .op                    ( P1_Mant[i*48+:48]              ),
//             .i_exp                 ( P1_OutExpo[i*9+:9]             ),
//             .i_sign                ( P1_OutSign[i*1+:1]             ),
//             .i_Exception_Handling  ( P1_Exception_Handling          ),
//             .i_N                   ( P1_N                           ),
//             .i_isbfloat16          ( P1_IsBfloat16                  ),
//             .Rounded_result        ( P1_Rounded_result[i*32+:32]    )
//         );
//     end
// endgenerate

//=====================================================================
// Description : Pipline Level 2
//=====================================================================



Pipline_2 u_Pipline_2(
    .clk                    ( clk                       ),
    .rst_n                  ( rst_n                     ),
    .i_Compute_Mode         ( P1_Compute_Mode           ),
    .i_Compute_Precision    ( P1_Compute_Precision      ),
    .i_Is_Widening          ( P1_Is_Widening            ),
    .i_Add_or_Subtract      ( P1_Add_or_Subtract        ),
    .i_ZmIsSigned           ( P1_ZmIsSigned             ),
    .i_ZnIsSigned           ( P1_ZnIsSigned             ),
    .i_Num_of_Vector_Group  ( P1_Num_of_Vector_Group    ),
    .i_Vector_Group_Num     ( P1_Vector_Group_Num       ),
    .i_Exception_Handling   ( P1_Exception_Handling     ),
    .i_ZA_Base_Address      ( P1_ZA_Base_Address        ),
    .i_Operand_C            ( P1_Operand_C              ),
    .i_Precision_Addend     ( P1_Precision_Addend       ),
    .i_Rounded_result       ( P1_Round_result           ),
    .i_FuseAdd_SelfAdd      ( P1_FuseAdd_SelfAdd        ),
    .i_Temp_Sign1           ( P1_Normal_sign[0]         ),
    .i_Temp_Sign2           ( P1_Normal_sign[3]         ),
    .i_Temp_Expo1           ( P1_Normal_exp[0]          ),
    .i_Temp_Expo2           ( P1_Normal_exp[3]          ),
    .i_Temp_Mant1           ( P1_Normal_mantissa[0]     ),
    .i_Temp_Mant2           ( P1_Normal_mantissa[3]     ),
    .i_Normal_Sign          ( P1_Normal_Sign            ),
    .i_Normal_Exp           ( P1_Normal_Exp             ),
    .i_Normal_Mantissa      ( P1_Normal_Mantissa        ),
    .i_is_int_op            ( is_int_op                 ),
    .i_TypeA                ( P1_TypeA                  ),
    .i_SignA                ( P1_SignA                  ),
    .i_ExpoA                ( P1_ExpoA                  ),
    .i_MantA                ( P1_MantA                  ),
    .i_Is_Exception         ( P1_Is_Exception           ),
    .i_Result               ( P1_Result                 ),
    .o_Result               ( P2_Result                 ),
    .o_Is_Exception         ( P2_Is_Exception           ),
    .o_Compute_Mode         ( P2_Compute_Mode           ),
    .o_Compute_Precision    ( P2_Compute_Precision      ),
    .o_Is_Widening          ( P2_Is_Widening            ),
    .o_Add_or_Subtract      ( P2_Add_or_Subtract        ),
    .o_ZmIsSigned           ( P2_ZmIsSigned             ),
    .o_ZnIsSigned           ( P2_ZnIsSigned             ),
    .o_Num_of_Vector_Group  ( P2_Num_of_Vector_Group    ),
    .o_Vector_Group_Num     ( P2_Vector_Group_Num       ),
    .o_Exception_Handling   ( P2_Exception_Handling     ),
    .o_ZA_Base_Address      ( P2_ZA_Base_Address        ),
    .o_Operand_C            ( P2_Operand_C              ),
    .o_Precision_Addend     ( P2_Precision_Addend       ),
    .o_Rounded_result       ( P2_Rounded_result         ),
    .o_FuseAdd_SelfAdd      ( P2_FuseAdd_SelfAdd        ),
    .o_Temp_Sign1           ( P2_Temp_Sign1             ),
    .o_Temp_Sign2           ( P2_Temp_Sign2             ),
    .o_Temp_Expo1           ( P2_Temp_Expo1             ),
    .o_Temp_Expo2           ( P2_Temp_Expo2             ),
    .o_Temp_Mant1           ( P2_Temp_Mant1             ),
    .o_Temp_Mant2           ( P2_Temp_Mant2             ),
    .o_Normal_Sign          ( P2_Normal_Sign            ),
    .o_Normal_Exp           ( P2_Normal_Exp             ),
    .o_Normal_Mantissa      ( P2_Normal_Mantissa        ),
    .o_TypeA                ( P2_TypeA                  ),
    .o_SignA                ( P2_SignA                  ),
    .o_ExpoA                ( P2_ExpoA                  ),
    .o_MantA                ( P2_MantA                  )    
);

C3_FPADDComb u_C3_FPADDComb(
    .i_Compute_Mode        ( P2_Compute_Mode            ),
    .i_Is_Widening         ( P2_Is_Widening             ),
    .i_Vector_Group_Num    ( P2_Vector_Group_Num        ),
    .i_Precision_Addend    ( P2_Precision_Addend        ),
    .i_Compute_Precision   ( P2_Compute_Precision       ),
    .i_Exception_Handling  ( P2_Exception_Handling      ),

    .i_Value1              ( P2_Rounded_result[31:0]    ),
    .i_Value2              ( P2_Rounded_result[127:96]  ),
    .i_FuseAdd_SelfAdd     ( P2_FuseAdd_SelfAdd         ),
    .i_Temp_Sign1          ( P2_Temp_Sign1              ),
    .i_Temp_Sign2          ( P2_Temp_Sign2              ),
    .i_Temp_Expo1          ( P2_Temp_Expo1              ),
    .i_Temp_Expo2          ( P2_Temp_Expo2              ),
    .i_Temp_Mant1          ( P2_Temp_Mant1              ),
    .i_Temp_Mant2          ( P2_Temp_Mant2              ),

    .o_Temp_Sign           ( P2_Temp_Sign               ),
    .o_Temp_Expo           ( P2_Temp_Expo               ),
    .o_Temp_Mant           ( P2_Temp_Mant               ),
    .o_Mant                ( P2_Mant                    ),
    .o_Fault_Result        ( P2_Fault_Result            ),
    .o_IsBfloat16          ( P2_IsBfloat16              ),
    .o_N                   ( P2_N                       ),
    .o_Sum_Expo            ( P2_Sum_Expo                ),
    .o_Sum_Sign            ( P2_Sum_Sign                ),
    .o_is_Exception        ( P2_is_Exception            )
);

// assign P2_Refresh_Fault_Result = ({P2_Is_Exception[0],P2_is_Exception} == 2'b01) ? {P2_Result[127:32],P2_Fault_Result} : P2_Result ;
// assign P2_Refresh_Is_Exception = ({P2_Is_Exception[0],P2_is_Exception} == 2'b01) ? {P2_Is_Exception[3:1],P2_is_Exception} : P2_Is_Exception ;

assign P2_Refresh_Fault_Result = P2_Result ;
assign P2_Refresh_Is_Exception = P2_Is_Exception ;

//=====================================================================
// Description : Pipline Level 3
//=====================================================================

Pipline_3 u_Pipline_3(
    .clk                    ( clk                    ),
    .rst_n                  ( rst_n                  ),
    .i_Compute_Mode         ( P2_Compute_Mode        ),
    .i_Compute_Precision    ( P2_Compute_Precision   ),
    .i_Is_Widening          ( P2_Is_Widening         ),
    .i_Add_or_Subtract      ( P2_Add_or_Subtract     ),
    .i_ZmIsSigned           ( P2_ZmIsSigned          ),
    .i_ZnIsSigned           ( P2_ZnIsSigned          ),
    .i_Num_of_Vector_Group  ( P2_Num_of_Vector_Group ),
    .i_Vector_Group_Num     ( P2_Vector_Group_Num    ),
    .i_Exception_Handling   ( P2_Exception_Handling  ),
    .i_ZA_Base_Address      ( P2_ZA_Base_Address     ),
    .i_Operand_C            ( P2_Operand_C           ),
    .i_Precision_Addend     ( P2_Precision_Addend    ),
    .i_Rounded_result       ( P2_Rounded_result      ),
    .i_Temp_Sign            ( P2_Temp_Sign           ),
    .i_Temp_Expo            ( P2_Temp_Expo           ),
    .i_Temp_Mant            ( P2_Temp_Mant           ),
    .i_Mant                 ( P2_Mant                ),
    .i_Fault_Result         ( P2_Fault_Result        ),
    .i_IsBfloat16           ( P2_IsBfloat16          ),
    .i_N                    ( P2_N                   ),
    .i_Sum_Expo             ( P2_Sum_Expo            ),
    .i_Sum_Sign             ( P2_Sum_Sign            ),
    .i_Normal_Sign          ( P2_Normal_Sign         ),
    .i_Normal_Exp           ( P2_Normal_Exp          ),
    .i_Normal_Mantissa      ( P2_Normal_Mantissa     ),
    .i_TypeA                ( P2_TypeA               ),
    .i_SignA                ( P2_SignA               ),
    .i_ExpoA                ( P2_ExpoA               ),
    .i_MantA                ( P2_MantA               ),
    .i_Is_Exception         ( P2_Refresh_Is_Exception   ),
    .i_Result               ( P2_Refresh_Fault_Result   ),
    .o_Result               ( P3_Result                 ),
    .o_Is_Exception         ( P3_Is_Exception           ),
    .o_Compute_Mode         ( P3_Compute_Mode        ),
    .o_Compute_Precision    ( P3_Compute_Precision   ),
    .o_Is_Widening          ( P3_Is_Widening         ),
    .o_Add_or_Subtract      ( P3_Add_or_Subtract     ),
    .o_ZmIsSigned           ( P3_ZmIsSigned          ),
    .o_ZnIsSigned           ( P3_ZnIsSigned          ),
    .o_Num_of_Vector_Group  ( P3_Num_of_Vector_Group ),
    .o_Vector_Group_Num     ( P3_Vector_Group_Num    ),
    .o_Exception_Handling   ( P3_Exception_Handling  ),
    .o_ZA_Base_Address      ( P3_ZA_Base_Address     ),
    .o_Operand_C            ( P3_Operand_C           ),
    .o_Precision_Addend     ( P3_Precision_Addend    ),
    .o_Rounded_result       ( P3_Rounded_result      ),
    .o_Temp_Sign            ( P3_Temp_Sign           ),
    .o_Temp_Expo            ( P3_Temp_Expo           ),
    .o_Temp_Mant            ( P3_Temp_Mant           ),
    .o_Mant                 ( P3_Mant                ),
    .o_Fault_Result         ( P3_Fault_Result        ),
    .o_IsBfloat16           ( P3_IsBfloat16          ),
    .o_N                    ( P3_N                   ),
    .o_Sum_Expo             ( P3_Sum_Expo            ),
    .o_Sum_Sign             ( P3_Sum_Sign            ),
    .o_Normal_Sign          ( P3_Normal_Sign         ),
    .o_Normal_Exp           ( P3_Normal_Exp          ),
    .o_Normal_Mantissa      ( P3_Normal_Mantissa     ),
    .o_TypeA                ( P3_TypeA               ),
    .o_SignA                ( P3_SignA               ),
    .o_ExpoA                ( P3_ExpoA               ),
    .o_MantA                ( P3_MantA               )
);

C4_Round#(
    .IN_WIDTH              ( 49                     ),
    .EXP_WIDTH             ( 10                     )
)u_C4_Round_InnerProduct(
    .i_op                  ( P3_Temp_Mant[48:0]     ),
    .i_exp                 ( P3_Temp_Expo           ),
    .i_sign                ( P3_Temp_Sign           ),
    .i_Exception_Handling  ( P3_Exception_Handling  ),
    .i_N                   ( P3_N                   ),
    .i_isbfloat16          ( P3_IsBfloat16          ),
    .o_rounded_result      ( P3_Inner_Result        ),
    .o_sign                (                        ),
    .o_normal_mantissa     (                        ),
    .o_normal_exp          (                        )
);

C4_Gen_OuterSign u_C4_Gen_OuterSign(
    .i_Compute_Precision  ( P3_Compute_Precision  ),
    .i_Is_Widening        ( P3_Is_Widening        ),
    .o_OuterSign          ( P3_OuterSign          )
);

// generate
//     for(i = 0 ; i < 4 ; i = i + 1) begin : Outer_Product_Round
//         C4_Round#(
//             .IN_WIDTH              ( 48                             ),
//             .EXP_WIDTH             ( 9                              )
//         )u_C4_Round_InnerProduct(
//             .i_op                  ( P3_Normal_Mantissa[i*48+:48]   ),
//             .i_exp                 ( P3_Normal_Exp[i*10+:10]        ),
//             .i_sign                ( P3_Normal_Sign[i*1+:1]         ),
//             .i_Exception_Handling  ( P3_Exception_Handling          ),
//             .i_N                   ( P3_N                           ),
//             .i_isbfloat16          ( P3_IsBfloat16                  ),
//             .o_rounded_result      ( P3_Outer_Product[i*32+:32]     ),
//             .o_sign                (                                ),
//             .o_normal_mantissa     (                                ),
//             .o_normal_exp          (                                )
//         ); 
//     end
// endgenerate

assign P3_Final_Result = P3_OuterSign ? P3_Outer_Product : {96'd0,P3_Inner_Result};

Pipline_4 u_Pipline_4(
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .i_Compute_Mode          ( P3_Compute_Mode          ),
    .i_Compute_Precision     ( P3_Compute_Precision     ),
    .i_Is_Widening           ( P3_Is_Widening           ),
    .i_Add_or_Subtract       ( P3_Add_or_Subtract       ),
    .i_ZmIsSigned            ( P3_ZmIsSigned            ),
    .i_ZnIsSigned            ( P3_ZnIsSigned            ),
    .i_Num_of_Vector_Group   ( P3_Num_of_Vector_Group   ),
    .i_Vector_Group_Num      ( P3_Vector_Group_Num      ),
    .i_Exception_Handling    ( P3_Exception_Handling    ),
    .i_ZA_Base_Address       ( P3_ZA_Base_Address       ),
    .i_Operand_C             ( P3_Operand_C             ),
    .i_Precision_Addend      ( P3_Precision_Addend      ),
    .i_Fuse_MultiAdd_Result  ( P3_Final_Result          ),
    .i_Normal_Sign           ( P3_Normal_Sign           ),
    .i_Normal_Exp            ( P3_Normal_Exp            ),
    .i_Normal_Mantissa       ( P3_Normal_Mantissa       ),
    .i_TypeA                 ( P3_TypeA                 ),
    .i_SignA                 ( P3_SignA                 ),
    .i_ExpoA                 ( P3_ExpoA                 ),
    .i_MantA                 ( P3_MantA                 ),
    .i_Is_Exception          ( P3_Is_Exception          ),
    .i_Result                ( P3_Result                ),
    .o_Result                ( P4_Result                ),
    .o_Is_Exception          ( P4_Is_Exception          ),
    .o_Compute_Mode          ( P4_Compute_Mode          ),
    .o_Compute_Precision     ( P4_Compute_Precision     ),
    .o_Is_Widening           ( P4_Is_Widening           ),
    .o_Add_or_Subtract       ( P4_Add_or_Subtract       ),
    .o_ZmIsSigned            ( P4_ZmIsSigned            ),
    .o_ZnIsSigned            ( P4_ZnIsSigned            ),
    .o_Num_of_Vector_Group   ( P4_Num_of_Vector_Group   ),
    .o_Vector_Group_Num      ( P4_Vector_Group_Num      ),
    .o_Exception_Handling    ( P4_Exception_Handling    ),
    .o_ZA_Base_Address       ( P4_ZA_Base_Address       ),
    .o_Operand_C             ( P4_Operand_C             ),
    .o_Precision_Addend      ( P4_Precision_Addend      ),
    .o_Fuse_MultiAdd_Result  ( P4_Fuse_MultiAdd_Result  ),
    .o_Normal_Sign           ( P4_Normal_Sign           ),
    .o_Normal_Exp            ( P4_Normal_Exp            ),
    .o_Normal_Mantissa       ( P4_Normal_Mantissa       ),
    .o_TypeA                 ( P4_TypeA                 ),
    .o_SignA                 ( P4_SignA                 ),
    .o_ExpoA                 ( P4_ExpoA                 ),
    .o_MantA                 ( P4_MantA                 )
);


generate
    for(i = 0 ; i < 4 ; i = i + 1) begin : Add_ZA
        C5_FPADDComb u_C5_FPADDComb(
            .i_Compute_Mode        ( P4_Compute_Mode                    ),
            .i_Is_Widening         ( P4_Is_Widening                     ),
            .i_Vector_Group_Num    ( P4_Vector_Group_Num                ),
            .i_Add_or_Subtract     ( P4_Add_or_Subtract                 ),
            .i_Precision_Addend    ( P4_Precision_Addend                ),
            .i_Compute_Precision   ( P4_Compute_Precision               ),
            .i_Exception_Handling  ( P4_Exception_Handling              ),
            .i_Value1              ( P4_Fuse_MultiAdd_Result[i*32+:32]  ),
            .i_Value2              ( P4_Operand_C[i*32+:32]             ),
            .i_FuseAdd_SelfAdd     (                                    ),
            .i_Temp_Sign1          ( P4_Normal_Sign[0]                  ),
            .i_Temp_Sign2          ( P4_SignA[i]                        ),
            .i_Temp_Expo1          ( P4_Normal_Exp[9:0]                 ),
            .i_Temp_Expo2          ( {2'd0,P4_ExpoA[i*8+:8]}            ),
            .i_Temp_Mant1          ( P4_Normal_Mantissa[47:0]           ),
            .i_Temp_Mant2          ( {P4_MantA[i*24+:24],24'd0}         ),
            .i_sticky_bit          ( C2_sticky_flag[i]                  ),
            .o_Temp_Sign           ( P4_Temp_Sign[i]                    ),
            .o_Temp_Expo           ( P4_Temp_Expo[i]                    ),
            .o_Temp_Mant           ( P4_Temp_Mant[i]                    ),
            .o_Mant                ( P4_Mant[i*49+:49]                  ),
            .o_Fault_Result        ( P4_Fault_Result[i*32+:32]          ),
            .o_IsBfloat16          ( P4_IsBfloat16[i*1+:1]              ),
            .o_N                   ( P4_N[i*1+:1]                       ),
            .o_Sum_Expo            ( P4_Sum_Expo[i*8+:8]                ),
            .o_Sum_Sign            ( P4_Sum_Sign[i*1+:1]                ),
            .o_is_Exception        ( P4_is_Exception[i]                 ),
            .o_Sticky_Bit          ( P4_Sticky_Bit[i]                   )
        );

        // assign P4_Refresh_Fault_Result[i*32+:32] = ({P4_Is_Exception[i],P4_is_Exception[i]} == 2'b01) ? P4_Fault_Result[i*32+:32] : P4_Result[i*32+:32];
        // assign P4_Refresh_Is_Exception[i*1+:1] = ({P4_Is_Exception[i],P4_is_Exception[i]} == 2'b01) ? P4_is_Exception[i] : P4_Is_Exception[i] ;

        assign P4_Refresh_Fault_Result[i*32+:32] = P4_Result[i*32+:32];
        assign P4_Refresh_Is_Exception[i*1+:1] = P4_Is_Exception[i] ;
    end
endgenerate

Pipline_5 u_Pipline_5(
    .clk                    ( clk                     ),
    .rst_n                  ( rst_n                   ),
    .i_Compute_Mode         ( P4_Compute_Mode         ),
    .i_Compute_Precision    ( P4_Compute_Precision    ),
    .i_Is_Widening          ( P4_Is_Widening          ),
    .i_Add_or_Subtract      ( P4_Add_or_Subtract      ),
    .i_ZmIsSigned           ( P4_ZmIsSigned           ),
    .i_ZnIsSigned           ( P4_ZnIsSigned           ),
    .i_Num_of_Vector_Group  ( P4_Num_of_Vector_Group  ),
    .i_Vector_Group_Num     ( P4_Vector_Group_Num     ),
    .i_Exception_Handling   ( P4_Exception_Handling   ),
    .i_ZA_Base_Address      ( P4_ZA_Base_Address      ),
    .i_Precision_Addend     ( P4_Precision_Addend     ),
    .i_Mant                 ( P4_Mant                 ),
    .i_Fault_Result         ( P4_Refresh_Fault_Result ),
    .i_IsBfloat16           ( P4_IsBfloat16           ),
    .i_N                    ( P4_N                    ),
    .i_Sum_Expo             ( P4_Sum_Expo             ),
    .i_Sum_Sign             ( P4_Sum_Sign             ),
    .i_Temp_Sign            ( P4_Temp_Sign[0]         ),
    .i_Temp_Expo            ( P4_Temp_Expo[0]         ),
    .i_Temp_Mant            ( P4_Temp_Mant[0]         ),
    .i_Is_Exception         ( P4_Refresh_Is_Exception ),
    .i_Sticky_Bit           ( P4_Sticky_Bit[0]        ),
    .o_Sticky_Bit           ( P5_Sticky_Bit[0]        ),
    .o_Is_Exception         ( P5_Is_Exception         ),
    .o_Mant                 ( P5_Mant                 ),
    .o_Fault_Result         ( P5_Fault_Result         ),
    .o_IsBfloat16           ( P5_IsBfloat16           ),
    .o_N                    ( P5_N                    ),
    .o_Sum_Expo             ( P5_Sum_Expo             ),
    .o_Sum_Sign             ( P5_Sum_Sign             ),
    .o_Compute_Mode         ( P5_Compute_Mode         ),
    .o_Compute_Precision    ( P5_Compute_Precision    ),
    .o_Is_Widening          ( P5_Is_Widening          ),
    .o_Add_or_Subtract      ( P5_Add_or_Subtract      ),
    .o_ZmIsSigned           ( P5_ZmIsSigned           ),
    .o_ZnIsSigned           ( P5_ZnIsSigned           ),
    .o_Num_of_Vector_Group  ( P5_Num_of_Vector_Group  ),
    .o_Vector_Group_Num     ( P5_Vector_Group_Num     ),
    .o_Exception_Handling   ( P5_Exception_Handling   ),
    .o_ZA_Base_Address      ( P5_ZA_Base_Address      ),
    .o_Precision_Addend     ( P5_Precision_Addend     ),
    .o_Temp_Sign            ( P5_Temp_Sign            ),
    .o_Temp_Expo            ( P5_Temp_Expo            ),
    .o_Temp_Mant            ( P5_Temp_Mant            )
);

generate
    for(i = 0 ; i < 4 ; i = i + 1) begin : Add_ZA_Round
        C6_Round#(
            .IN_WIDTH              ( 49                         ),
            .EXP_WIDTH             ( 10                         )
        )u_C6_Round(        
            .i_op                  ( P5_Mant[i*49+:49]          ),
            .i_exp                 ( P5_Sum_Expo[i*10+:10]      ),
            .i_sign                ( P5_Sum_Sign[i*1+:1]        ),
            .i_Exception_Handling  ( P5_Exception_Handling      ),
            .i_N                   ( P5_N[i*1+:1]               ),
            .i_isbfloat16          ( P5_IsBfloat16[i*1+:1]      ),
            .i_sticky_bit          ( P5_Sticky_Bit[0]           ),
            .o_rounded_result      ( P5_Round_Result[i*32+:32]  )
        );

        assign P5_Result[i*32+:32] = (P5_Is_Exception[i] == 1'd1) ? P5_Fault_Result[i*32+:32] : {4{P5_FP32_Result}} ;
    end
endgenerate

C6_Round#(
    .IN_WIDTH              ( 48                         ),
    .EXP_WIDTH             ( 10                         )
)u_C6_Round_FP32(        
    .i_op                  ( P5_Temp_Mant[72:25]        ),
    .i_exp                 ( P5_Temp_Expo               ),
    .i_sign                ( P5_Temp_Sign               ),
    .i_Exception_Handling  ( P5_Exception_Handling      ),
    .i_N                   ( P5_N[0]                    ),
    .i_isbfloat16          ( P5_IsBfloat16[0]           ),
    .i_sticky_bit          ( P5_Sticky_Bit[0]           ),
    .o_rounded_result      ( P5_FP32_Result             )
);

assign i_Result = (is_int_op) ? P1_Int_Result : P5_Result;
Pipline_6 u_Pipline_6(
    .clk             ( clk              ),
    .rst_n           ( rst_n            ),
    .i_Round_Result  ( i_Result         ),
    .o_Result        ( o_Result         )
);


endmodule
