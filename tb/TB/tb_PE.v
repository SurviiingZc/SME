`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module tb_PE();

//outer product instructions
parameter ADDHA_SINT32              = 7'd00 ;
parameter ADDVA_SINT32              = 7'd01 ;
parameter FMOPA_None_Widening_FP32  = 7'd02 ;
parameter FMOPA_None_Widening_FP16  = 7'd03 ;
parameter FMOPS_None_Widening_FP32  = 7'd04 ;
parameter FMOPS_None_Widening_FP16  = 7'd05 ;
parameter FMOPA_Widening_FP16       = 7'd06 ;
parameter FMOPS_Widening_FP16       = 7'd07 ;
parameter BFMOPA_Widening_BP16      = 7'd08 ;
parameter BFMOPS_Widening_BP16      = 7'd09 ;
parameter SMOPA_SINT8_SINT8         = 7'd10 ;
parameter SMOPS_SINT8_SINT8         = 7'd11 ;
parameter SUMOPA_SINT8_UINT8        = 7'd12 ;
parameter SUMOPS_SINT8_UINT8        = 7'd13 ;
parameter UMOPA_UINT8_UINT8         = 7'd14 ;
parameter UMOPS_UINT8_UINT8         = 7'd15 ;
parameter USMOPA_UINT8_SINT8        = 7'd16 ;
parameter USMOPS_UINT8_SINT8        = 7'd17 ;

//inner product instructions
parameter FDOT_Two_Single_FP16      = 7'd18 ;
parameter FDOT_Four_Single_FP16     = 7'd19 ;
parameter FMLA_Two_Single_FP16      = 7'd20 ;
parameter FMLA_Four_Single_FP16     = 7'd21 ;
parameter FMLA_Two_Single_FP32      = 7'd22 ;
parameter FMLA_Four_Single_FP32     = 7'd23 ;
parameter FMLAL_Two_Double_FP16     = 7'd24 ;
parameter FMLAL_Four_Double_FP16    = 7'd25 ;
parameter SDOT_Two_Single_SINT16    = 7'd26 ;
parameter SDOT_Four_Single_SINT16   = 7'd27 ;
parameter UDOT_Two_Single_UINT16    = 7'd28 ;
parameter UDOT_Four_Single_UINT16   = 7'd29 ;
parameter SMLAL_Two_Double_SINT16   = 7'd30 ;
parameter SMLAL_Four_Double_SINT16  = 7'd31 ;
parameter SMLALL_Two_Quad_SINT8     = 7'd32 ;
parameter SMLALL_Four_Quad_SINT8    = 7'd33 ;
parameter UMLAL_Two_Double_SINT16   = 7'd34 ;
parameter UMLAL_Four_Double_SINT16  = 7'd35 ;
parameter UMLALL_Two_Quad_SINT8     = 7'd36 ;
parameter UMLALL_Four_Quad_SINT8    = 7'd37 ;
parameter C                         = 7'd7  ;

localparam Case_Count = 2 ** C + 32   ;

reg            clk                    ;
reg            rst_n                  ;
reg  [ C:0]    Test_Case_Select       ;
reg  [ 6:0]    Instructions_Select    ;

wire           o_Compute_Mode         ;
wire [ 2:0]    o_Compute_Precision    ;
wire           o_Is_Widening          ;
wire           o_Add_or_Subtract      ;
wire           o_ZmIsSigned           ;
wire           o_ZnIsSigned           ;
wire           o_Num_of_Vector_Group  ;
wire [ 1:0]    o_Vector_Group_Num     ;
wire [19:0]    o_Exception_Handling   ;
wire [31:0]    o_ZA_Base_Address      ;
wire [ 3:0]    o_Active_Element_A     ;
wire [ 3:0]    o_Active_Element_B     ;
wire [31:0]    o_Operand_A            ;
wire [31:0]    o_Operand_B            ;
wire [127:0]   o_Operand_C            ;
wire [127:0]   o_Result               ;

reg           i_send_data_start       ;

wire [127:0]   o_Right_Result         ;
wire [999:0]   Test_Instruction       ;
wire [999:0]   Test_Situation         ;


always #(`clock_period / 2) clk = ~clk;

