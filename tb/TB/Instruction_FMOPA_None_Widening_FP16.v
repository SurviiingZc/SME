`timescale 1ns / 1ps


module Instruction_FMOPA_None_Widening_FP16(
    clk                   ,
    rst                   ,
    Test_Case             ,
    i_send_data_start     ,
    o_Compute_Mode        ,
    o_Compute_Precision   ,
    o_Is_Widening         ,
    o_Add_or_Subtract     ,
    o_ZmIsSigned          ,
    o_ZnIsSigned          ,
    o_Num_of_Vector_Group ,
    o_Vector_Group_Num    ,
    o_Exception_Handling  ,
    o_ZA_Base_Address     ,
    o_Active_Element_A    ,
    o_Active_Element_B    ,
    o_Operand_A           ,
    o_Operand_B           ,
    o_Operand_C           ,
    o_Right_Result        ,
    Test_Instruction      ,
    receiver_result_valid ,
    Test_Situation        
);

parameter C                 = 5   ;

localparam Case_Count = 2 ** C + 32;
input               clk                     ;
input               rst                     ;
input             i_send_data_start         ;
input   [ C:0]    Test_Case                 ;
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
output            receiver_result_valid     ;


parameter         N  =  16                  ;
wire    [N-1:0]   s_axis_a_tdata            ;
wire              s_axis_a_tvalid           ;
wire              s_axis_a_tready           ;
    
wire    [N-1:0]   s_axis_b_tdata            ;
wire              s_axis_b_tvalid           ;
wire              s_axis_b_tready           ;
    
wire    [N-1:0]   s_axis_c_tdata            ;
wire              s_axis_c_tvalid           ;
wire              s_axis_c_tready           ;
    
wire    [N-1:0]   m_axis_result_tdata       ;
wire              m_axis_result_tvalid      ;
wire              m_axis_result_tready      ;
wire              sender_busy               ;
wire              send_data_start           ;
wire    [N-1:0]   receiver_result           ;
wire              receiver_result_valid     ;

//Floating-point Control Signal.
reg              AHP      ;
reg              DN       ;
reg              FZ       ;
reg    [1:0]     RMode    ;
reg    [1:0]     Stride   ;
reg              FZ16     ;
reg    [1:0]     Len      ;
reg              IDE      ;
reg              EBF      ;
reg              IXE      ;
reg              UFE      ;
reg              OFE      ;
reg              DZE      ;
reg              IOE      ;
reg              NEP      ;
reg              AH       ;
reg              FIZ      ;

reg              Sign_FP16            ;
reg  [ 4:0]      Exp_FP16             ;
reg  [ 9:0]      Frac_FP16            ;
reg  [15:0]      Value_FP16           ;
reg              Sign_BF16            ;
reg  [ 7:0]      Exp_BF16             ;
reg  [ 6:0]      Frac_BF16            ;
reg  [15:0]      Value_BF16           ;
reg              Sign_FP32            ;
reg  [ 7:0]      Exp_FP32             ;
reg  [22:0]      Frac_FP32            ;
reg  [31:0]      Value_FP32           ;


wire             is_BF16_FP16_FP32     ;
wire             is_8_bits             ;
wire             is_16_bits            ;
wire             is_32_bits            ;
reg    [7:0]     Active_Mapped_8_bits  ;
reg    [7:0]     Active_Mapped_16_bits ;
reg    [7:0]     Active_Mapped_32_bits ;
reg    [7:0]     Active_Mapped_8_Sel   ;
reg    [7:0]     Active_Mapped_16_Sel  ;
reg    [7:0]     Active_Mapped_32_Sel  ;
reg    [7:0]     T_Active_Element      ;
integer          i,j,k                 ;

reg  [31:0]       A1                  [Case_Count - 1:0]  ;
reg  [31:0]       B1                  [Case_Count - 1:0]  ;
reg  [31:0]       C1                  [Case_Count - 1:0]  ;
reg  [31:0]       Result              [Case_Count - 1:0]  ;
reg  [999:0]      Situation           [Case_Count - 1:0]  ;

reg  [15:0]       rand_val_A                              ; 
reg  [15:0]       rand_val_B                              ; 
reg  [15:0]       rand_val_C                              ; 
assign Test_Instruction       = "FMOPA_None_Widening_FP16"                                         ;
assign Test_Situation         = Situation[Test_Case]                                               ;
assign o_Compute_Mode         = `Outer_Product                                                     ;
assign o_Compute_Precision    = `FP16                                                              ;
assign o_Add_or_Subtract      = `Addition_Operation                                                ;
assign o_ZmIsSigned           = `Zm_Is_Signed                                                      ;
assign o_ZnIsSigned           = `Zn_Is_Signed                                                      ;
assign o_Is_Widening          = `Operands_Is_Not_Widening                                          ;
assign o_Num_of_Vector_Group  = `Two_Vector_Group                                                  ;
assign o_Vector_Group_Num     = `Single_Vector_Group                                               ;
assign o_Exception_Handling   = {AHP,DN,FZ,RMode,Stride,FZ16,Len,IDE,EBF,IXE,UFE,OFE,DZE,IOE,NEP,AH,FIZ}  ; 
assign o_ZA_Base_Address      = $random()                                                          ;
assign o_Active_Element_A     = T_Active_Element[3:0]                                              ;
assign o_Active_Element_B     = T_Active_Element[7:4]                                              ;
assign o_Operand_A            = A1[Test_Case]                                                      ;
assign o_Operand_B            = B1[Test_Case]                                                      ;
assign o_Operand_C            = {C1[Test_Case],C1[Test_Case],C1[Test_Case],C1[Test_Case]}                                              ;
//assign o_Right_Result         = (Test_Case < 10) ? {96'd0,Result[Test_Case]} : {96'd0,receiver_result};
assign o_Right_Result         = {16'd0,receiver_result,16'd0,receiver_result,16'd0,receiver_result,16'd0,receiver_result};
assign is_BF16_FP16_FP32      = ((o_Compute_Precision == `FP32) | (o_Compute_Precision == `FP16) | (o_Compute_Precision == `BF16) | (o_Compute_Precision == `FP8)) ? 'b1 : 'b0 ;
assign is_8_bits              = ((o_Compute_Precision == `INT8) | (o_Compute_Precision == `FP8)) ? 'b1 : 'b0                                                                   ;
assign is_16_bits             = ((o_Compute_Precision == `BF16) | (o_Compute_Precision == `INT16) | (o_Compute_Precision == `FP16)) ? 'b1 : 'b0                                ;
assign is_32_bits             = ((o_Compute_Precision == `FP32) | (o_Compute_Precision == `INT32)) ? 'b1 : 'b0                                                                 ;
// assign receiver_result_valid  = 1 ;

