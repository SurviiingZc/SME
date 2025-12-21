`timescale 1ns / 1ps
module All_Instruction(
    clk                      ,
    rst                      ,
    Instructions_Select      ,
    Test_Case_Select         ,
    i_send_data_start        ,
    o_Compute_Mode           ,
    o_Compute_Precision      ,
    o_Is_Widening            ,
    o_Add_or_Subtract        ,
    o_ZmIsSigned             ,
    o_ZnIsSigned             ,
    o_Num_of_Vector_Group    ,
    o_Vector_Group_Num       ,
    o_Exception_Handling     ,
    o_ZA_Base_Address        ,
    o_Active_Element_A       ,
    o_Active_Element_B       ,
    o_Operand_A              ,
    o_Operand_B              ,
    o_Operand_C              ,
    o_Right_Result           ,
    o_receiver_result_valid  ,
    Test_Instruction         ,
    Test_Situation           
);

parameter C = 5;
input               clk                     ;
input               rst                     ;
input             i_send_data_start         ;
input   [ 6:0]    Instructions_Select       ;
input   [ C:0]    Test_Case_Select          ;     
output            o_Compute_Mode            ;
output  [ 2:0]    o_Compute_Precision       ;
output            o_Is_Widening             ;
output            o_Add_or_Subtract         ;
output            o_ZmIsSigned              ;
output            o_ZnIsSigned              ;
output            o_Num_of_Vector_Group     ;
output  [ 1:0]    o_Vector_Group_Num        ;
output  [19:0]    o_Exception_Handling      ;
output  [31:0]    o_ZA_Base_Address         ;
output  [ 3:0]    o_Active_Element_A        ;
output  [ 3:0]    o_Active_Element_B        ;
output  [31:0]    o_Operand_A               ;
output  [31:0]    o_Operand_B               ;
output  [127:0]   o_Operand_C               ;
output  [127:0]   o_Right_Result            ;
output  [999:0]   Test_Instruction          ;
output  [999:0]   Test_Situation            ;
output            o_receiver_result_valid   ;
wire           T_Compute_Mode            [37:0] ;
wire [ 2:0]    T_Compute_Precision       [37:0] ;
wire           T_Is_Widening             [37:0] ;
wire           T_Add_or_Subtract         [37:0] ;
wire           T_ZmIsSigned              [37:0] ;
wire           T_ZnIsSigned              [37:0] ;
wire           T_Num_of_Vector_Group     [37:0] ;
wire [ 1:0]    T_Vector_Group_Num        [37:0] ;
wire [14:0]    T_Exception_Control       [37:0] ;
wire [19:0]    T_Exception_Handling      [37:0] ;
wire [31:0]    T_ZA_Base_Address         [37:0] ;
wire [ 3:0]    T_Active_Element_A        [37:0] ;
wire [ 3:0]    T_Active_Element_B        [37:0] ;
wire [31:0]    T_Operand_A               [37:0] ;
wire [31:0]    T_Operand_B               [37:0] ;
wire [127:0]   T_Operand_C               [37:0] ;
wire [127:0]   T_Right_Result            [37:0] ;
wire [999:0]   T_Test_Instruction        [37:0] ;
wire [999:0]   T_Test_Situation          [37:0] ;
wire           T_receiver_result_valid   [37:0] ;
wire           T_send_data_start         [37:0] ;

Instruction_ADDHA_SINT32 #(
    .C                      ( C                         )
) u_Instruction_ADDHA_SINT32(
    .Test_Case              ( Test_Case_Select          ),
    .o_Compute_Mode         ( T_Compute_Mode       [0]  ),
    .o_Compute_Precision    ( T_Compute_Precision  [0]  ),
    .o_Is_Widening          ( T_Is_Widening        [0]  ),
    .o_Add_or_Subtract      ( T_Add_or_Subtract    [0]  ),
    .o_ZmIsSigned           ( T_ZmIsSigned         [0]  ),
    .o_ZnIsSigned           ( T_ZnIsSigned         [0]  ),
    .o_Num_of_Vector_Group  ( T_Num_of_Vector_Group[0]  ),
    .o_Vector_Group_Num     ( T_Vector_Group_Num   [0]  ),
    .o_Exception_Handling   ( T_Exception_Handling [0]  ),
    .o_ZA_Base_Address      ( T_ZA_Base_Address    [0]  ),
    .o_Active_Element_A     ( T_Active_Element_A   [0]  ),
    .o_Active_Element_B     ( T_Active_Element_B   [0]  ),
    .o_Operand_A            ( T_Operand_A          [0]  ),
    .o_Operand_B            ( T_Operand_B          [0]  ),
    .o_Operand_C            ( T_Operand_C          [0]  ),
    .o_Right_Result         ( T_Right_Result       [0]  ),
    .Test_Instruction       ( T_Test_Instruction   [0]  ),
    .Test_Situation         ( T_Test_Situation     [0]  )
);

Instruction_ADDVA_SINT32 #(
    .C                      ( C                         )
) u_Instruction_ADDVA_SINT32(
    .Test_Case              ( Test_Case_Select          ),
    .o_Compute_Mode         ( T_Compute_Mode       [1]  ),
    .o_Compute_Precision    ( T_Compute_Precision  [1]  ),
    .o_Is_Widening          ( T_Is_Widening        [1]  ),
    .o_Add_or_Subtract      ( T_Add_or_Subtract    [1]  ),
    .o_ZmIsSigned           ( T_ZmIsSigned         [1]  ),
    .o_ZnIsSigned           ( T_ZnIsSigned         [1]  ),
    .o_Num_of_Vector_Group  ( T_Num_of_Vector_Group[1]  ),
    .o_Vector_Group_Num     ( T_Vector_Group_Num   [1]  ),
    .o_Exception_Handling   ( T_Exception_Handling [1]  ),
    .o_ZA_Base_Address      ( T_ZA_Base_Address    [1]  ),
    .o_Active_Element_A     ( T_Active_Element_A   [1]  ),
    .o_Active_Element_B     ( T_Active_Element_B   [1]  ),
    .o_Operand_A            ( T_Operand_A          [1]  ),
    .o_Operand_B            ( T_Operand_B          [1]  ),
    .o_Operand_C            ( T_Operand_C          [1]  ),
    .o_Right_Result         ( T_Right_Result       [1]  ),
    .Test_Instruction       ( T_Test_Instruction   [1]  ),
    .Test_Situation         ( T_Test_Situation     [1]  )
);

Instruction_FMOPA_None_Widening_FP32 #(
    .C                      ( C                         )
) u_Instruction_FMOPA_None_Widening_FP32(
    .clk                    ( clk                        ),
    .rst                    ( rst                        ),
    .Test_Case              ( Test_Case_Select           ),
    .o_Compute_Mode         ( T_Compute_Mode       [2]   ),
    .o_Compute_Precision    ( T_Compute_Precision  [2]   ),
    .o_Is_Widening          ( T_Is_Widening        [2]   ),
    .o_Add_or_Subtract      ( T_Add_or_Subtract    [2]   ),
    .o_ZmIsSigned           ( T_ZmIsSigned         [2]   ),
    .o_ZnIsSigned           ( T_ZnIsSigned         [2]   ),
    .o_Num_of_Vector_Group  ( T_Num_of_Vector_Group[2]   ),
    .o_Vector_Group_Num     ( T_Vector_Group_Num   [2]   ),
    .o_Exception_Handling   ( T_Exception_Handling [2]   ),
    .o_ZA_Base_Address      ( T_ZA_Base_Address    [2]   ),
    .o_Active_Element_A     ( T_Active_Element_A   [2]   ),
    .o_Active_Element_B     ( T_Active_Element_B   [2]   ),
    .o_Operand_A            ( T_Operand_A          [2]   ),
    .o_Operand_B            ( T_Operand_B          [2]   ),
    .o_Operand_C            ( T_Operand_C          [2]   ),
    .o_Right_Result         ( T_Right_Result       [2]   ),
    .Test_Instruction       ( T_Test_Instruction   [2]   ),
    .i_send_data_start      ( i_send_data_start          ),
    .receiver_result_valid  ( T_receiver_result_valid[2] ),
    .Test_Situation         ( T_Test_Situation     [2]   )
);

Instruction_FMOPA_None_Widening_FP16 #(
    .C                      ( C                         )
) u_Instruction_FMOPA_None_Widening_FP16(
    .clk                    ( clk                        ),
    .rst                    ( rst                        ),
    .Test_Case              ( Test_Case_Select           ),
    .o_Compute_Mode         ( T_Compute_Mode       [3]   ),
    .o_Compute_Precision    ( T_Compute_Precision  [3]   ),
    .o_Is_Widening          ( T_Is_Widening        [3]   ),
    .o_Add_or_Subtract      ( T_Add_or_Subtract    [3]   ),
    .o_ZmIsSigned           ( T_ZmIsSigned         [3]   ),
    .o_ZnIsSigned           ( T_ZnIsSigned         [3]   ),
    .o_Num_of_Vector_Group  ( T_Num_of_Vector_Group[3]   ),
    .o_Vector_Group_Num     ( T_Vector_Group_Num   [3]   ),
    .o_Exception_Handling   ( T_Exception_Handling [3]   ),
    .o_ZA_Base_Address      ( T_ZA_Base_Address    [3]   ),
    .o_Active_Element_A     ( T_Active_Element_A   [3]   ),
    .o_Active_Element_B     ( T_Active_Element_B   [3]   ),
    .o_Operand_A            ( T_Operand_A          [3]   ),
    .o_Operand_B            ( T_Operand_B          [3]   ),
    .o_Operand_C            ( T_Operand_C          [3]   ),
    .o_Right_Result         ( T_Right_Result       [3]   ),
    .Test_Instruction       ( T_Test_Instruction   [3]   ),
    .i_send_data_start      ( i_send_data_start          ),
    .receiver_result_valid  ( T_receiver_result_valid[3] ),
    .Test_Situation         ( T_Test_Situation     [3]   )
);

Instruction_FMOPS_None_Widening_FP32 #(
    .C                      ( C                         )
) u_Instruction_FMOPS_None_Widening_FP32(
    .clk                    ( clk                        ),
    .rst                    ( rst                        ),
    .Test_Case              ( Test_Case_Select           ),
    .o_Compute_Mode         ( T_Compute_Mode       [4]   ),
    .o_Compute_Precision    ( T_Compute_Precision  [4]   ),
    .o_Is_Widening          ( T_Is_Widening        [4]   ),
    .o_Add_or_Subtract      ( T_Add_or_Subtract    [4]   ),
    .o_ZmIsSigned           ( T_ZmIsSigned         [4]   ),
    .o_ZnIsSigned           ( T_ZnIsSigned         [4]   ),
    .o_Num_of_Vector_Group  ( T_Num_of_Vector_Group[4]   ),
    .o_Vector_Group_Num     ( T_Vector_Group_Num   [4]   ),
    .o_Exception_Handling   ( T_Exception_Handling [4]   ),
    .o_ZA_Base_Address      ( T_ZA_Base_Address    [4]   ),
    .o_Active_Element_A     ( T_Active_Element_A   [4]   ),
    .o_Active_Element_B     ( T_Active_Element_B   [4]   ),
    .o_Operand_A            ( T_Operand_A          [4]   ),
    .o_Operand_B            ( T_Operand_B          [4]   ),
    .o_Operand_C            ( T_Operand_C          [4]   ),
    .o_Right_Result         ( T_Right_Result       [4]   ),
    .Test_Instruction       ( T_Test_Instruction   [4]   ),
    .i_send_data_start      ( i_send_data_start          ),
    .receiver_result_valid  ( T_receiver_result_valid[4] ),
    .Test_Situation         ( T_Test_Situation     [4]   )
);



Instruction_FMOPS_None_Widening_FP16 #(
    .C                      ( C                         )
) u_Instruction_FMOPS_None_Widening_FP16(
    .clk                    ( clk                        ),
    .rst                    ( rst                        ),
    .Test_Case              ( Test_Case_Select           ),
    .o_Compute_Mode         ( T_Compute_Mode       [5]   ),
    .o_Compute_Precision    ( T_Compute_Precision  [5]   ),
    .o_Is_Widening          ( T_Is_Widening        [5]   ),
    .o_Add_or_Subtract      ( T_Add_or_Subtract    [5]   ),
    .o_ZmIsSigned           ( T_ZmIsSigned         [5]   ),
    .o_ZnIsSigned           ( T_ZnIsSigned         [5]   ),
    .o_Num_of_Vector_Group  ( T_Num_of_Vector_Group[5]   ),
    .o_Vector_Group_Num     ( T_Vector_Group_Num   [5]   ),
    .o_Exception_Handling   ( T_Exception_Handling [5]   ),
    .o_ZA_Base_Address      ( T_ZA_Base_Address    [5]   ),
    .o_Active_Element_A     ( T_Active_Element_A   [5]   ),
    .o_Active_Element_B     ( T_Active_Element_B   [5]   ),
    .o_Operand_A            ( T_Operand_A          [5]   ),
    .o_Operand_B            ( T_Operand_B          [5]   ),
    .o_Operand_C            ( T_Operand_C          [5]   ),
    .o_Right_Result         ( T_Right_Result       [5]   ),
    .Test_Instruction       ( T_Test_Instruction   [5]   ),
    .i_send_data_start      ( i_send_data_start          ),
    .receiver_result_valid  ( T_receiver_result_valid[5] ),
    .Test_Situation         ( T_Test_Situation     [5]   )
);

assign o_Compute_Mode            = T_Compute_Mode[Instructions_Select]           ;  
assign o_Compute_Precision       = T_Compute_Precision[Instructions_Select]      ;  
assign o_Is_Widening             = T_Is_Widening[Instructions_Select]            ;  
assign o_Add_or_Subtract         = T_Add_or_Subtract[Instructions_Select]        ;  
assign o_ZmIsSigned              = T_ZmIsSigned[Instructions_Select]             ;  
assign o_ZnIsSigned              = T_ZnIsSigned[Instructions_Select]             ;  
assign o_Num_of_Vector_Group     = T_Num_of_Vector_Group[Instructions_Select]    ;  
assign o_Vector_Group_Num        = T_Vector_Group_Num[Instructions_Select]       ;   
assign o_Exception_Handling      = T_Exception_Handling[Instructions_Select]     ;  
assign o_ZA_Base_Address         = T_ZA_Base_Address[Instructions_Select]        ;  
assign o_Active_Element_A        = T_Active_Element_A[Instructions_Select]       ;  
assign o_Active_Element_B        = T_Active_Element_B[Instructions_Select]       ;  
assign o_Operand_A               = T_Operand_A[Instructions_Select]              ;  
assign o_Operand_B               = T_Operand_B[Instructions_Select]              ;  
assign o_Operand_C               = T_Operand_C[Instructions_Select]              ;  
assign o_Right_Result            = T_Right_Result[Instructions_Select]           ;  
assign Test_Instruction          = T_Test_Instruction[Instructions_Select]       ;  
assign Test_Situation            = T_Test_Situation[Instructions_Select]         ;  
assign o_receiver_result_valid   = T_receiver_result_valid[Instructions_Select]  ;
//assign T_send_data_start[Instructions_Select] = i_send_data_start                ;
endmodule