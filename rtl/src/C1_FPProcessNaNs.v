`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C1_FPProcessNaNs (
    input                 i_FPCR_AH       ,
    input                 i_FPCR_DN       ,
    input       [  1:0]   i_Operand_Num   , // 00 -> 2   01 -> 3   10 -> 3H   11 -> 4 
    input       [ 11:0]   i_Type          ,
    input       [  3:0]   i_Data_Width    ,
    input       [127:0]   i_FPNumber      ,
    output reg  [ 31:0]   o_FP_Result     ,
    output reg            o_Done
);

wire          ALTFP             ;
wire          Op1_NaN           ;
wire          Op2_NaN           ;
wire          Op3_NaN           ;
wire          Op4_NaN           ;

wire [ 2:0]   i_Type_1          ;
wire          i_Data_Width_1    ; // 0 -> 16   1 -> 32
wire [31:0]   i_FPNumber_1      ;
wire [ 2:0]   i_Type_2          ;
wire          i_Data_Width_2    ; // 0 -> 16   1 -> 32
wire [31:0]   i_FPNumber_2      ;
wire [ 2:0]   i_Type_3          ;
wire          i_Data_Width_3    ; // 0 -> 16   1 -> 32
wire [31:0]   i_FPNumber_3      ;
wire [ 2:0]   i_Type_4          ;
wire          i_Data_Width_4    ; // 0 -> 16   1 -> 32
wire [31:0]   i_FPNumber_4      ;

wire          Any_SNaN_S2       ;
wire [ 2:0]   Type_NaN_S2       ;
wire          Done_S2           ;
wire [31:0]   Result_S2         ;

wire          Any_SNaN_S3       ;
wire [ 2:0]   Type_NaN_S3       ;
wire          Done_S3           ;
wire [31:0]   Result_S3         ;

wire          Any_SNaN_S3H      ;
wire [ 2:0]   Type_NaN_S3H      ;
wire          Done_S3H          ;
wire [31:0]   Result_S3H        ;

wire          Any_SNaN_S4       ;
wire [ 2:0]   Type_NaN_S4       ;
wire          Done_S4           ;
wire [31:0]   Result_S4         ;

wire [ 2:0]   Type_NaN          ;

wire [31:0]   T_FP_NaN_1            ;
wire [31:0]   T_FPConvertNaN_1      ;
wire [31:0]   T_FP_AllNaN_1         ;
wire [31:0]   T_FP_NaN_2            ;
wire [31:0]   T_FPConvertNaN_2      ;
wire [31:0]   T_FPConvertAllNaN_2   ;
wire [31:0]   T_FP_AllNaN_2         ;
wire [31:0]   T_FP_NaN_3            ;
wire [31:0]   T_FPConvertNaN_3      ;
wire [31:0]   T_FPConvertAllNaN_3   ;
wire [31:0]   T_FP_AllNaN_3         ;
wire [31:0]   T_FP_NaN_4            ;
wire [31:0]   T_FPConvertNaN_4      ;
wire [31:0]   T_FP_AllNaN_4         ;

assign i_Type_1       = i_Type       [2:0]      ;
assign i_Data_Width_1 = i_Data_Width [0]        ;
assign i_FPNumber_1   = i_FPNumber   [31:0]     ;
assign i_Type_2       = i_Type       [5:3]      ;
assign i_Data_Width_2 = i_Data_Width [1]        ;
assign i_FPNumber_2   = i_FPNumber   [63:32]    ;
assign i_Type_3       = i_Type       [8:6]      ;
assign i_Data_Width_3 = i_Data_Width [2]        ;
assign i_FPNumber_3   = i_FPNumber   [95:64]    ;
assign i_Type_4       = i_Type       [11:9]     ;
assign i_Data_Width_4 = i_Data_Width [3]        ;
assign i_FPNumber_4   = i_FPNumber   [127:96]   ;

assign ALTFP        = (`FEAT_AFP == 1'd1) & (i_FPCR_AH == 1'd1)                                                                                             ; 
assign Op1_NaN      = ((i_Type_1 == `FPType_QNaN) | (i_Type_1 == `FPType_SNaN))                                                                             ;
assign Op2_NaN      = ((i_Type_2 == `FPType_QNaN) | (i_Type_2 == `FPType_SNaN))                                                                             ;
assign Op3_NaN      = ((i_Type_3 == `FPType_QNaN) | (i_Type_3 == `FPType_SNaN))                                                                             ;
assign Op4_NaN      = ((i_Type_4 == `FPType_QNaN) | (i_Type_4 == `FPType_SNaN))                                                                             ;
assign Any_SNaN_S2  = ((i_Type_1 == `FPType_SNaN) | (i_Type_2 == `FPType_SNaN))                                                                             ;
assign Type_NaN_S2  = (Any_SNaN_S2 == 1'd1) ? `FPType_SNaN : `FPType_QNaN                                                                                   ;
assign Done_S2      = ((ALTFP & Op1_NaN & Op2_NaN) | Op1_NaN | Op2_NaN) ? 1'd1 : 1'd0                                                                       ;
assign Result_S2    = {32{ALTFP & Op1_NaN & Op2_NaN}} & T_FP_AllNaN_1 |
                        {32{i_Type_1 == `FPType_SNaN}} & T_FP_NaN_1 |
                        {32{i_Type_2 == `FPType_SNaN}} & T_FP_NaN_2 |
                        {32{i_Type_1 == `FPType_QNaN}} & T_FP_NaN_1 | 
                        {32{i_Type_2 == `FPType_QNaN}} & T_FP_NaN_2 ;

assign Any_SNaN_S3  = ((i_Type_1 == `FPType_SNaN) | (i_Type_2 == `FPType_SNaN) | (i_Type_3 == `FPType_SNaN))                                                              ;
assign Type_NaN_S3  = (Any_SNaN_S3 == 1'd1) ? `FPType_SNaN : `FPType_QNaN                                                                                                 ;
assign Done_S3      = ((ALTFP & Op1_NaN & Op2_NaN & Op3_NaN) | (ALTFP & Op2_NaN & (Op1_NaN | Op3_NaN)) | (ALTFP & Op1_NaN & Op3_NaN) | Op1_NaN | Op2_NaN | Op3_NaN)       ;
assign Result_S3    = {32{ALTFP & Op1_NaN & Op2_NaN & Op3_NaN}} & T_FP_AllNaN_2 |
                        {32{ALTFP & Op2_NaN & (Op1_NaN | Op3_NaN)}} & T_FP_AllNaN_2 | 
                        {32{ALTFP & Op1_NaN & Op3_NaN}} & T_FP_AllNaN_3 | 
                        {32{i_Type_1 == `FPType_SNaN}} & T_FP_NaN_1 |
                        {32{i_Type_2 == `FPType_SNaN}} & T_FP_NaN_2 |
                        {32{i_Type_3 == `FPType_SNaN}} & T_FP_NaN_3 |
                        {32{i_Type_1 == `FPType_QNaN}} & T_FP_NaN_1 | 
                        {32{i_Type_2 == `FPType_QNaN}} & T_FP_NaN_2 | 
                        {32{i_Type_3 == `FPType_QNaN}} & T_FP_NaN_3 ;

assign Any_SNaN_S3H = ((i_Type_1 == `FPType_SNaN) | (i_Type_2 == `FPType_SNaN) | (i_Type_3 == `FPType_SNaN))                                                               ;
assign Type_NaN_S3H = (Any_SNaN_S3H == 1'd1) ? `FPType_SNaN : `FPType_QNaN                                                                                                               ;
assign Done_S3H     = ((ALTFP & Op1_NaN & Op2_NaN & Op3_NaN) | (ALTFP & Op2_NaN & (Op1_NaN | Op3_NaN)) | (ALTFP & Op1_NaN & Op3_NaN) | Op1_NaN | Op2_NaN | Op3_NaN)        ;
assign Result_S3H   = {32{ALTFP & Op1_NaN & Op2_NaN & Op3_NaN}} & T_FPConvertAllNaN_2 |
                        {32{ALTFP & Op2_NaN & (Op1_NaN | Op3_NaN)}} & T_FPConvertAllNaN_2 | 
                        {32{ALTFP & Op1_NaN & Op3_NaN}} & T_FPConvertAllNaN_3 | 
                        {32{i_Type_1 == `FPType_SNaN}} & T_FP_NaN_1 | 
                        {32{i_Type_2 == `FPType_SNaN}} & T_FPConvertNaN_2 | 
                        {32{i_Type_3 == `FPType_SNaN}} & T_FPConvertNaN_3 | 
                        {32{i_Type_1 == `FPType_QNaN}} & T_FP_NaN_1 | 
                        {32{i_Type_2 == `FPType_QNaN}} & T_FPConvertNaN_2 | 
                        {32{i_Type_3 == `FPType_QNaN}} & T_FPConvertNaN_3 ;

assign Done_S4     = (Op1_NaN | Op2_NaN | Op3_NaN | Op4_NaN)                                                                                                              ;
assign Result_S4   = {32{i_Type_1 == `FPType_SNaN}} & T_FPConvertNaN_1 |
                        {32{i_Type_2 == `FPType_SNaN}} & T_FPConvertNaN_2 |
                        {32{i_Type_3 == `FPType_SNaN}} & T_FPConvertNaN_3 |
                        {32{i_Type_4 == `FPType_SNaN}} & T_FPConvertNaN_4 |
                        {32{i_Type_1 == `FPType_QNaN}} & T_FPConvertNaN_1 |
                        {32{i_Type_2 == `FPType_QNaN}} & T_FPConvertNaN_2 |
                        {32{i_Type_3 == `FPType_QNaN}} & T_FPConvertNaN_3 |
                        {32{i_Type_4 == `FPType_QNaN}} & T_FPConvertNaN_4 ;

always @(*) begin
    case(i_Operand_Num)
        2'b00 : o_FP_Result = Result_S2  ;
        2'b01 : o_FP_Result = Result_S3  ;
        2'b10 : o_FP_Result = Result_S3H ;
        2'b11 : o_FP_Result = Result_S4  ;
        default : o_FP_Result = Result_S3  ;
    endcase
end

always @(*) begin
    case(i_Operand_Num)
        2'b00 : o_Done = Done_S2  ;
        2'b01 : o_Done = Done_S3  ;
        2'b10 : o_Done = Done_S3H ;
        2'b11 : o_Done = Done_S4  ;
        default : o_Done = Done_S3  ;
    endcase
end

C1_FPProcessNaN u_FPProcessNaN_1(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_1 ),
    .i_Type         ( i_Type_1       ),
    .i_FPNumber     ( i_FPNumber_1   ),
    .o_FP_NaN       ( T_FP_NaN_1     )
);

C1_FPProcessNaN u_FPProcessNaN_1_TypeNaN(
    .i_FPCR_AH      ( i_FPCR_AH         ),
    .i_FPCR_DN      ( i_FPCR_DN         ),
    .i_Data_Width   ( i_Data_Width_1    ),
    .i_Type         ( i_Type_1          ),
    .i_FPNumber     ( i_FPNumber_1      ),
    .o_FP_NaN       ( T_FP_AllNaN_1     )
);

C1_FPConvertNaN u_FPConvertNaN_1(
    .i_In_Data_Width      ( i_Data_Width_1       ),
    .i_Output_Data_Width  ( 1'd1                 ),
    .i_FPNumber           ( T_FP_NaN_1           ),
    .o_FP_QNaN            ( T_FPConvertNaN_1     )
);

C1_FPProcessNaN u_FPProcessNaN_2(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_2 ),
    .i_Type         ( i_Type_2       ),
    .i_FPNumber     ( i_FPNumber_2   ),
    .o_FP_NaN       ( T_FP_NaN_2     )
);

C1_FPProcessNaN u_FPProcessNaN_2_TypeNaN(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_2 ),
    .i_Type         ( i_Type_2       ),
    .i_FPNumber     ( i_FPNumber_2   ),
    .o_FP_NaN       ( T_FP_AllNaN_2  )
);