always @(*) begin
    DN       = `Operation_Involving_NaNs_Returns_Default_NaN            ;
    AHP      = `IEEE_Half_Precision_Format                              ;
    FZ       = `Do_Not_Flush_Denormalized_Results_to_Zero               ;
    RMode    = `Round_to_Nearest_Mode                                   ;
    Stride   = `Stride_1                                                ;
    FZ16     = `Do_Not_Flush_Denormalized_Results_to_Zero_Half          ;
    Len      = `Length_1                                                ;
    IDE      = `Trap_Enabled_for_Input_Denormal                         ;
    EBF      = `Standard_BFloat16_Behaviors                             ;
    IXE      = `Trap_Enabled_for_Inexact_Result                         ;
    UFE      = `Trap_Enabled_for_Underflow                              ;
    OFE      = `Trap_Enabled_for_Overflow                               ;
    DZE      = `Trap_Enabled_for_Divide_by_Zero                         ;
    IOE      = `Trap_Enabled_for_Invalid_Operation                      ;
    NEP      = `Not_Affect_Output_Elements                              ;
    AH       = `IEEE_Handling_Floating_Point_Numbers                    ;
    FIZ      = `Do_Not_Flush_Denormalized_Results_to_Zero_S_D_BF        ;

    Active_Mapped_8_bits   = 8'b1111_1111           ;
    Active_Mapped_16_bits  = 8'b0101_0101           ;
    Active_Mapped_32_bits  = 8'b0001_0001           ;

    `ifdef Randomly_Generate_Activation_Bits
    for(i = 0 ; i < 8 ; i = i + 1) begin
        Active_Mapped_8_Sel[i]  = Active_Mapped_8_bits[i] ? $random() % 2 : 1'd0     ;
        Active_Mapped_16_Sel[i] = Active_Mapped_16_bits[i] ? $random() % 2 : 1'd0    ;
        Active_Mapped_32_Sel[i] = Active_Mapped_32_bits[i] ? $random() % 2 : 1'd0    ;
        T_Active_Element[i]     = is_8_bits ? Active_Mapped_8_Sel[i] :
                                    is_16_bits ? Active_Mapped_16_Sel[i] :
                                    is_32_bits ? Active_Mapped_32_Sel[i] : 1'dz;
    end
    `else
    T_Active_Element     = is_8_bits ? Active_Mapped_8_bits :
                                is_16_bits ? Active_Mapped_16_bits :
                                is_32_bits ? Active_Mapped_32_bits : 8'dz;
    `endif

    for(k = 0 ; k < 32 ; k = k + 1) begin
        Situation[k]                   = "Blank Situation"                        ;
        A1[k]                          = 'd0                                      ;
        B1[k]                          = 'd0                                      ;
        C1[k]                          = 'd0                                      ;
        Result[k]                      = 'd0                                      ;
    end

    for (j = 32; j < Case_Count; j = j + 1) begin
        Situation[j] = "Random Situation";
        rand_val_A     = $random & 16'hFFFF; 
        rand_val_B     = $random & 16'hFFFF; 
        rand_val_C     = $random & 16'hFFFF; 
        A1[j]        = {rand_val_A, rand_val_A}; 
        B1[j]        = {rand_val_B, rand_val_B};              
        C1[j]        = {16'd0, rand_val_C};              
        Result[j]    = 'dz;
    end

    Situation[0] = "1 * 1 + 1" ;
    Sign_FP16    = 1'd1                                         ;
    Exp_FP16     = 5'b01111                                     ;
    Frac_FP16    = {10{1'd0}}                                   ;
    Value_FP16   = {Sign_FP16,Exp_FP16,Frac_FP16}               ;
    A1[0]        = o_Active_Element_A[0] ? Value_FP16 : 32'd0   ;
    Sign_FP16    = 1'd1                                         ;
    Exp_FP16     = 5'b01111                                     ;
    Frac_FP16    = {10{1'd0}}                                   ;
    Value_FP16   = {Sign_FP16,Exp_FP16,Frac_FP16}               ;
    B1[0]        = o_Active_Element_B[0] ? Value_FP16 : 32'd0   ;
    Sign_FP16    = 1'd1                                         ;
    Exp_FP16     = 5'b01111                                     ;
    Frac_FP16    = {10{1'd0}}                                   ;
    Value_FP16   = {Sign_FP16,Exp_FP16,Frac_FP16}               ;
    C1[0]        = Value_FP16                                   ;
    Result[0]    = Value_FP16                                   ;
end


// always @(*) begin

        
// end

    // IP_FP16_FMA u_IP_FP16_FMA (
    //     .aclk(clk),
    //     .aresetn(rst),

    //     .s_axis_a_tdata(s_axis_a_tdata),
    //     .s_axis_a_tvalid(s_axis_a_tvalid),
    //     .s_axis_a_tready(s_axis_a_tready),

    //     .s_axis_b_tdata(s_axis_b_tdata),
    //     .s_axis_b_tvalid(s_axis_b_tvalid),
    //     .s_axis_b_tready(s_axis_b_tready),

    //     .s_axis_c_tdata(s_axis_c_tdata),
    //     .s_axis_c_tvalid(s_axis_c_tvalid),
    //     .s_axis_c_tready(s_axis_c_tready),

    //     .m_axis_result_tdata(m_axis_result_tdata),
    //     .m_axis_result_tvalid(m_axis_result_tvalid),
    //     .m_axis_result_tready(m_axis_result_tready)    
    // );

    // axis_master #(
    //     .N (N)
    // )u_axis_master (
    //     .ACLK(clk),
    //     .ARESETn(rst),
    //     .start(i_send_data_start),
    //     .data_a(o_Operand_A[15:0]),
    //     .data_b(o_Operand_B[15:0]),
    //     .data_c(o_Operand_C[15:0]),
    //     .busy(sender_busy),

    //     .M_AXIS_A_TDATA(s_axis_a_tdata),
    //     .M_AXIS_A_TVALID(s_axis_a_tvalid),
    //     .M_AXIS_A_TREADY(s_axis_a_tready),

    //     .M_AXIS_B_TDATA(s_axis_b_tdata),
    //     .M_AXIS_B_TVALID(s_axis_b_tvalid),
    //     .M_AXIS_B_TREADY(s_axis_b_tready),

    //     .M_AXIS_C_TDATA(s_axis_c_tdata),
    //     .M_AXIS_C_TVALID(s_axis_c_tvalid),
    //     .M_AXIS_C_TREADY(s_axis_c_tready)
    // );


    // axis_slave_receiver #(
    //     .N (N)
    // )u_axis_slave (
    //     .ACLK(clk),
    //     .ARESETn(rst),

    //     .result(receiver_result),
    //     .result_valid(receiver_result_valid),

    //     .S_AXIS_RESULT_TDATA(m_axis_result_tdata),
    //     .S_AXIS_RESULT_TVALID(m_axis_result_tvalid),
    //     .S_AXIS_RESULT_TREADY(m_axis_result_tready)
    // );

endmodule