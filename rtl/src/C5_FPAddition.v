`timescale 1ns / 1ps

`ifndef VCS_FSDB
`include "Macro_Definition.v"
`endif

module C5_FPAddition(
	input                      i_Sign1                ,
	input           [  7:0]    i_Expo1                ,
	input           [ 23:0]    i_Mant1                ,
	input                      i_Sign2                ,
	input           [  7:0]    i_Expo2                ,
	input           [ 23:0]    i_Mant2                ,
    input                      i_Widening_SBF         ,
    input           [ 19:0]    i_Exception_Handling   ,
    input                      i_Add_or_Subtract      ,
    input                      i_FuseAdd_SelfAdd      ,
    input                      i_Temp_Sign1           ,
    input                      i_Temp_Sign2           ,
    input           [  9:0]    i_Temp_Expo1           ,
    input           [  9:0]    i_Temp_Expo2           ,
    input           [ 47:0]    i_Temp_Mant1           ,
    input           [ 47:0]    i_Temp_Mant2           ,
    input                      i_sticky_bit           ,
    output                     o_Temp_Sign            ,
    output          [  9:0]    o_Temp_Expo            ,
    output          [ 72:0]    o_Temp_Mant            ,
	output          [ 47:0]    o_Sum_Mant		      ,
	output          [  9:0]	   o_Sum_Expo		      ,
	output                	   o_Sum_Sign		      ,
    output                     o_Sticky_Bit            
);



wire [23:0]     Sticky_Temp  ;
wire signed [  9:0]  Temp_Expo1 ;
wire signed [  9:0]  Temp_Expo2 ;
wire [ 7:0] 	Exp_Diff	 ;
wire [ 7:0] 	Sum_Sign	 ;
wire [47:0] 	Max_Mant	 ;
wire [47:0] 	Min_Mant	 ;
wire [47:0] 	Neg_Min_Mant ;
wire [48:0] 	Neg_Min      ;
wire [24:0]		Sum_Mant	 ;

wire  [ 4:0]    Check_Diff      ;
wire            Mant_Min_Or     ;
wire            Sticky_Bit      ;
wire			is_Num1_Max		;
wire			is_Expo1_Max	;
wire			is_Mant1_Max	;
wire         	Sign_Max    	;
wire  [ 7:0] 	Expo_Max    	;
wire  [23:0] 	Mant_Max    	;
wire         	Sign_Min  		;
wire  [ 7:0] 	Expo_Min  		;
wire  [23:0] 	Mant_Min  		;
wire  [23:0] 	Mant_Com  		;

wire [ 8:0] 	Fuse_Exp_Diff	    ;
wire [71:0] 	Fuse_Max_Mant	    ;
wire [71:0] 	Fuse_Min_Mant	    ;
wire [71:0] 	Fuse_Neg_Min_Mant   ;

wire [71:0] 	Fuse_Sum_Reslt      ;
wire         	Fuse_C_Reslt        ;
wire [71:0] 	Fuse_Sum_Reslt_Copy ;
wire         	Fuse_C_Reslt_Copy   ;
wire [72:0]     Fuse_Fin_Result     ;

wire			Fuse_is_Num1_Max	;
wire			Fuse_is_Expo1_Max	;
wire			Fuse_is_Mant1_Max	;
wire         	Fuse_Sign_Max    	;
wire  [ 8:0] 	Fuse_Expo_Max    	;
wire  [47:0] 	Fuse_Mant_Max    	;
wire         	Fuse_Sign_Min  		;
wire  [ 8:0] 	Fuse_Expo_Min  		;
wire  [47:0] 	Fuse_Mant_Min  		;
wire            is_Comp             ;
wire            Fuse_is_Comp        ;
wire  [ 72:0]   T_Temp_Mant         ;
wire            T_Temp_Sign1        ;
wire            All_Equal           ;
wire [  1:0]    FPCR_RMode          ;

wire            Temp_Sign1        ;
wire            Temp_Sign2        ;
wire [  9:0]    TempExpo1         ;
wire [  9:0]    TempExpo2         ;
wire [ 47:0]    Temp_Mant1        ;
wire [ 47:0]    Temp_Mant2        ;

genvar i;

generate
    for(i = 0 ; i < 24 ; i = i + 1) begin
        assign Sticky_Temp[i] = |Fuse_Mant_Min[i:0];
    end
endgenerate

assign FPCR_RMode       = i_Exception_Handling[16:15]   ;

// C5_CLA_72 u_C5_CLA_72(
//     .i_Cin      ( Fuse_is_Comp          ),
//     .i_Addnum1  ( Fuse_Max_Mant         ),
//     .i_Addnum2  ( Fuse_Neg_Min_Mant     ),
//     .o_Cout     ( Fuse_C_Reslt          ),
//     .o_Sum      ( Fuse_Sum_Reslt        ),
//     .o_Sum_All  ( Fuse_Fin_Result       )
// );

//  | i_Widening_SBF
//  | i_Widening_SBF
//  | i_Widening_SBF
//  | i_Widening_SBF
//  | i_Widening_SBF
//  | i_Widening_SBF