C1_FPConvertNaN u_FPConvertNaN_2(
    .i_In_Data_Width      ( i_Data_Width_2       ),
    .i_Output_Data_Width  ( 1'd1                 ),
    .i_FPNumber           ( T_FP_NaN_2           ),
    .o_FP_QNaN            ( T_FPConvertNaN_2     )
);

C1_FPConvertNaN u_FPConvertNaN_2_TypeNaN(
    .i_In_Data_Width      ( i_Data_Width_2       ),
    .i_Output_Data_Width  ( 1'd1                 ),
    .i_FPNumber           ( T_FP_AllNaN_2        ),
    .o_FP_QNaN            ( T_FPConvertAllNaN_2  )
);

C1_FPProcessNaN u_FPProcessNaN_3(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_3 ),
    .i_Type         ( i_Type_3       ),
    .i_FPNumber     ( i_FPNumber_3   ),
    .o_FP_NaN       ( T_FP_NaN_3     )
);

C1_FPProcessNaN u_FPProcessNaN_3_TypeNaN(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_3 ),
    .i_Type         ( i_Type_3       ),
    .i_FPNumber     ( i_FPNumber_3   ),
    .o_FP_NaN       ( T_FP_AllNaN_3  )
);

C1_FPConvertNaN u_FPConvertNaN_3(
    .i_In_Data_Width      ( i_Data_Width_3       ),
    .i_Output_Data_Width  ( 1'd1                 ),
    .i_FPNumber           ( T_FP_NaN_3           ),
    .o_FP_QNaN            ( T_FPConvertNaN_3     )
);

C1_FPConvertNaN u_FPConvertNaN_3_TypeNaN(
    .i_In_Data_Width      ( i_Data_Width_3       ),
    .i_Output_Data_Width  ( 1'd1                 ),
    .i_FPNumber           ( T_FP_AllNaN_3        ),
    .o_FP_QNaN            ( T_FPConvertAllNaN_3  )
);

C1_FPProcessNaN u_FPProcessNaN_4(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_4 ),
    .i_Type         ( i_Type_4       ),
    .i_FPNumber     ( i_FPNumber_4   ),
    .o_FP_NaN       ( T_FP_NaN_4     )
);

C1_FPProcessNaN u_FPProcessNaN_4_TypeNaN(
    .i_FPCR_AH      ( i_FPCR_AH      ),
    .i_FPCR_DN      ( i_FPCR_DN      ),
    .i_Data_Width   ( i_Data_Width_4 ),
    .i_Type         ( i_Type_4       ),
    .i_FPNumber     ( i_FPNumber_4   ),
    .o_FP_NaN       ( T_FP_AllNaN_4  )
);

C1_FPConvertNaN u_FPConvertNaN_4(
    .i_In_Data_Width      ( i_Data_Width_4       ),
    .i_Output_Data_Width  ( 1'd1                 ),
    .i_FPNumber           ( T_FP_NaN_4           ),
    .o_FP_QNaN            ( T_FPConvertNaN_4     )
);


endmodule