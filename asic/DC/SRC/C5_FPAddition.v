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

    input                      i_FuseAdd_SelfAdd      ,
    input                      i_Temp_Sign1           ,
    input                      i_Temp_Sign2           ,
    input           [  9:0]    i_Temp_Expo1           ,
    input           [  9:0]    i_Temp_Expo2           ,
    input           [ 47:0]    i_Temp_Mant1           ,
    input           [ 47:0]    i_Temp_Mant2           ,
    output                     o_Temp_Sign            ,
    output          [  9:0]    o_Temp_Expo            ,
    output          [ 72:0]    o_Temp_Mant            ,

	output          [ 48:0]    o_Sum_Mant		      ,
	output          [  7:0]	   o_Sum_Expo		      ,
	output                	   o_Sum_Sign		     
);

wire signed [  9:0]  Temp_Expo1;
wire signed [  9:0]  Temp_Expo2;
wire [ 7:0] 	Exp_Diff	 ;
wire [ 7:0] 	Sum_Sign	 ;
wire [47:0] 	Max_Mant	 ;
wire [47:0] 	Min_Mant	 ;
wire [47:0] 	Neg_Min_Mant ;
wire [48:0] 	Neg_Min      ;
wire [24:0]		Sum_Mant	 ;

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

C5_CLA_72 u_C5_CLA_72(
    .i_Cin      ( Fuse_is_Comp          ),
    .i_Addnum1  ( Fuse_Max_Mant         ),
    .i_Addnum2  ( Fuse_Neg_Min_Mant     ),
    .o_Cout     ( Fuse_C_Reslt          ),
    .o_Sum      ( Fuse_Sum_Reslt        ),
    .o_Sum_All  ( Fuse_Fin_Result       )
);

assign Temp_Expo1    = i_Temp_Expo1;
assign Temp_Expo2    = i_Temp_Expo2;
assign is_Expo1_Max  = (i_Expo1 > i_Expo2) ? 1'd1 : 1'd0 						;
assign is_Mant1_Max  = (i_Expo1 == i_Expo2 & i_Mant1 >= i_Mant2) ? 1'd1 : 1'd0 ;
assign is_Num1_Max   = (is_Expo1_Max | is_Mant1_Max) ? 1'd1 : 1'd0 				;
assign Sign_Max	     = is_Num1_Max ? i_Sign1 : i_Sign2 							;
assign Expo_Max	     = is_Num1_Max ? i_Expo1 : i_Expo2 							;
assign Mant_Max	     = is_Num1_Max ? i_Mant1 : i_Mant2 							;
assign Sign_Min	     = is_Num1_Max ? i_Sign2 : i_Sign1 							;
assign Expo_Min	     = is_Num1_Max ? i_Expo2 : i_Expo1 							;
assign Mant_Min	     = is_Num1_Max ? i_Mant2 : i_Mant1 							;
assign is_Comp		 = i_Sign1 ^ i_Sign2										;

assign Exp_Diff      = Expo_Max - Expo_Min 										;
assign Max_Mant      = {Mant_Max,24'd0}											;
// assign Min_Mant   = (Exp_Diff <= 48) ? {Mant_Min,24'd0} >> Exp_Diff : 48'd0 	;
assign Min_Mant      = {Mant_Min,24'd0} >> Exp_Diff  						    ;
assign Neg_Min_Mant  = ~Min_Mant + 1 						    				;
assign Neg_Min	     = Max_Mant - Min_Mant										;
assign Mant_Com		 = Mant_Max + Neg_Min_Mant[47:24]							;

assign Sum_Mant   	 = is_Comp ? {1'd0,Mant_Com} : Mant_Max + Min_Mant[47:24]	;
assign o_Sum_Mant 	 = is_Comp ? {Sum_Mant,Neg_Min_Mant[23:0]} : {Sum_Mant,Min_Mant[23:0]}		;
assign o_Sum_Expo	 = Expo_Max													;
assign o_Sum_Sign	 = Sign_Max													;
    

assign Fuse_is_Expo1_Max     = (Temp_Expo1 > Temp_Expo2) ? 1'd1 : 1'd0 						            ;
assign Fuse_is_Mant1_Max     = (Temp_Expo1 == Temp_Expo2 & i_Temp_Mant1 >= i_Temp_Mant2) ? 1'd1 : 1'd0 ;
assign Fuse_is_Num1_Max      = (Fuse_is_Expo1_Max | Fuse_is_Mant1_Max) ? 1'd1 : 1'd0 				        ;
assign Fuse_Sign_Max	     = Fuse_is_Num1_Max ? i_Temp_Sign1 : i_Temp_Sign2 							    ;
assign Fuse_Expo_Max	     = Fuse_is_Num1_Max ? Temp_Expo1 : Temp_Expo2 							    ;
assign Fuse_Mant_Max	     = Fuse_is_Num1_Max ? i_Temp_Mant1 : i_Temp_Mant2 							    ;
assign Fuse_Sign_Min	     = Fuse_is_Num1_Max ? i_Temp_Sign2 : i_Temp_Sign1 							    ;
assign Fuse_Expo_Min	     = Fuse_is_Num1_Max ? Temp_Expo2 : Temp_Expo1 							    ;
assign Fuse_Mant_Min	     = Fuse_is_Num1_Max ? i_Temp_Mant2 : i_Temp_Mant1 							    ;
assign Fuse_is_Comp		     = i_Temp_Sign1 ^ i_Temp_Sign2										            ;

assign Fuse_Exp_Diff         = Fuse_Expo_Max - Fuse_Expo_Min 										        ;
assign Fuse_Max_Mant         = {Fuse_Mant_Max,24'd0}											            ;
assign Fuse_Min_Mant         = {Fuse_Mant_Min,24'd0} >> Fuse_Exp_Diff  						                ;
assign Fuse_Neg_Min_Mant     = is_Comp ? ~Fuse_Min_Mant : Fuse_Min_Mant	    				                ;
// assign o_Temp_Mant 	         = {Fuse_C_Reslt,Fuse_Sum_Reslt}		                                        ;
// assign o_Temp_Mant[72]       = Fuse_C_Reslt		                                        ;

assign Fuse_Sum_Reslt_Copy   = Fuse_Sum_Reslt ;
assign Fuse_C_Reslt_Copy     = Fuse_C_Reslt   ;
// assign Fuse_Fin_Result       = {Fuse_C_Reslt_Copy,Fuse_Sum_Reslt_Copy}                                                ;
assign o_Temp_Mant 	         = Fuse_Fin_Result		                                        ;

assign o_Temp_Expo	         = Fuse_Expo_Max											                    ;
assign o_Temp_Sign	         = Fuse_Sign_Max											                    ;




endmodule