assign Temp_Sign1          = ~(i_FuseAdd_SelfAdd) ? i_Temp_Sign1 : i_Sign1                                              ;
assign Temp_Sign2          = ~(i_FuseAdd_SelfAdd) ? i_Temp_Sign2 : i_Sign2                                              ;
assign TempExpo1           = ~(i_FuseAdd_SelfAdd) ? i_Temp_Expo1 : {2'd0,i_Expo1}                                       ;
assign TempExpo2           = ~(i_FuseAdd_SelfAdd) ? i_Temp_Expo2 : {2'd0,i_Expo2}                                       ;
assign Temp_Mant1          = ~(i_FuseAdd_SelfAdd) ? i_Temp_Mant1 : {i_Mant1,24'd0}                                      ;
assign Temp_Mant2          = ~(i_FuseAdd_SelfAdd) ? i_Temp_Mant2 : {i_Mant2,24'd0}                                      ;



assign Temp_Expo1            = (TempExpo1 == 'd0) ? 9'sd1 : TempExpo1                                 ;
assign Temp_Expo2            = (TempExpo2 == 'd0) ? 9'sd1 : TempExpo2                                 ;
assign Check_Diff            = (Fuse_Exp_Diff > 8'd24 && Fuse_Exp_Diff < 8'd48) ? (Fuse_Exp_Diff - 8'd24) : 5'd0           ;
assign Sticky_Bit            = ((Fuse_Exp_Diff >= 8'd48) & Mant_Min_Or) | 
                                    ((Fuse_Exp_Diff > 8'd24 && Fuse_Exp_Diff < 8'd48) & Sticky_Temp[Check_Diff]) | 
                                    (~i_FuseAdd_SelfAdd & i_sticky_bit)                                                       ;
assign o_Sticky_Bit          = Sticky_Bit | (| o_Temp_Mant[24:0])                                           ;
assign Mant_Min_Or           = |Fuse_Mant_Min                                                               ;
assign Fuse_is_Expo1_Max     = (Temp_Expo1 > Temp_Expo2) ? 1'd1 : 1'd0 						                ;
assign Fuse_is_Mant1_Max     = (Temp_Expo1 == Temp_Expo2 & Temp_Mant1 >= Temp_Mant2) ? 1'd1 : 1'd0      ;
assign Fuse_is_Num1_Max      = (Fuse_is_Expo1_Max | Fuse_is_Mant1_Max) ? 1'd1 : 1'd0 				        ;
assign T_Temp_Sign1          = i_Add_or_Subtract ? Temp_Sign1 : ~Temp_Sign1                             ;
assign All_Equal             = (Temp_Expo1 == Temp_Expo2) & (Temp_Mant1 == Temp_Mant2) & (T_Temp_Sign1 ^ Temp_Sign2);
assign Fuse_Sign_Max	     = Fuse_is_Num1_Max ? T_Temp_Sign1 : Temp_Sign2 							    ;
assign Fuse_Expo_Max	     = Fuse_is_Num1_Max ? Temp_Expo1 : Temp_Expo2 							        ;
assign Fuse_Mant_Max	     = Fuse_is_Num1_Max ? Temp_Mant1 : Temp_Mant2 							    ;
assign Fuse_Sign_Min	     = Fuse_is_Num1_Max ? Temp_Sign2 : T_Temp_Sign1 							    ;
assign Fuse_Expo_Min	     = Fuse_is_Num1_Max ? Temp_Expo2 : Temp_Expo1 							        ;
assign Fuse_Mant_Min	     = Fuse_is_Num1_Max ? Temp_Mant2 : Temp_Mant1 							    ;
assign Fuse_is_Comp		     = T_Temp_Sign1 ^ Temp_Sign2                       				            ;

assign Fuse_Exp_Diff         = Fuse_Expo_Max - Fuse_Expo_Min 										        ;
assign Fuse_Max_Mant         = {Fuse_Mant_Max,24'd0}											            ;
assign Fuse_Min_Mant         = {Fuse_Mant_Min,24'd0} >> Fuse_Exp_Diff  						                ;
assign Fuse_Neg_Min_Mant     = Fuse_is_Comp ? ~Fuse_Min_Mant : Fuse_Min_Mant	    				        ; 

wire sub_carry_in            = Fuse_is_Comp && !Sticky_Bit                                                  ; 
assign T_Temp_Mant           = {1'b0, Fuse_Max_Mant} + {1'b0, Fuse_Neg_Min_Mant} + sub_carry_in             ;
assign o_Temp_Mant           = Fuse_is_Comp ? {1'b0,T_Temp_Mant[71:0]} : T_Temp_Mant                        ;
assign o_Temp_Expo	         = ~All_Equal ? Fuse_Expo_Max : 'd0											    ;
assign o_Temp_Sign	         = ~All_Equal ? Fuse_Sign_Max :	
                                (FPCR_RMode == `Round_Towards_Minus_Infinity) ? 1'd1 : 1'd0	                ;

assign o_Sum_Mant            = o_Temp_Mant[72:25]                                                           ; 
assign o_Sum_Expo            = o_Temp_Expo                                                                  ;
assign o_Sum_Sign            = o_Temp_Sign                                                                  ;


endmodule

