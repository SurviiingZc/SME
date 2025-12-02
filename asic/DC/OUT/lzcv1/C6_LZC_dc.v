/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : R-2020.09-SP5
// Date      : Sun Oct 26 23:21:36 2025
/////////////////////////////////////////////////////////////


module C6_LZC_dc ( clk, rst_n, in, o_count );
  input [48:0] in;
  output [5:0] o_count;
  input clk, rst_n;
  wire   n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148,
         n149, n150, n151, n152, n153, n154, n155, n156, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n185, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195, n196, n197, n198, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n221, n222, n223, n224, n225,
         n226, n227, n228, n229, n230, n231, n232, n233, n234, n235, n236,
         n237, n238, n239, n240, n241, n242, n243, n244, n245, n246, n247,
         n248, n249, n250, n251, n252, n253, n254;
  wire   [48:1] in_r;
  wire   [5:0] count_w;

  DFCNQD1BWP7T35P140 in_r_reg_48_ ( .D(in[48]), .CP(clk), .CDN(n248), .Q(
        in_r[48]) );
  DFCNQD1BWP7T35P140 in_r_reg_47_ ( .D(in[47]), .CP(clk), .CDN(n248), .Q(
        in_r[47]) );
  DFCNQD1BWP7T35P140 in_r_reg_46_ ( .D(in[46]), .CP(clk), .CDN(n248), .Q(
        in_r[46]) );
  DFCNQD1BWP7T35P140 in_r_reg_45_ ( .D(in[45]), .CP(clk), .CDN(n248), .Q(
        in_r[45]) );
  DFCNQD1BWP7T35P140 in_r_reg_44_ ( .D(in[44]), .CP(clk), .CDN(n248), .Q(
        in_r[44]) );
  DFCNQD1BWP7T35P140 in_r_reg_43_ ( .D(in[43]), .CP(clk), .CDN(n248), .Q(
        in_r[43]) );
  DFCNQD1BWP7T35P140 in_r_reg_42_ ( .D(in[42]), .CP(clk), .CDN(n248), .Q(
        in_r[42]) );
  DFCNQD1BWP7T35P140 in_r_reg_41_ ( .D(in[41]), .CP(clk), .CDN(n248), .Q(
        in_r[41]) );
  DFCNQD1BWP7T35P140 in_r_reg_40_ ( .D(in[40]), .CP(clk), .CDN(n249), .Q(
        in_r[40]) );
  DFCNQD1BWP7T35P140 in_r_reg_39_ ( .D(in[39]), .CP(clk), .CDN(n249), .Q(
        in_r[39]) );
  DFCNQD1BWP7T35P140 in_r_reg_38_ ( .D(in[38]), .CP(clk), .CDN(n249), .Q(
        in_r[38]) );
  DFCNQD1BWP7T35P140 in_r_reg_37_ ( .D(in[37]), .CP(clk), .CDN(n249), .Q(
        in_r[37]) );
  DFCNQD1BWP7T35P140 in_r_reg_36_ ( .D(in[36]), .CP(clk), .CDN(n249), .Q(
        in_r[36]) );
  DFCNQD1BWP7T35P140 in_r_reg_35_ ( .D(in[35]), .CP(clk), .CDN(n249), .Q(
        in_r[35]) );
  DFCNQD1BWP7T35P140 in_r_reg_34_ ( .D(in[34]), .CP(clk), .CDN(n249), .Q(
        in_r[34]) );
  DFCNQD1BWP7T35P140 in_r_reg_33_ ( .D(in[33]), .CP(clk), .CDN(n249), .Q(
        in_r[33]) );
  DFCNQD1BWP7T35P140 in_r_reg_32_ ( .D(in[32]), .CP(clk), .CDN(n250), .Q(
        in_r[32]) );
  DFCNQD1BWP7T35P140 in_r_reg_31_ ( .D(in[31]), .CP(clk), .CDN(n250), .Q(
        in_r[31]) );
  DFCNQD1BWP7T35P140 in_r_reg_30_ ( .D(in[30]), .CP(clk), .CDN(n250), .Q(
        in_r[30]) );
  DFCNQD1BWP7T35P140 in_r_reg_29_ ( .D(in[29]), .CP(clk), .CDN(n250), .Q(
        in_r[29]) );
  DFCNQD1BWP7T35P140 in_r_reg_28_ ( .D(in[28]), .CP(clk), .CDN(n250), .Q(
        in_r[28]) );
  DFCNQD1BWP7T35P140 in_r_reg_27_ ( .D(in[27]), .CP(clk), .CDN(n250), .Q(
        in_r[27]) );
  DFCNQD1BWP7T35P140 in_r_reg_26_ ( .D(in[26]), .CP(clk), .CDN(n250), .Q(
        in_r[26]) );
  DFCNQD1BWP7T35P140 in_r_reg_25_ ( .D(in[25]), .CP(clk), .CDN(n250), .Q(
        in_r[25]) );
  DFCNQD1BWP7T35P140 in_r_reg_24_ ( .D(in[24]), .CP(clk), .CDN(n251), .Q(
        in_r[24]) );
  DFCNQD1BWP7T35P140 in_r_reg_23_ ( .D(in[23]), .CP(clk), .CDN(n251), .Q(
        in_r[23]) );
  DFCNQD1BWP7T35P140 in_r_reg_22_ ( .D(in[22]), .CP(clk), .CDN(n251), .Q(
        in_r[22]) );
  DFCNQD1BWP7T35P140 in_r_reg_21_ ( .D(in[21]), .CP(clk), .CDN(n251), .Q(
        in_r[21]) );
  DFCNQD1BWP7T35P140 in_r_reg_20_ ( .D(in[20]), .CP(clk), .CDN(n251), .Q(
        in_r[20]) );
  DFCNQD1BWP7T35P140 in_r_reg_19_ ( .D(in[19]), .CP(clk), .CDN(n251), .Q(
        in_r[19]) );
  DFCNQD1BWP7T35P140 in_r_reg_18_ ( .D(in[18]), .CP(clk), .CDN(n251), .Q(
        in_r[18]) );
  DFCNQD1BWP7T35P140 in_r_reg_17_ ( .D(in[17]), .CP(clk), .CDN(n251), .Q(
        in_r[17]) );
  DFCNQD1BWP7T35P140 in_r_reg_16_ ( .D(in[16]), .CP(clk), .CDN(n252), .Q(
        in_r[16]) );
  DFCNQD1BWP7T35P140 o_count_reg_5_ ( .D(count_w[5]), .CP(clk), .CDN(n252), 
        .Q(o_count[5]) );
  DFCNQD1BWP7T35P140 in_r_reg_15_ ( .D(in[15]), .CP(clk), .CDN(n252), .Q(
        in_r[15]) );
  DFCNQD1BWP7T35P140 in_r_reg_14_ ( .D(in[14]), .CP(clk), .CDN(n252), .Q(
        in_r[14]) );
  DFCNQD1BWP7T35P140 in_r_reg_13_ ( .D(in[13]), .CP(clk), .CDN(n252), .Q(
        in_r[13]) );
  DFCNQD1BWP7T35P140 in_r_reg_12_ ( .D(in[12]), .CP(clk), .CDN(n252), .Q(
        in_r[12]) );
  DFCNQD1BWP7T35P140 in_r_reg_11_ ( .D(in[11]), .CP(clk), .CDN(n252), .Q(
        in_r[11]) );
  DFCNQD1BWP7T35P140 in_r_reg_10_ ( .D(in[10]), .CP(clk), .CDN(n252), .Q(
        in_r[10]) );
  DFCNQD1BWP7T35P140 in_r_reg_9_ ( .D(in[9]), .CP(clk), .CDN(n253), .Q(in_r[9]) );
  DFCNQD1BWP7T35P140 in_r_reg_8_ ( .D(in[8]), .CP(clk), .CDN(n253), .Q(in_r[8]) );
  DFCNQD1BWP7T35P140 in_r_reg_7_ ( .D(in[7]), .CP(clk), .CDN(n253), .Q(in_r[7]) );
  DFCNQD1BWP7T35P140 in_r_reg_6_ ( .D(in[6]), .CP(clk), .CDN(n253), .Q(in_r[6]) );
  DFCNQD1BWP7T35P140 in_r_reg_5_ ( .D(in[5]), .CP(clk), .CDN(n253), .Q(in_r[5]) );
  DFCNQD1BWP7T35P140 in_r_reg_4_ ( .D(in[4]), .CP(clk), .CDN(n253), .Q(in_r[4]) );
  DFCNQD1BWP7T35P140 in_r_reg_3_ ( .D(in[3]), .CP(clk), .CDN(n253), .Q(in_r[3]) );
  DFCNQD1BWP7T35P140 in_r_reg_2_ ( .D(in[2]), .CP(clk), .CDN(n253), .Q(in_r[2]) );
  DFCNQD1BWP7T35P140 in_r_reg_1_ ( .D(in[1]), .CP(clk), .CDN(n254), .Q(in_r[1]) );
  DFCNQD1BWP7T35P140 o_count_reg_1_ ( .D(count_w[1]), .CP(clk), .CDN(n254), 
        .Q(o_count[1]) );
  DFCNQD1BWP7T35P140 o_count_reg_2_ ( .D(count_w[2]), .CP(clk), .CDN(n254), 
        .Q(o_count[2]) );
  DFCNQD1BWP7T35P140 o_count_reg_3_ ( .D(count_w[3]), .CP(clk), .CDN(n254), 
        .Q(o_count[3]) );
  DFCNQD1BWP7T35P140 o_count_reg_0_ ( .D(count_w[0]), .CP(clk), .CDN(n254), 
        .Q(o_count[0]) );
  DFCNQD1BWP7T35P140 o_count_reg_4_ ( .D(count_w[4]), .CP(clk), .CDN(n254), 
        .Q(o_count[4]) );
  OA211D0BWP7T35P140 U146 ( .A1(n219), .A2(n218), .B(n217), .C(n216), .Z(n230)
         );
  OA31D0BWP7T35P140 U147 ( .A1(in_r[5]), .A2(in_r[4]), .A3(n158), .B(n157), 
        .Z(n178) );
  DEL025D1BWP7T35P140 U150 ( .I(rst_n), .Z(n250) );
  DEL025D1BWP7T35P140 U151 ( .I(rst_n), .Z(n248) );
  DEL025D1BWP7T35P140 U153 ( .I(rst_n), .Z(n252) );
  DEL025D1BWP7T35P140 U154 ( .I(rst_n), .Z(n253) );
  NR2D1BWP7T35P140 U155 ( .A1(in_r[30]), .A2(in_r[31]), .ZN(n217) );
  NR2D1BWP7T35P140 U156 ( .A1(in_r[26]), .A2(in_r[27]), .ZN(n215) );
  ND3D1BWP7T35P140 U158 ( .A1(n217), .A2(n215), .A3(n141), .ZN(n159) );
  NR4D0BWP7T35P140 U159 ( .A1(in_r[46]), .A2(in_r[47]), .A3(in_r[45]), .A4(
        in_r[44]), .ZN(n224) );
  OR2D1BWP7T35P140 U160 ( .A1(in_r[42]), .A2(in_r[43]), .Z(n145) );
  INR4D0BWP7T35P140 U161 ( .A1(n224), .B1(in_r[40]), .B2(in_r[41]), .B3(n145), 
        .ZN(n144) );
  IND2D1BWP7T35P140 U162 ( .A1(in_r[48]), .B1(n144), .ZN(n227) );
  NR4D0BWP7T35P140 U163 ( .A1(in_r[37]), .A2(in_r[36]), .A3(in_r[35]), .A4(
        in_r[34]), .ZN(n228) );
  NR2D1BWP7T35P140 U164 ( .A1(in_r[38]), .A2(in_r[39]), .ZN(n220) );
  ND2D1BWP7T35P140 U165 ( .A1(n228), .A2(n220), .ZN(n246) );
  OR3D1BWP7T35P140 U166 ( .A1(in_r[33]), .A2(in_r[32]), .A3(n246), .Z(n160) );
  ND2D1BWP7T35P140 U169 ( .A1(n216), .A2(n142), .ZN(n151) );
  NR2D1BWP7T35P140 U170 ( .A1(n159), .A2(n151), .ZN(n243) );
  INVD1BWP7T35P140 U171 ( .I(n243), .ZN(n171) );
  NR4D0BWP7T35P140 U172 ( .A1(in_r[21]), .A2(in_r[20]), .A3(in_r[18]), .A4(
        in_r[19]), .ZN(n238) );
  NR2D1BWP7T35P140 U173 ( .A1(in_r[22]), .A2(in_r[23]), .ZN(n214) );
  ND2D1BWP7T35P140 U174 ( .A1(n238), .A2(n214), .ZN(n242) );
  NR2D1BWP7T35P140 U176 ( .A1(in_r[6]), .A2(in_r[7]), .ZN(n157) );
  NR2D1BWP7T35P140 U177 ( .A1(in_r[5]), .A2(in_r[4]), .ZN(n138) );
  NR2D1BWP7T35P140 U178 ( .A1(in_r[3]), .A2(in_r[2]), .ZN(n158) );
  ND2D1BWP7T35P140 U179 ( .A1(n138), .A2(n158), .ZN(n239) );
  INR2D1BWP7T35P140 U180 ( .A1(n157), .B1(n239), .ZN(n156) );
  NR3D0BWP7T35P140 U181 ( .A1(in_r[17]), .A2(in_r[16]), .A3(n242), .ZN(n172)
         );
  ND2D1BWP7T35P140 U182 ( .A1(n243), .A2(n172), .ZN(n169) );
  OR4D1BWP7T35P140 U183 ( .A1(in_r[13]), .A2(in_r[12]), .A3(in_r[14]), .A4(
        in_r[15]), .Z(n205) );
  OR2D1BWP7T35P140 U184 ( .A1(in_r[9]), .A2(in_r[8]), .Z(n139) );
  NR2D1BWP7T35P140 U185 ( .A1(in_r[10]), .A2(in_r[11]), .ZN(n140) );
  INVD1BWP7T35P140 U186 ( .I(n140), .ZN(n233) );
  NR3D0BWP7T35P140 U187 ( .A1(n205), .A2(n139), .A3(n233), .ZN(n170) );
  IND2D1BWP7T35P140 U188 ( .A1(n169), .B1(n170), .ZN(n201) );
  INVD1BWP7T35P140 U189 ( .I(n227), .ZN(n161) );
  NR2D1BWP7T35P140 U190 ( .A1(in_r[14]), .A2(in_r[15]), .ZN(n232) );
  OR2D1BWP7T35P140 U191 ( .A1(in_r[12]), .A2(in_r[13]), .Z(n234) );
  AOI32D1BWP7T35P140 U192 ( .A1(n140), .A2(n232), .A3(n139), .B1(n234), .B2(
        n232), .ZN(n175) );
  NR3D0BWP7T35P140 U193 ( .A1(n169), .A2(n205), .A3(n175), .ZN(n153) );
  INVD1BWP7T35P140 U194 ( .I(n141), .ZN(n143) );
  INVD1BWP7T35P140 U195 ( .I(n142), .ZN(n218) );
  AOI32D1BWP7T35P140 U196 ( .A1(n215), .A2(n217), .A3(n143), .B1(n218), .B2(
        n217), .ZN(n167) );
  NR2D1BWP7T35P140 U197 ( .A1(in_r[48]), .A2(n144), .ZN(n222) );
  INVD1BWP7T35P140 U198 ( .I(n222), .ZN(n195) );
  NR2D1BWP7T35P140 U199 ( .A1(in_r[45]), .A2(in_r[44]), .ZN(n146) );
  AO211D1BWP7T35P140 U200 ( .A1(n146), .A2(n145), .B(in_r[46]), .C(in_r[47]), 
        .Z(n163) );
  INVD1BWP7T35P140 U201 ( .I(in_r[41]), .ZN(n147) );
  OAI21D1BWP7T35P140 U202 ( .A1(in_r[42]), .A2(n147), .B(n224), .ZN(n150) );
  OAI22D1BWP7T35P140 U205 ( .A1(in_r[43]), .A2(n150), .B1(in_r[47]), .B2(n149), 
        .ZN(n196) );
  INVD1BWP7T35P140 U206 ( .I(n196), .ZN(n164) );
  NR2D1BWP7T35P140 U207 ( .A1(n163), .A2(n164), .ZN(n223) );
  ND2D1BWP7T35P140 U208 ( .A1(n224), .A2(n223), .ZN(n221) );
  OAI22D1BWP7T35P140 U209 ( .A1(n151), .A2(n167), .B1(n195), .B2(n221), .ZN(
        n152) );
  AOI211D0BWP7T35P140 U210 ( .A1(n161), .A2(n246), .B(n153), .C(n152), .ZN(
        n155) );
  ND2D1BWP7T35P140 U211 ( .A1(n243), .A2(n242), .ZN(n154) );
  OAI211D0BWP7T35P140 U212 ( .A1(n156), .A2(n201), .B(n155), .C(n154), .ZN(
        count_w[3]) );
  INVD1BWP7T35P140 U214 ( .I(n244), .ZN(n168) );
  NR2D1BWP7T35P140 U215 ( .A1(in_r[35]), .A2(in_r[34]), .ZN(n162) );
  OR2D1BWP7T35P140 U216 ( .A1(in_r[37]), .A2(in_r[36]), .Z(n190) );
  ND2D1BWP7T35P140 U217 ( .A1(n161), .A2(n160), .ZN(n247) );
  AOI221D1BWP7T35P140 U218 ( .A1(n162), .A2(n220), .B1(n190), .B2(n220), .C(
        n247), .ZN(n166) );
  AOI211D0BWP7T35P140 U219 ( .A1(n164), .A2(n163), .B(n223), .C(n195), .ZN(
        n165) );
  AOI211D0BWP7T35P140 U220 ( .A1(n168), .A2(n167), .B(n166), .C(n165), .ZN(
        n177) );
  NR2D1BWP7T35P140 U221 ( .A1(n170), .A2(n169), .ZN(n231) );
  NR2D1BWP7T35P140 U222 ( .A1(n172), .A2(n171), .ZN(n213) );
  OR2D1BWP7T35P140 U224 ( .A1(in_r[21]), .A2(in_r[20]), .Z(n181) );
  AOI22D1BWP7T35P140 U226 ( .A1(n231), .A2(n175), .B1(n213), .B2(n174), .ZN(
        n176) );
  OAI211D0BWP7T35P140 U227 ( .A1(n178), .A2(n201), .B(n177), .C(n176), .ZN(
        count_w[1]) );
  INVD1BWP7T35P140 U228 ( .I(n201), .ZN(n180) );
  INVD1BWP7T35P140 U229 ( .I(in_r[5]), .ZN(n179) );
  INR2D1BWP7T35P140 U231 ( .A1(in_r[20]), .B1(in_r[21]), .ZN(n184) );
  INVD0BWP7T35P140 U232 ( .I(in_r[18]), .ZN(n182) );
  AOI211D0BWP7T35P140 U233 ( .A1(in_r[17]), .A2(n182), .B(in_r[19]), .C(n181), 
        .ZN(n183) );
  NR3D0BWP7T35P140 U234 ( .A1(n184), .A2(n183), .A3(in_r[22]), .ZN(n185) );
  NR2D1BWP7T35P140 U235 ( .A1(n185), .A2(in_r[23]), .ZN(n200) );
  INVD1BWP7T35P140 U236 ( .I(in_r[29]), .ZN(n188) );
  INVD0BWP7T35P140 U237 ( .I(in_r[26]), .ZN(n186) );
  AOI21D1BWP7T35P140 U238 ( .A1(in_r[25]), .A2(n186), .B(in_r[27]), .ZN(n187)
         );
  AOI221D1BWP7T35P140 U239 ( .A1(in_r[28]), .A2(n188), .B1(n187), .B2(n188), 
        .C(in_r[30]), .ZN(n189) );
  NR3D0BWP7T35P140 U240 ( .A1(in_r[31]), .A2(n189), .A3(n244), .ZN(n199) );
  INVD0BWP7T35P140 U241 ( .I(in_r[34]), .ZN(n191) );
  AOI211D0BWP7T35P140 U242 ( .A1(in_r[33]), .A2(n191), .B(in_r[35]), .C(n190), 
        .ZN(n194) );
  INR2D1BWP7T35P140 U243 ( .A1(in_r[36]), .B1(in_r[37]), .ZN(n193) );
  INVD1BWP7T35P140 U244 ( .I(in_r[39]), .ZN(n192) );
  OAI31D1BWP7T35P140 U245 ( .A1(in_r[38]), .A2(n194), .A3(n193), .B(n192), 
        .ZN(n197) );
  AOI211D0BWP7T35P140 U247 ( .A1(n213), .A2(n200), .B(n199), .C(n198), .ZN(
        n211) );
  NR3D0BWP7T35P140 U248 ( .A1(in_r[6]), .A2(in_r[7]), .A3(n201), .ZN(n241) );
  INVD1BWP7T35P140 U249 ( .I(in_r[2]), .ZN(n202) );
  AOI211D0BWP7T35P140 U250 ( .A1(in_r[1]), .A2(n202), .B(in_r[5]), .C(in_r[3]), 
        .ZN(n209) );
  INVD0BWP7T35P140 U251 ( .I(in_r[13]), .ZN(n203) );
  AOI21D1BWP7T35P140 U252 ( .A1(in_r[12]), .A2(n203), .B(in_r[14]), .ZN(n207)
         );
  INVD0BWP7T35P140 U253 ( .I(in_r[10]), .ZN(n204) );
  AO21D1BWP7T35P140 U254 ( .A1(in_r[9]), .A2(n204), .B(in_r[11]), .Z(n206) );
  OAI22D1BWP7T35P140 U255 ( .A1(in_r[15]), .A2(n207), .B1(n206), .B2(n205), 
        .ZN(n208) );
  AOI22D1BWP7T35P140 U256 ( .A1(n241), .A2(n209), .B1(n231), .B2(n208), .ZN(
        n210) );
  OAI211D0BWP7T35P140 U257 ( .A1(in_r[7]), .A2(n212), .B(n211), .C(n210), .ZN(
        count_w[0]) );
  ND2D1BWP7T35P140 U258 ( .A1(n214), .A2(n213), .ZN(n237) );
  INVD1BWP7T35P140 U259 ( .I(n215), .ZN(n219) );
  INVD1BWP7T35P140 U260 ( .I(n220), .ZN(n226) );
  OAI211D0BWP7T35P140 U261 ( .A1(n224), .A2(n223), .B(n222), .C(n221), .ZN(
        n225) );
  OAI31D1BWP7T35P140 U262 ( .A1(n228), .A2(n227), .A3(n226), .B(n225), .ZN(
        n229) );
  AOI211D0BWP7T35P140 U263 ( .A1(n241), .A2(n239), .B(n230), .C(n229), .ZN(
        n236) );
  OAI211D0BWP7T35P140 U264 ( .A1(n234), .A2(n233), .B(n232), .C(n231), .ZN(
        n235) );
  OAI211D0BWP7T35P140 U265 ( .A1(n238), .A2(n237), .B(n236), .C(n235), .ZN(
        count_w[2]) );
  INVD1BWP7T35P140 U266 ( .I(n239), .ZN(n240) );
  AOI22D1BWP7T35P140 U267 ( .A1(n243), .A2(n242), .B1(n241), .B2(n240), .ZN(
        n245) );
  OAI211D0BWP7T35P140 U268 ( .A1(n247), .A2(n246), .B(n245), .C(n244), .ZN(
        count_w[4]) );
  INVD0BWP7T35P140 U148 ( .I(in_r[45]), .ZN(n148) );
  AOI21D0BWP7T35P140 U149 ( .A1(in_r[44]), .A2(n148), .B(in_r[46]), .ZN(n149)
         );
  NR2D0BWP7T35P140 U152 ( .A1(in_r[29]), .A2(in_r[28]), .ZN(n142) );
  NR2D0BWP7T35P140 U157 ( .A1(in_r[25]), .A2(in_r[24]), .ZN(n141) );
  NR2D0BWP7T35P140 U167 ( .A1(in_r[18]), .A2(in_r[19]), .ZN(n173) );
  NR2D0BWP7T35P140 U168 ( .A1(n227), .A2(n160), .ZN(n216) );
  OAI22D0BWP7T35P140 U175 ( .A1(n197), .A2(n247), .B1(n196), .B2(n195), .ZN(
        n198) );
  OAI21D0BWP7T35P140 U203 ( .A1(n173), .A2(n181), .B(n214), .ZN(n174) );
  OAI21D0BWP7T35P140 U204 ( .A1(n159), .A2(n218), .B(n216), .ZN(n244) );
  AOI32D0BWP7T35P140 U213 ( .A1(in_r[4]), .A2(n180), .A3(n179), .B1(in_r[6]), 
        .B2(n180), .ZN(n212) );
  BUFFD1BWP7T35P140 U223 ( .I(rst_n), .Z(n254) );
  NR2D0BWP7T35P140 U225 ( .A1(n171), .A2(n242), .ZN(count_w[5]) );
  BUFFD1BWP7T35P140 U230 ( .I(rst_n), .Z(n251) );
  BUFFD1BWP7T35P140 U246 ( .I(rst_n), .Z(n249) );
endmodule

