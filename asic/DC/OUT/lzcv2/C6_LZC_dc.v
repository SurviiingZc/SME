/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP5
// Date      : Mon Oct 27 00:35:17 2025
/////////////////////////////////////////////////////////////


module C6_LZC_dc ( clk, rst_n, in, o_count );
  input [48:0] in;
  output [5:0] o_count;
  input clk, rst_n;
  wire   n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n155, n156, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189;
  wire   [48:0] in_r;
  wire   [5:0] count_w;

  DFCNQD1BWP7T35P140 in_r_reg_48_ ( .D(in[48]), .CP(clk), .CDN(n183), .Q(
        in_r[48]) );
  DFCNQD1BWP7T35P140 in_r_reg_47_ ( .D(in[47]), .CP(clk), .CDN(n183), .Q(
        in_r[47]) );
  DFCNQD1BWP7T35P140 in_r_reg_46_ ( .D(in[46]), .CP(clk), .CDN(n183), .Q(
        in_r[46]) );
  DFCNQD1BWP7T35P140 in_r_reg_45_ ( .D(in[45]), .CP(clk), .CDN(n183), .Q(
        in_r[45]) );
  DFCNQD1BWP7T35P140 in_r_reg_44_ ( .D(in[44]), .CP(clk), .CDN(n183), .Q(
        in_r[44]) );
  DFCNQD1BWP7T35P140 in_r_reg_43_ ( .D(in[43]), .CP(clk), .CDN(n183), .Q(
        in_r[43]) );
  DFCNQD1BWP7T35P140 in_r_reg_42_ ( .D(in[42]), .CP(clk), .CDN(n183), .Q(
        in_r[42]) );
  DFCNQD1BWP7T35P140 in_r_reg_41_ ( .D(in[41]), .CP(clk), .CDN(n184), .Q(
        in_r[41]) );
  DFCNQD1BWP7T35P140 in_r_reg_40_ ( .D(in[40]), .CP(clk), .CDN(n184), .Q(
        in_r[40]) );
  DFCNQD1BWP7T35P140 in_r_reg_39_ ( .D(in[39]), .CP(clk), .CDN(n184), .Q(
        in_r[39]) );
  DFCNQD1BWP7T35P140 in_r_reg_38_ ( .D(in[38]), .CP(clk), .CDN(n184), .Q(
        in_r[38]) );
  DFCNQD1BWP7T35P140 in_r_reg_37_ ( .D(in[37]), .CP(clk), .CDN(n184), .Q(
        in_r[37]) );
  DFCNQD1BWP7T35P140 in_r_reg_36_ ( .D(in[36]), .CP(clk), .CDN(n184), .Q(
        in_r[36]) );
  DFCNQD1BWP7T35P140 in_r_reg_35_ ( .D(in[35]), .CP(clk), .CDN(n184), .Q(
        in_r[35]) );
  DFCNQD1BWP7T35P140 in_r_reg_34_ ( .D(in[34]), .CP(clk), .CDN(n184), .Q(
        in_r[34]) );
  DFCNQD1BWP7T35P140 in_r_reg_33_ ( .D(in[33]), .CP(clk), .CDN(n185), .Q(
        in_r[33]) );
  DFCNQD1BWP7T35P140 in_r_reg_32_ ( .D(in[32]), .CP(clk), .CDN(n185), .Q(
        in_r[32]) );
  DFCNQD1BWP7T35P140 in_r_reg_31_ ( .D(in[31]), .CP(clk), .CDN(n185), .Q(
        in_r[31]) );
  DFCNQD1BWP7T35P140 in_r_reg_30_ ( .D(in[30]), .CP(clk), .CDN(n185), .Q(
        in_r[30]) );
  DFCNQD1BWP7T35P140 in_r_reg_29_ ( .D(in[29]), .CP(clk), .CDN(n185), .Q(
        in_r[29]) );
  DFCNQD1BWP7T35P140 in_r_reg_28_ ( .D(in[28]), .CP(clk), .CDN(n185), .Q(
        in_r[28]) );
  DFCNQD1BWP7T35P140 in_r_reg_27_ ( .D(in[27]), .CP(clk), .CDN(n185), .Q(
        in_r[27]) );
  DFCNQD1BWP7T35P140 in_r_reg_26_ ( .D(in[26]), .CP(clk), .CDN(n185), .Q(
        in_r[26]) );
  DFCNQD1BWP7T35P140 in_r_reg_25_ ( .D(in[25]), .CP(clk), .CDN(n186), .Q(
        in_r[25]) );
  DFCNQD1BWP7T35P140 in_r_reg_24_ ( .D(in[24]), .CP(clk), .CDN(n186), .Q(
        in_r[24]) );
  DFCNQD1BWP7T35P140 in_r_reg_23_ ( .D(in[23]), .CP(clk), .CDN(n186), .Q(
        in_r[23]) );
  DFCNQD1BWP7T35P140 in_r_reg_22_ ( .D(in[22]), .CP(clk), .CDN(n186), .Q(
        in_r[22]) );
  DFCNQD1BWP7T35P140 in_r_reg_21_ ( .D(in[21]), .CP(clk), .CDN(n186), .Q(
        in_r[21]) );
  DFCNQD1BWP7T35P140 in_r_reg_20_ ( .D(in[20]), .CP(clk), .CDN(n186), .Q(
        in_r[20]) );
  DFCNQD1BWP7T35P140 in_r_reg_19_ ( .D(in[19]), .CP(clk), .CDN(n186), .Q(
        in_r[19]) );
  DFCNQD1BWP7T35P140 in_r_reg_18_ ( .D(in[18]), .CP(clk), .CDN(n186), .Q(
        in_r[18]) );
  DFCNQD1BWP7T35P140 in_r_reg_17_ ( .D(in[17]), .CP(clk), .CDN(n187), .Q(
        in_r[17]) );
  DFCNQD1BWP7T35P140 in_r_reg_16_ ( .D(in[16]), .CP(clk), .CDN(n187), .Q(
        in_r[16]) );
  DFCNQD1BWP7T35P140 in_r_reg_15_ ( .D(in[15]), .CP(clk), .CDN(n187), .Q(
        in_r[15]) );
  DFCNQD1BWP7T35P140 in_r_reg_14_ ( .D(in[14]), .CP(clk), .CDN(n187), .Q(
        in_r[14]) );
  DFCNQD1BWP7T35P140 in_r_reg_13_ ( .D(in[13]), .CP(clk), .CDN(n187), .Q(
        in_r[13]) );
  DFCNQD1BWP7T35P140 in_r_reg_12_ ( .D(in[12]), .CP(clk), .CDN(n187), .Q(
        in_r[12]) );
  DFCNQD1BWP7T35P140 in_r_reg_11_ ( .D(in[11]), .CP(clk), .CDN(n187), .Q(
        in_r[11]) );
  DFCNQD1BWP7T35P140 in_r_reg_10_ ( .D(in[10]), .CP(clk), .CDN(n187), .Q(
        in_r[10]) );
  DFCNQD1BWP7T35P140 in_r_reg_9_ ( .D(in[9]), .CP(clk), .CDN(n188), .Q(in_r[9]) );
  DFCNQD1BWP7T35P140 in_r_reg_8_ ( .D(in[8]), .CP(clk), .CDN(n188), .Q(in_r[8]) );
  DFCNQD1BWP7T35P140 in_r_reg_7_ ( .D(in[7]), .CP(clk), .CDN(n188), .Q(in_r[7]) );
  DFCNQD1BWP7T35P140 in_r_reg_6_ ( .D(in[6]), .CP(clk), .CDN(n188), .Q(in_r[6]) );
  DFCNQD1BWP7T35P140 in_r_reg_5_ ( .D(in[5]), .CP(clk), .CDN(n188), .Q(in_r[5]) );
  DFCNQD1BWP7T35P140 in_r_reg_4_ ( .D(in[4]), .CP(clk), .CDN(n188), .Q(in_r[4]) );
  DFCNQD1BWP7T35P140 in_r_reg_3_ ( .D(in[3]), .CP(clk), .CDN(n188), .Q(in_r[3]) );
  DFCNQD1BWP7T35P140 in_r_reg_2_ ( .D(in[2]), .CP(clk), .CDN(n188), .Q(in_r[2]) );
  DFCNQD1BWP7T35P140 in_r_reg_1_ ( .D(in[1]), .CP(clk), .CDN(n189), .Q(in_r[1]) );
  DFCNQD1BWP7T35P140 in_r_reg_0_ ( .D(in[0]), .CP(clk), .CDN(n183), .Q(in_r[0]) );
  DFCNQD1BWP7T35P140 o_count_reg_0_ ( .D(count_w[0]), .CP(clk), .CDN(n189), 
        .Q(o_count[0]) );
  DFCNQD1BWP7T35P140 o_count_reg_1_ ( .D(count_w[1]), .CP(clk), .CDN(n189), 
        .Q(o_count[1]) );
  DFCNQD1BWP7T35P140 o_count_reg_2_ ( .D(count_w[2]), .CP(clk), .CDN(n189), 
        .Q(o_count[2]) );
  DFCNQD1BWP7T35P140 o_count_reg_3_ ( .D(count_w[3]), .CP(clk), .CDN(n189), 
        .Q(o_count[3]) );
  DFCNQD1BWP7T35P140 o_count_reg_4_ ( .D(count_w[4]), .CP(clk), .CDN(n189), 
        .Q(o_count[4]) );
  DFCNQD1BWP7T35P140 o_count_reg_5_ ( .D(count_w[5]), .CP(clk), .CDN(n189), 
        .Q(o_count[5]) );
  AN2D0BWP7T35P140 U141 ( .A1(n127), .A2(n126), .Z(n128) );
  TIELBWP7T35P140 U142 ( .ZN(n98) );
  DEL025D1BWP7T35P140 U143 ( .I(rst_n), .Z(n189) );
  DEL025D1BWP7T35P140 U145 ( .I(rst_n), .Z(n185) );
  DEL025D1BWP7T35P140 U148 ( .I(rst_n), .Z(n188) );
  DEL025D1BWP7T35P140 U149 ( .I(rst_n), .Z(n183) );
  NR2D1BWP7T35P140 U150 ( .A1(in_r[39]), .A2(in_r[40]), .ZN(n83) );
  INVD1BWP7T35P140 U151 ( .I(n83), .ZN(n166) );
  NR3D0BWP7T35P140 U152 ( .A1(in_r[38]), .A2(in_r[37]), .A3(n166), .ZN(n139)
         );
  NR2D1BWP7T35P140 U153 ( .A1(in_r[35]), .A2(in_r[36]), .ZN(n164) );
  ND2D1BWP7T35P140 U154 ( .A1(n139), .A2(n164), .ZN(n77) );
  NR3D0BWP7T35P140 U155 ( .A1(in_r[34]), .A2(in_r[33]), .A3(n77), .ZN(n81) );
  NR2D1BWP7T35P140 U156 ( .A1(in_r[43]), .A2(in_r[44]), .ZN(n116) );
  NR4D0BWP7T35P140 U157 ( .A1(in_r[47]), .A2(in_r[48]), .A3(in_r[45]), .A4(
        in_r[46]), .ZN(n172) );
  NR3D0BWP7T35P140 U159 ( .A1(in_r[42]), .A2(in_r[41]), .A3(n169), .ZN(n82) );
  NR4D0BWP7T35P140 U161 ( .A1(in_r[30]), .A2(in_r[29]), .A3(in_r[31]), .A4(
        in_r[32]), .ZN(n90) );
  NR4D0BWP7T35P140 U162 ( .A1(in_r[27]), .A2(in_r[28]), .A3(in_r[26]), .A4(
        in_r[25]), .ZN(n89) );
  ND2D1BWP7T35P140 U163 ( .A1(n90), .A2(n89), .ZN(n154) );
  NR2D1BWP7T35P140 U164 ( .A1(in_r[23]), .A2(in_r[24]), .ZN(n157) );
  NR2D1BWP7T35P140 U165 ( .A1(in_r[22]), .A2(in_r[21]), .ZN(n155) );
  ND2D1BWP7T35P140 U166 ( .A1(n157), .A2(n155), .ZN(n85) );
  OR3D1BWP7T35P140 U170 ( .A1(in_r[18]), .A2(in_r[17]), .A3(n160), .Z(n97) );
  INVD1BWP7T35P140 U172 ( .I(in_r[46]), .ZN(n79) );
  AOI21D1BWP7T35P140 U173 ( .A1(in_r[45]), .A2(n79), .B(in_r[47]), .ZN(n120)
         );
  INVD1BWP7T35P140 U174 ( .I(n139), .ZN(n80) );
  AOI211D0BWP7T35P140 U175 ( .A1(n164), .A2(in_r[34]), .B(in_r[36]), .C(n80), 
        .ZN(n114) );
  INR2D1BWP7T35P140 U176 ( .A1(n82), .B1(n81), .ZN(n143) );
  ND2D1BWP7T35P140 U177 ( .A1(n83), .A2(in_r[37]), .ZN(n84) );
  OAI22D1BWP7T35P140 U178 ( .A1(n84), .A2(in_r[38]), .B1(in_r[40]), .B2(n83), 
        .ZN(n113) );
  INVD1BWP7T35P140 U179 ( .I(n154), .ZN(n95) );
  INVD0BWP7T35P140 U180 ( .I(in_r[19]), .ZN(n86) );
  AO211D1BWP7T35P140 U181 ( .A1(in_r[18]), .A2(n86), .B(in_r[20]), .C(n85), 
        .Z(n88) );
  IND3D1BWP7T35P140 U182 ( .A1(in_r[22]), .B1(n157), .B2(in_r[21]), .ZN(n87)
         );
  OAI211D0BWP7T35P140 U183 ( .A1(in_r[24]), .A2(n157), .B(n88), .C(n87), .ZN(
        n94) );
  NR2D1BWP7T35P140 U184 ( .A1(in_r[27]), .A2(in_r[28]), .ZN(n159) );
  INR2D1BWP7T35P140 U185 ( .A1(n90), .B1(n89), .ZN(n158) );
  INVD1BWP7T35P140 U186 ( .I(n158), .ZN(n91) );
  AOI211D0BWP7T35P140 U187 ( .A1(n159), .A2(in_r[26]), .B(in_r[28]), .C(n91), 
        .ZN(n93) );
  NR2D1BWP7T35P140 U188 ( .A1(in_r[31]), .A2(in_r[32]), .ZN(n153) );
  NR2D1BWP7T35P140 U189 ( .A1(in_r[30]), .A2(in_r[29]), .ZN(n163) );
  AOI221D1BWP7T35P140 U190 ( .A1(in_r[30]), .A2(n153), .B1(n163), .B2(n153), 
        .C(in_r[32]), .ZN(n92) );
  AOI211D0BWP7T35P140 U191 ( .A1(n95), .A2(n94), .B(n93), .C(n92), .ZN(n111)
         );
  INVD1BWP7T35P140 U192 ( .I(n96), .ZN(n147) );
  ND2D1BWP7T35P140 U193 ( .A1(n147), .A2(n97), .ZN(n152) );
  IND2D1BWP7T35P140 U194 ( .A1(in_r[16]), .B1(count_w[5]), .ZN(n122) );
  INVD1BWP7T35P140 U195 ( .I(in_r[13]), .ZN(n99) );
  AOI211D0BWP7T35P140 U196 ( .A1(in_r[12]), .A2(n99), .B(n98), .C(in_r[14]), 
        .ZN(n110) );
  INVD1BWP7T35P140 U197 ( .I(in_r[9]), .ZN(n101) );
  NR4D0BWP7T35P140 U198 ( .A1(in_r[13]), .A2(in_r[12]), .A3(in_r[14]), .A4(
        in_r[15]), .ZN(n105) );
  NR4D0BWP7T35P140 U199 ( .A1(in_r[10]), .A2(in_r[11]), .A3(in_r[9]), .A4(
        in_r[8]), .ZN(n104) );
  INR2D1BWP7T35P140 U200 ( .A1(n105), .B1(n104), .ZN(n131) );
  INVD1BWP7T35P140 U201 ( .I(in_r[11]), .ZN(n100) );
  OAI211D0BWP7T35P140 U202 ( .A1(in_r[10]), .A2(n101), .B(n131), .C(n100), 
        .ZN(n109) );
  NR2D1BWP7T35P140 U203 ( .A1(in_r[6]), .A2(in_r[7]), .ZN(n130) );
  ND2D1BWP7T35P140 U204 ( .A1(n130), .A2(in_r[4]), .ZN(n102) );
  ND2D1BWP7T35P140 U208 ( .A1(n130), .A2(n125), .ZN(n123) );
  AOI211D0BWP7T35P140 U209 ( .A1(in_r[1]), .A2(n126), .B(in_r[3]), .C(n123), 
        .ZN(n106) );
  NR2D1BWP7T35P140 U210 ( .A1(in_r[3]), .A2(n123), .ZN(n127) );
  ND2D1BWP7T35P140 U211 ( .A1(n127), .A2(n126), .ZN(n103) );
  NR3D0BWP7T35P140 U212 ( .A1(in_r[1]), .A2(in_r[0]), .A3(n103), .ZN(n149) );
  ND2D1BWP7T35P140 U213 ( .A1(n105), .A2(n104), .ZN(n151) );
  NR2D1BWP7T35P140 U214 ( .A1(n149), .A2(n151), .ZN(n145) );
  OAI21D1BWP7T35P140 U215 ( .A1(n107), .A2(n106), .B(n145), .ZN(n108) );
  OAI211D0BWP7T35P140 U216 ( .A1(in_r[15]), .A2(n110), .B(n109), .C(n108), 
        .ZN(n180) );
  OAI22D1BWP7T35P140 U217 ( .A1(n111), .A2(n152), .B1(n122), .B2(n180), .ZN(
        n112) );
  AOI221D1BWP7T35P140 U218 ( .A1(n114), .A2(n143), .B1(n113), .B2(n143), .C(
        n112), .ZN(n119) );
  INVD1BWP7T35P140 U219 ( .I(in_r[43]), .ZN(n117) );
  NR2D1BWP7T35P140 U220 ( .A1(in_r[42]), .A2(in_r[41]), .ZN(n170) );
  INVD1BWP7T35P140 U221 ( .I(n172), .ZN(n115) );
  AO21D1BWP7T35P140 U222 ( .A1(n116), .A2(n170), .B(n115), .Z(n140) );
  AO211D1BWP7T35P140 U223 ( .A1(in_r[42]), .A2(n117), .B(in_r[44]), .C(n140), 
        .Z(n118) );
  OAI211D0BWP7T35P140 U224 ( .A1(in_r[48]), .A2(n120), .B(n119), .C(n118), 
        .ZN(count_w[0]) );
  NR2D1BWP7T35P140 U225 ( .A1(n121), .A2(n158), .ZN(n142) );
  INVD1BWP7T35P140 U226 ( .I(n122), .ZN(n178) );
  INVD1BWP7T35P140 U227 ( .I(n123), .ZN(n124) );
  AOI21D1BWP7T35P140 U228 ( .A1(n145), .A2(n124), .B(n131), .ZN(n137) );
  NR2D1BWP7T35P140 U229 ( .A1(in_r[13]), .A2(in_r[12]), .ZN(n136) );
  OR2D1BWP7T35P140 U230 ( .A1(in_r[14]), .A2(in_r[15]), .Z(n135) );
  INVD1BWP7T35P140 U231 ( .I(n125), .ZN(n129) );
  AOI32D1BWP7T35P140 U232 ( .A1(n130), .A2(n145), .A3(n129), .B1(n128), .B2(
        n145), .ZN(n134) );
  NR2D1BWP7T35P140 U233 ( .A1(in_r[10]), .A2(in_r[11]), .ZN(n132) );
  ND2D1BWP7T35P140 U234 ( .A1(n132), .A2(n131), .ZN(n133) );
  OAI211D0BWP7T35P140 U235 ( .A1(n136), .A2(n135), .B(n134), .C(n133), .ZN(
        n179) );
  ND2D1BWP7T35P140 U236 ( .A1(n180), .A2(n179), .ZN(n177) );
  NR2D1BWP7T35P140 U237 ( .A1(n137), .A2(n177), .ZN(n148) );
  AOI21D1BWP7T35P140 U238 ( .A1(n137), .A2(n177), .B(n148), .ZN(n138) );
  AOI22D1BWP7T35P140 U239 ( .A1(n139), .A2(n143), .B1(n178), .B2(n138), .ZN(
        n141) );
  OAI211D0BWP7T35P140 U240 ( .A1(n142), .A2(n152), .B(n141), .C(n140), .ZN(
        count_w[2]) );
  INVD1BWP7T35P140 U241 ( .I(n143), .ZN(n165) );
  OAI211D0BWP7T35P140 U243 ( .A1(n145), .A2(n148), .B(n178), .C(n144), .ZN(
        n146) );
  OAI211D0BWP7T35P140 U244 ( .A1(n154), .A2(n152), .B(n165), .C(n146), .ZN(
        count_w[3]) );
  OAI31D1BWP7T35P140 U246 ( .A1(in_r[16]), .A2(n151), .A3(n150), .B(n152), 
        .ZN(count_w[4]) );
  INVD1BWP7T35P140 U247 ( .I(n152), .ZN(n176) );
  INVD0BWP7T35P140 U248 ( .I(n153), .ZN(n162) );
  NR2D1BWP7T35P140 U249 ( .A1(n155), .A2(n154), .ZN(n156) );
  AOI22D1BWP7T35P140 U250 ( .A1(n159), .A2(n158), .B1(n157), .B2(n156), .ZN(
        n161) );
  OAI211D0BWP7T35P140 U251 ( .A1(n163), .A2(n162), .B(n161), .C(n160), .ZN(
        n175) );
  NR2D1BWP7T35P140 U252 ( .A1(in_r[38]), .A2(in_r[37]), .ZN(n168) );
  INVD1BWP7T35P140 U253 ( .I(n164), .ZN(n167) );
  AOI211D0BWP7T35P140 U254 ( .A1(n168), .A2(n167), .B(n166), .C(n165), .ZN(
        n174) );
  OR2D1BWP7T35P140 U255 ( .A1(in_r[47]), .A2(in_r[48]), .Z(n171) );
  OAI22D1BWP7T35P140 U256 ( .A1(n172), .A2(n171), .B1(n170), .B2(n169), .ZN(
        n173) );
  AOI211D0BWP7T35P140 U257 ( .A1(n176), .A2(n175), .B(n174), .C(n173), .ZN(
        n182) );
  OAI211D0BWP7T35P140 U258 ( .A1(n180), .A2(n179), .B(n178), .C(n177), .ZN(
        n181) );
  NR2D0BWP7T35P140 U144 ( .A1(in_r[5]), .A2(in_r[4]), .ZN(n125) );
  INVD0BWP7T35P140 U146 ( .I(in_r[2]), .ZN(n126) );
  OAI22D0BWP7T35P140 U147 ( .A1(n102), .A2(in_r[5]), .B1(in_r[7]), .B2(n130), 
        .ZN(n107) );
  NR2D0BWP7T35P140 U158 ( .A1(in_r[19]), .A2(in_r[20]), .ZN(n78) );
  ND2D0BWP7T35P140 U160 ( .A1(n116), .A2(n172), .ZN(n169) );
  ND2D0BWP7T35P140 U167 ( .A1(n121), .A2(n78), .ZN(n160) );
  ND2D0BWP7T35P140 U168 ( .A1(n145), .A2(n148), .ZN(n144) );
  NR2D0BWP7T35P140 U169 ( .A1(n154), .A2(n85), .ZN(n121) );
  ND2D0BWP7T35P140 U171 ( .A1(n81), .A2(n82), .ZN(n96) );
  OAI21D0BWP7T35P140 U205 ( .A1(n149), .A2(n148), .B(n147), .ZN(n150) );
  NR2D0BWP7T35P140 U206 ( .A1(n96), .A2(n97), .ZN(count_w[5]) );
  ND2D0BWP7T35P140 U207 ( .A1(n182), .A2(n181), .ZN(count_w[1]) );
  BUFFD1BWP7T35P140 U242 ( .I(rst_n), .Z(n187) );
  BUFFD1BWP7T35P140 U245 ( .I(rst_n), .Z(n186) );
  BUFFD1BWP7T35P140 U259 ( .I(rst_n), .Z(n184) );
endmodule