PE u_PE(
    .clk                    ( clk                    ),
    .rst_n                  ( rst_n                  ),
    .i_Compute_Mode         ( o_Compute_Mode         ),
    .i_Compute_Precision    ( o_Compute_Precision    ),
    .i_Is_Widening          ( o_Is_Widening          ),
    .i_Add_or_Subtract      ( o_Add_or_Subtract      ),
    .i_ZmIsSigned           ( o_ZmIsSigned           ),
    .i_ZnIsSigned           ( o_ZnIsSigned           ),
    .i_Num_of_Vector_Group  ( o_Num_of_Vector_Group  ),
    .i_Vector_Group_Num     ( o_Vector_Group_Num     ),
    .i_Exception_Handling   ( o_Exception_Handling   ),
    .i_ZA_Base_Address      ( o_ZA_Base_Address      ),
    .i_Active_Element_A     ( o_Active_Element_A     ),
    .i_Active_Element_B     ( o_Active_Element_B     ),
    .i_Operand_A            ( o_Operand_A            ),
    .i_Operand_B            ( o_Operand_B            ),
    .i_Operand_C            ( o_Operand_C            ),
    .o_Result               ( o_Result               )
);

All_Instruction  #(
    .C                         ( C                         )
) u_All_Instruction(
    .clk                       ( clk                       ),
    .rst                       ( rst_n                     ),
    .i_send_data_start         ( i_send_data_start         ),
    .Instructions_Select       ( Instructions_Select       ),
    .Test_Case_Select          ( Test_Case_Select          ),
    .o_Compute_Mode            ( o_Compute_Mode            ),
    .o_Compute_Precision       ( o_Compute_Precision       ),
    .o_Is_Widening             ( o_Is_Widening             ),
    .o_Add_or_Subtract         ( o_Add_or_Subtract         ),
    .o_ZmIsSigned              ( o_ZmIsSigned              ),
    .o_ZnIsSigned              ( o_ZnIsSigned              ),
    .o_Num_of_Vector_Group     ( o_Num_of_Vector_Group     ),
    .o_Vector_Group_Num        ( o_Vector_Group_Num        ),
    .o_Exception_Handling      ( o_Exception_Handling      ),
    .o_ZA_Base_Address         ( o_ZA_Base_Address         ),
    .o_Active_Element_A        ( o_Active_Element_A        ),
    .o_Active_Element_B        ( o_Active_Element_B        ),
    .o_Operand_A               ( o_Operand_A               ),
    .o_Operand_B               ( o_Operand_B               ),
    .o_Operand_C               ( o_Operand_C               ),
    .o_Right_Result            ( o_Right_Result            ),
    .o_receiver_result_valid   ( o_receiver_result_valid   ),
    .Test_Instruction          ( Test_Instruction          ),
    .Test_Situation            ( Test_Situation            )
);

// wire [31:0] result = o_Result[31:0];
// reg [31:0] PE_Result;
// always @(posedge o_receiver_result_valid) begin
//     PE_Result <= result;
// end
// integer     m,n;

// wire [31:0] Right_Result = o_Right_Result[31:0];
// wire [31:0] Operand_C =o_Operand_C[31:0];
// wire        is_Result_Right = (Right_Result == PE_Result) ? 1'd1 : 1'd0;
// initial begin
//     clk                     = 0 ;
//     Test_Case_Select        = 0 ;
//     Instructions_Select     = 0 ;
//     rst_n                   = 0 ;
//     // #(`clock_period * 1)        ;
//     // rst_n                   = 0 ;
//     #(`clock_period * 1)        ;
//     rst_n                   = 1 ;
//     for(m = 2 ; m < 4 ; m = m + 1) begin
//         Instructions_Select = m;
//         for(n = 0 ; n < Case_Count ; n = n + 1) begin
//             Test_Case_Select = n;
//             i_send_data_start = 1;
//             #(`clock_period * 1);
//             i_send_data_start = 0;
//             wait(o_receiver_result_valid);
//         end
//     end

//     #(`clock_period * 1);
//     $finish;
// end

integer     m,n;

initial begin
    clk                     = 0 ;
    Test_Case_Select        = 0 ;
    Instructions_Select     = 3 ;
    rst_n                   = 0 ;
    #5;
    rst_n                   = 1 ;
    for(n = 0 ; n < Case_Count ; n = n + 1) begin
        Test_Case_Select = n;
        $display("time:[%0t],Test_Case_Select: %0d ",$time,Test_Case_Select);
        #5;
    end

    #5;
    $finish;
end

initial begin
    $fsdbDumpfile("PE.fsdb");
    $fsdbDumpvars();
    $fsdbDumpMDA;
end

endmodule