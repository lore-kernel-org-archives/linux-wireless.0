Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:40600 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbeACAox (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 19:44:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        netdev@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH] rtlwifi: rtl8723de: Add firmware for new driver/device
Date: Tue,  2 Jan 2018 18:44:42 -0600
Message-Id: <20180103004442.947-1-Larry.Finger@lwfinger.net> (sfid-20180103_014519_695473_C08B20EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A driver for the RTL8723DE is nearing submission to staging. This commit supplies
the firmware for it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 WHENCE                  |   9 +++++++++
 rtlwifi/rtl8723defw.bin | Bin 0 -> 27726 bytes
 2 files changed, 9 insertions(+)
 create mode 100644 rtlwifi/rtl8723defw.bin

diff --git a/WHENCE b/WHENCE
index 7518a93..a4dc54f 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2469,6 +2469,15 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
 --------------------------------------------------------------------------
 
+Driver: rtl8723de - Realtek 802.11ac WLAN driver for RTL8723DE
+
+Info: Supplied by Vendor at https://github.com/pkshih/rtlwifi_rtl8723de
+File: rtlwifi/rtl8723defw.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
+
+--------------------------------------------------------------------------
+
 Driver: r8723au - Realtek 802.11n WLAN driver for RTL8723AU
 
 Info: Taken from Realtek driver rtl8723A_WiFi_linux_v4.1.3_6044.20121224
diff --git a/rtlwifi/rtl8723defw.bin b/rtlwifi/rtl8723defw.bin
new file mode 100644
index 0000000000000000000000000000000000000000..6d2c95392a947e454d0365d6d982d393a5dfadf6
GIT binary patch
literal 27726
zcmd_Td0<mj+CQG$tc60GOGR*_gfMPETNV{WD2uz4R^u`{YS3b36iD<|TT00Vq=aJO
z)RGo;p!gOY5V3YF4vq_zs^E+Yl~Ko)3noSAk{cl`(j?!{b8b?=nfLvE-#>nT{i?a=
zoagM@bDr%S+J>d;F4gIDDd(Mk&8Wu(`2PJ*sPLQ(6ux}m?4VBg;k|RhzYPdGtQ;h~
zt>qJbDEe)Z|2}-48c##)c`AK%CM{&rLg`v4T?<8c3Y`|v_0x*%V>K9b#uN*Et!9IO
zugRd-8T<9Im~__EJ{F_S+P9Ax{=R)o2Kpk6HA74_>e4gB6nq`_i$q<f!#*gLz8Plv
zrWx@a+6UiZLy<Cb*bwsDhY)<|kby{<la-mF%g)Ifl#cHR<ju~xB7?q{W$5sA@b4w`
z6$FFPXiZ5;?Vm0RDSi9*OG_7ZM*L^hrR#?2M(Xl))w)*wrTQHG1G;B*yLI2|AJ9Ll
ze?kAL{)iwLt*PQ5NA^vw$1^S)onNwHce`G%7x2GeK(T_+Y_V9aRt<(P;Pi!~xmr4t
z9&Iq0Ef^~U^3nIq-(a&*&<)Z?^Z$q6osDvAw7Ar`Y;WJ<z1CNiozDg<9YvAK;Im^(
zBhP;EY^P)8$@X^zL5jEf7dPkXaz8IMl*j|yt?s@%8{4xF7^V+8{zaqpo30}(_u7N0
z@nMd|C)2Ff9R{OUSF*T0JMfDxnA%#OpJ_^!Du<_@Y>&RO*xLSj>ibmWXD5H2>r$-k
zEsA_Rn7Xe%_tIc0)t88l4r>4GWN`6ZmwB&pe2^SLWaaMT=cUT~f~i!G*GNrJ4Cx0`
zy}IlJmh7L5UaRw%bK%EdG&<#}7JEtMD~lz;WsX~)itj(|H3UlJ<JRNW{lAthekz+)
zL?wMqixR+Z+6sMfrK|Ya(l4I<qR}pd_N@_e4c@q2TAY=2vOP0+3>8h!Mn_*y?M7#Y
z_LnM0ooqj4Z6Cz@5$&4eN=Z31c<_mo6#3}Df%3QA=#0^{*tD2Dc1mq+Kh?c0RoJ|E
zklEbMGYlSlC?(~@VEO1J@;4zz<;iyA$xxON&8j(W4Q16F_v-Au4GB?y+p~E?oX?^m
z!PIS*K2jxG7g;PUosmCES_%IS8dVJ2DT+DW-gEeImvxir(D920%f~huUNH@!Y(Jr3
zo;o_HLZ3z{U(s7Dj1(ojwzvyf`lW0#wV#lW5$MMii~p@5H0(iBwjz8H_~IZ28>4?v
zpC&B5ZM7PR$7piolRGzOpXlecw!8X{JnqWQA0=C|!{)BzuHlOWYqpw>BGL~H>z{ov
z71@ol$ioAioq6aR`s1})L(`XH*ze+VIWuk#T^aA55bGKr?YySP-Wqx_-u*(X>-lKs
z+8+DQtJRI4u2eUU=sCQKzLjbhzDMByY?BK3$WN~su0{_d)ril=sXZNth;3Fo5Z?2V
zI_k6WvB1QhBO6D4K2D9oXAj*M@4h$I_4{b&JqX+y@4hA0b#t`yrXIU;vOzi3p#0jP
zoVF{cx#yI<Lv1*sHXK&%dzbEAaxzfk7O||{{Tdo-PQnve;#(ScQW9z&b%h!l8sz;#
z1^V|xpr!#y8*&ZDW&JPK{m10X3F5RkQg^qG`Ouj*J#+WcT;s93Wc>}t_Xp&@dSJrz
z%v_mO91ASc*SOwoh&v}|2UDCwV#w&y_uu1e8LqfC<!(ptS1Jp?-5)L4{r8WS{$1_$
z?LYkEA^H6&b-B7Jb<=ga9S?pJ_&&_)CWln7&~z!QXjI||DX~x<{HmP^DN0ln%&|sO
z*C<xetct7G#=Eju#Wpn@=AO60>$&^a@LcY04?n`)x5FpmubU|8-&A{ETxB|wAPj+H
zgd@JT9)+?R7nR3qW}z@vQx;y&Y8Hm)vYOiPBdn%QwMUkQkO8=Q2sHr}N?(nNED4OQ
z3cnbaJ{~2mD+{4kX~rnAvu{Y%AWC*{P_Zg@i!XKz7~nLVZZsp4_<}boJ{Gkze_q>o
zrUUM$mYAvF_YSd|LyB80$U_~-F*#d7!@4BB%4!ZL;h2y34in(rfQO%pGym->lD7`X
zR#L>}oy>oSDx2^{bN#m~%wGWa4kZSU65qEze>^YTsgH{DJRByL+!BJvZC2vpuxwJ|
z;-1%0xZ<+#Xp9DO8ddpiW_lpN%XD85r%dhvtRmI+8LRBFeI~wl%(+8#dR2RQJP;Q*
z?qZcuCDx$4YCa_x7wk)K)VH?mWpy`nsmzz7#6G0qz>b}AQ+IeJcbRXz5}WS^B;*!`
zZgj-(J?x0NW;%KR9OdY72~(zYH}^M)o(Czd+vL@YB`xG_HUsG3KBEnFC~=obERrz@
z)G~q>S}C_!_UV)<|9#&6eOZOh_Sp`7vWmh~%Ef`9LOn0x(Vbce&HtA8tVX1sDd^Fi
zyn3U%h*b!-&rpo}e(}kB<$HK*|5t^a-C^S(aly^<0A5IHD)WsNw~fHbBbNRXAo2aB
z>fXK2HQF&(c|yhb#Ndnj+T%`rjQQ4y@3Wa|50*^SX{1Gl6?Bc_jLlTLoYr`!^Tf<J
z648<p-=E8q--|7SV9c2t4LNtr;L+VqITmty^9p7hcIZz9Cak<(Z2YlIzra_zUYrxb
zI*dCF%vZ05cpduT%5ZFE|8&K9dM1^XsR)ZFF_TkazSmWy6<yhim9as=;?7oV;kC@S
zUhEtuE)P=~vLn1U-n!<B{ESfR8biJXk&;194L=7DW*MO?DDi8%vX$!)Qi@f>GtBo2
zmD_+)>l1)Y@UQ1}ZRSv_^;MPWCrMT{>J`L=rU3K(po%zKl|f=hN4Ap6Dp$1KTW&<8
zago@0p=86DUZZ3yW0-#mc3%L+n|EPvnLif)=8grTCF$a4$C&ve0)41~#EMMjzfLsf
zQ17)pJ)l9!R4h*Y^g>m}Cc7SkuZoSkneSz#S#M>&H&C>EB@Y^T5WDXp9yIfypvwJt
z&|;><CKc^|S(PWU$}raZ3Zuewx!H<U0pi}E%4TviRc!m^^#jm=A=!%2Ymf!(AI}To
z#+}r!X&8_O#krqKYE;9^fl8QfuQDAq*;r*=+r3C^TtpyeRArUl0AS#Nb<`8)dr86W
z=ZlWj4HPS;vbys^s#tMr)jhhZ`}I{1nX5|DtIEZyB^g!A2Ua~hsH%E!RqcgUFJ4qt
ze@WHG%&N_fs@I2Cy?JTX_RFi@yP|4mZq+AKtNuA{)s!2nzPY*TM_1LsSyhJ~s_J~W
zDqL7~e0J68M^@>IR+%1M)o0GCw8vIuJico1+*Oy%TQzL{s>|G~Mz&TJeOy(vtEy;s
z)sz3w=~j(yn<^~7m_9LlK21UMlz4+!F<#hvEdZbE@Y!I+XU7ltwEPvH<q|%B{uQ6b
zc6{Dg**5jSdU#qs#^=3D@YyWj^T7&y-sr(+*FP!vY1>p*`Lb*xXPfxROM-C`z{5N7
z+5eZesZ*TrJUtVig)V#+P+|99g-_XGeB5L3x#<&pN{`~RI}@LRG74tnbN4U!NLBch
zynxRGeev0I5!1IQ({VnaM@+vHhh*JA?0HuCG-2O(WXY<fG*6YK6r_+{n>}qhUkX>A
zy%_l9H;C=G(eziI!piS2kLKIqd~AnI#VT(3ArR%|QDmBY9`jwLxH8TKr+eq~rLh6~
z#L9~iUz<lust;dDI2~vuy`;qH#Olw?pD9ipRpve9i0?m~tqcxn+r-vA-KsWV!#cfj
zR@o+Q-NZ}}E39sW%1jTzy%O#$xL3e+!M$Ak><GT$BiM2+#uihHxy6E1;Un0UhS*-i
zUSY3(ukNhK21E@yH;Vah5U^DV6VYDL(<zO0!gS!>h7bx3uZ=kk(Qd?9PPZ6<=bUM*
z?lN_+LHx5J{2b!MmwIquO6kB9PfC`889;V)Bm*`2OAFd=@`6oV#1Ga$Pc&vP*Y}={
z<3nl#j>pPV;;MVgr}IG+eSc?l6VSEs&H5C@Hc^=lOkg38^K>F5#+L89VE+%Ds>4JS
z$>PXTdsY8XcKb!PFO;Zlf&xtZoU8^;H})5cW!p!#1Cm}Yu>EXQZ9f+Z?n|TxhWF3;
zs}eot5@e&6MeG=5`vU0%`EuLO`_>q82e8UF(Jqu=T*ON-$Z5Yxs&45Yh{lEa#nM~D
z`%^nsMV1CstzEigyA<}^18Rf)tR#wkb#c{GA=^KdsM8yHy2~j?O2h+yi7Wu&6awM&
zq0<m4%Xw3Zt2sM@B{SmU0e?sh7Sk9QBBjy|!;8fOF9l20;M21gxb4UkEEd;2_#x&e
zTj?7taa)2<PnV<etvNf&Ese#qt`9!l>R*sQZcFjj1&vROPk6T?LF<~-+$)k<L7Y(D
z3xZF%1|q-6^XI%7!pNiU-~u&@(L{w?o@y)>ie-#mG4-w%qaJ*ExZ>a;%t4?g28uf#
zEKb6zB1^l~hLCDcPI>K7vE_B~;Lof!2E<#7DFtN9N38ZZj!g@zJ?Y6(SnVkl!{PL@
z+8&Bm!~>fFjN-5c=!Dwg9?Di+=h+k&JElh2id=EuKSss_<J8sxvCx1xWytvwS#kK*
zo={?7|591)F~uoILo-x44FxH2;vr3dVizJRrj?8Hoz?ydNJMel8x+qQElXRLh&yYn
zvd}u_Up>bj+`DA&QbeCpK=jEI(B^+jGn0~_3r-6vKc%u2H+VKhmWccIju|t?d2%Mf
zrpr{PXM^pZA+_6WV*1_Gh*O>op0NPX9QPn^3{yQbMtzCfCU&dkdU4i?1cd__t$TfP
zePND^y0Vo^Xz{QWcYCVXir>@cKKk5Gp9ek9t6kX#`e-Tc;Gu&i@#|dyRXp-N&avro
z44!V)E*j?r)CQFjCj539#-mEiPACE6X?M)0iZQWvW?ZI3+^qI~#i#}%Ma*}l5)T%&
z*5?|87iI*Du)HHrh#hsx>?d3Uu?K=r5b?03C>j^%7XywkGj32oALcbEvy0p}0b4)X
z0P6jFm1my)s2c^{ME>BT1k#4aj|LlNq9WTw3>=DmRBgac*;0g^h=P%WR&|m1^*@OE
z`X{;*qW%Pn*or&QJtZ<1^~?(v0k+X`_bF+`IQ7>uJ@dEW3>Q1Tii?H;Sy)-$)8{h!
zq-8}syg`viu~GjRd=z_jPNI%tG~XqBFi@;NMtNUXdG4S(DaK3a7CVM##k<F;2&Qol
z^M6GRLb7-(^M9?>gGu>H@dI=IOKtdEMU~OlRM3r`V`8C^(e8;oC<noyItE32#f#W8
zG8!Uy%Ij(g7Ut(;KL6LLk@3z+%>OMFjXsM<n#7LR#UnfOtvqx@HZF>LF=T+|{D=y9
zg6)X}2%VK+J0<v*C)k-tfY4b9cIN!pD#iWt;`q!(qgGO?KEZh-<H5NTV_Hps=KLsj
z4mgdJU=`!*V^VyLE=r#sR^<`fugez^9mjb<!HSXMvdywtipOJ79&gNPEaL1IEdXt(
zU+fT9gKg4Q1gGgdZz$1)x?mCZnz*xGHYJ84-u;JI=>9wxPdV@Ux$b@#1H~;gD114w
z+FKQuSo~xk@yO?an$`ipR|6uF+@~xqDh~uAPevrIz5{Q?gL8m8tgGh)=Uo5C$fM#5
zPb#fzOjz7&uMW;(i)YnD=0_Xnh_3mo=Li4jGMeU_<_G5xTD@4BF}w&Yu@ZNBW1;Lr
z=HUEMakMWue|;Qj=kHr{LF4>f!FvG$kFv$z)Wr8O|CdTVwR4RwS2)ns8l1PLPjK!U
zUH(E*xf#{!bIs(*zye9Zs{T^RqP4Bi@`_@4^#tbv`32_<i0|vF?_8hTKUlQJluubC
zK|Rn#tJ5%Gw#O|5Rks6M6p<p8w-42&l$#riJlA8O1JTAJTf{R(cwvOt(L-P5W^ljN
zkE4(+^S2f?&U<~XIOR{P9$Wo52Co$(=a=Gvnl-xEzTo5a!N*XqSl=E1vZ8V*f2X09
z$Dku=y-}j_BjP+$0082kq3o&|{$xBbCKhg2TI;);-1)+k5n&XB{HO@^WTBd|It{;L
z6<2>bWkkV~N}<Um3^j8cBDm8F?nPUTFDWIy<Kq6mP08Il2W#jF>_9Kh&LXj9ERZtd
zq_2h-6?nl~W#?YRXWG-DvF4ddD$*)0GhZQn0!T|m%J+*MPbx8oDH<5l6Ka~9pQ)9g
z0lEQ56FZ8OZF8&zMVP2QxtEpr+T(8HQ+hcyRN`ya8=nH>@sz2cD4-_lMu9k4O$GO&
z`^X!dqfWV$x?={vJtFd0<ngnbyALbjXRHK6uDPV*DU*C20e+>W!2zIN0wop4gP56;
ziVB@oHhtbY;PV0hIu&P2%z^Mu=Kq18zk!nF$HT`;mbXW7W&&@Vo3@KB(T8`2hCd#8
zynEbZk;j0UepLLABeUXvEZ0)9+}z%5YC-PS0mq}(c84C5^<Reuga%lT?^~B^X)j$~
zcbpos;&?$GXxDhjiuMo3II%_x@<L$3Ff1*(rh+`Fg#wNtG}WOJ^XDi6O+ATh?ZcJh
zZUgoRa%RL!e6Lvej#y(zZi&G05+7z2qZHqV#cK)~<KX6W1sKQxjTqLesYs~##4gPo
zUX(naq^C4LC(5Mb|1rXzNUS6&6z^)WY)UAzU6{3%>7E50nyq@P0Ah7Hz^%GffQ$y~
zk)uF7ljbnEgjws5Mu|5q)jW=`3cROr6nXYzb$K)ySie9r2po3$ObB#dZ%91w7P6&z
z_Ji2*e2=_MM9}F^_w(v`QB4mzhj@Mn|Eg%IidE}IjRaWY`IZL+>Pa$SI6GkEfymOc
zvvR6Anc94IYD;hGexAQ*qmivx0#O=;QJe$`xs8%44-8>#OULB?p=QA-os`X?W<#pf
zGm^3kk)<6ZK2%Pl3>qGL96jn{D{iL~*v@L>IBc7Wz$Z8%7+ekhVhF1<s35>FK&(zs
zAq4?n(bMhBhIEA0nKVEym!YvbV<Kf7$xb`1{4`*77WLN-O}f(nT2lWZkzBH;-RYf)
z`7$bE;13Awn5iCd_v>^TNIHY?QHnGu&LK_rI+d9!A^_|mprBA0P6ZMBDQp7S0lEv(
zduBF04Q{0AX`&B7WYk#|@$(ZJaahx(xF$3e9d;NXAo`U$2-)dvtj-Mi2EO0`*BJ8$
zha3jl1WiS&!JY<0;Q@*QpYsE&=^)y1hpA6zvmWwJ71;ua<av9vTr_%Ll*GHjzczgp
z;t@twX*T}Q2;pB`>1j}+ktNSA1<REf^Md4<lVEIJXQ6yjlGoZHuH{ojgj|w1ue%oI
z=~gS*?bkA06;WnmSlvWaF;R)Kx@#4Y{WG{^WYafTNO79iiD)x6cY5v*JeOiZu7D;J
z2`(9dg)naEnbL{que%XKm(k*Cu;9W6uaa0aTN%Q9cPI`cCy<%%RwTGXNrrAw<#fP^
zv-I5pk(HEw<!Sg7i1cuHt<Ueze3Lp5cdOF6E=#txcCCj9X%Z!dtOI8W^W{-&+gtD`
zO>=XNAxAy{c?6hr4q#V&k&gMMa%9O&_fR5E#G9HF(Cw<Yzpo6L&lr+B@I9c!9r<)3
z*aPgjOr)L!ITz$i_CRDI7ZA)2x4CDDM^+Rs)HB}*bkoLs*-EouK!WhMkoQIw1{b;}
zlQ=W;AVdalgVPMZ6aIwxCMzx@Mn0`=2fC0IcD8*8SMJ-kBYYhX!AXqOOx2DkNd6!?
zwv*s0(UvvfIERAwje4Dn^ui-!z-OI@CPHj61FgDQ>^KIpe+7Viarv%89JLUV4Qe4I
zf=EtnH1d44=P52k{idC0juV_bXYFf1h6#eqd=r%E>8c&l4oJ!iAxAJxQ=phS1hJc4
zdgToIo#F$vjm5~(7H5-}V4096!01roftXmCw~BZskT$j}yVU;O&4x}pL?V`A^}>yg
zLP9V#l)?9RjAPvHd6(6^25rGTBwm4lHXQFZIxWMon;{J%aE$V9vlzRbVb$|)q&&cC
z?p1^3ytD@srJ?`7v&9uhV=^3XS{bs%6eE5p<aKCdwwaB#ctCAhsq~;irKw7J+?5(E
zZ(7&ZP2ZfJV0qh(*t{;o4xxXr+y-uFk*>@bh&D~!TJF_XPh&M(NwQ;z@4z6(#qA$s
zTvX|c;pNF5VdO919f7EL=;^j;#1Nmax=ad07PHZ4#XXss>|lilsbzWP^8@kfUDQ9@
zrCLqp`lg9H^fm%j=Wq#G&ApgnpxZ%8v}|S|z8J~xg}l`O`Kjk!$bYF#_kxac7u&{%
z+-`Xe>Qmx{2A7G%_O3+aJp@H~GOHcj_T#=aL#T$_blYVZnaUmFmSDMV;X?TmG~+Z+
zQLZE8+S6!2ELYV<mQ<2RE>R^_W%8QQe|ww@m7=})=ejOp5knaugpM#X&@$u$b=N7U
z2@l7ZajN31&x70`DjxK(x=BD*M&ieR5{=iva6r#$4<&q_rhfx@b&FCw+ca=G3Kdr$
z31KP%C3?}&QDSVn5()Yw5~S+RPSA(P_2Y4=s0TIoX1)M%gFJ8YVv#G^0A1VIUeK4^
zXVgIff*wJd^&c9n`}YRx&T8<Pl2iY^<WybxpoO|XJY2>RQ*tb84{%&2y1}4#kSLyp
zX}f6njDj5#dxeD@Obzdtc$T=3)rNSUkoav6t3AL4tD<`=uK^9SdLYX93ECDc1lnA{
zf`noa%2pmEK)iaK63bTZ2vv{khNK@3SJ&{h8LQ3-(Zq86!;FfOePBrVXmZsO7OVNu
z^NzMU3HkIN+BXpiL45VjGnn9^<i1Jvxo#|kiFIQ_D)x(m@07Z6YS}I2^F`lBJM<Q2
z{HGL`Z)A1jupMq_8YhFO8$$~_ySkOtja6`70>8MD7~mMvt04}Xbr$SPQeYTKuAqAL
zd_V}(#ygttHi;b#a(c*ZVKqmU8M0aY;3`1S4vdT*^w8?ryiNW*wd{P+*GgL~J2)G7
zq^Ie{w(h1Efk9^XVvv5p*%}5x=|CW}34s7#KsJlU-%MK{MghGYPr+nEu*QrRE3PZG
zo~Nm08Hrk~;*q<>t*d2NgvbL~T^dR_k4iujd4$+;kar}36YoooYj8I2{U4IO2T6vR
zt{aK2YjtF)WjB)Y6L`pUQgL4Z9(y2uB7Xf@T^8!OiMLd5=bEYu_OZHA3aI+Jk;Ld)
z#E!hOd*wl1y*x;Z0fm4VgBEk&OXIww7wN=>e*{!~uS<Rra%-$q2&=u%XiKo|%o5}+
zeIVIVyS5g~S<SbK(esWGGAvr3zgM<dwDXPC{0lnM^tSI>>&1>wF@gDu^x`99kW8T|
zV6_9=CSe(8xcX<fEEz7V!{D}tkIF*$Xii_T<G%c1NC8YKxC|j2)!#XK;{5P!2#NJ~
zw|$2q#rJxEc+bP}j5T$CZ@Us=bZTCVleU+sjmF+-93E1;uqtvon)MdNAw<$;E31Pn
zH5N%{wQU;miZ`Z{7+pMayf-WlITMTYz)ojkDL=_sFmk{|IfN^``rqP;J)K+*U;8=a
z@t_~YviDf+Hyi<=QVnT*a}LrVFctV4r11mKvj;`AK)Q<1cDAyf!#-Eydre~L9ekbP
zT)_#1H9=Mgac5ejFodxvOmk16adF1tYOs(_a5~JP!kbIdX;!m8Q!z<qRW{&EE6>CM
zy71b@LUH4f9eOi~{x(kY3i@NgLO$U4osw#}T(3oF(FY$Ub?vx^md(08{3G-s0<^Wk
zLh+RwohNK3QE|rXLSRYIN7%WX5;A&C@*ixcXntybFD^gP<4gnPALETn%L9|(LKLWi
zt%~#1Opf+IS%i19nlBYr^9^M1q}_CWK&nIwox{!#cp~^X=>a_=&OUX^tXCh}{IDRH
z6VqS4o|!IHB84ljue@Q!jm0<VxoUX?8f!ZR%7$nHkgY_ic|4WHg+o1WLy_hAOzsCA
z7H!G$Tnq`+Od~uWK~6TUP^3ZSz6{EyiTD8rp*EuW@0pY&x4^@ES&G}})fbdd&T7()
z8Rb;5{@aiXP%zm-K?$TS^C(@R5eM^}H~@2~#BAkhPvx}2oMb~R<+(H~XEj0SZGw?%
z;^n7%mb$Li2wpIif_zE!GS5=?#bVi3REoLu{7|l!p^GDmnC8{E2%7-pC#X|kom|PT
z%HyaxM5{tsP05H3h0>Nl)_%R9RAjAwpNfM=+>^tXUU8uwqZ}+eqme+rSl#t1>@a36
z0_8C^1D1~PUqPQc9q93_MTiH3Wvsp>;T4S4_a?jsWA(L~mjuDH7FAz&CVAeO<PV%l
zo}+mwv8P-1Cd;mpCGOQ5t1Y0zs792%RR(K#z2d&7+9W%ZNhSH_WYUY}N!*JTy)1)S
zL(-Ae7s{7&puyPIB43h7>Nx@92`W`Ew*5$G1xW=@MB9%TxkABSZtx1iLX#5bY_>fy
zUpCCwnL#D1004yW28!p(eRxJIagF_9`ms_jjJU82q-lj#L|sEf;@iZQ5?2a97LlZ$
z?u62BNZaR<@vLxW^)}H51C}hv9M7a0>eV!;S&{+dELRs+&y(M*&Y>LxH9U4emTIrg
zlS9eK>Sgkp>IdZgFxR2-l38S|C{jjh8b>=X7D->Ga;E2^h-HbWVZ0rSGgi*3d}zhP
zcCDDjSFp+uid&qawWktFk_EHDgtYyFj=e<sQ=E{!*gRd+ZdNpbO@>hk_KSs?(ur{3
z=d?!4*JY?>ze}9ceVbr>bq~x7GUWc%yRwyj$*{4hxf_&C1`gCqF}53bHEod7nl_vp
z&1)D)`D}DLJLhBIPkDmnm(lW1obasTEzC!q4V3zG1EfBrS9;_-Rws6=Jy0Eh$xo;0
z^7m5hG*%jH*V&Q<<lrPBt9-E+j9LH&%jFR1wCjQNhiq?97jXmAg}j&~W+h_IjL`*M
zY6Cd<y1@|SMSHl6;38Elvn<qYg(7>f!i>Wadx7FIwKYR?)@YJ4lZ7bG7PYMzA69pf
z0$Vp}5I0Uk#U#a83E{RuN>75Y$Qn&eN3<qg$eVP!d%AFI)8TGavL%az9!a`98Bm-j
zRH+{ql2B(*`|HL=6W=h>(B4Fe<ybykTgaLrfVL{JC=&}Ov8Wtc8p3AHMj`waEehaa
z@rVP<X9O_ZH9)^gT()?Wa@ZR#dfmcNBB5_W*r|<X&q0pOKnQ~R^X$Y?6XJ^w@|5r%
zaogo&54UZP)8fvRCyGb<L4Pq$tZ#FV4u9Z=kRgJ#D_^R)%$JL0i9r%_Q^ISpfpT%O
ziihrmZ?b9+o6(}t#DBrP3dq5Ae)t2|0KVE2$N<QjFf1rAA4KbE;P&sKJzI_wL%<oJ
z6X@i#NBB`@wBvBAQE)7Z%OB~<R<36?2M`StAPC4}(Qc=H1|XU-;z6|&9E3OCz-4}|
z^{fUvrdxf#(8zh&nxIlx>vnQPfI?8>rjy*r3x}^W2JSEf`T+$(W<#cpUr{Nn=4)=Z
zRP(hGZ!R>U9Jx=Zxfb%ZuTc)ZiV=jOYPTI@HDEepd1|(DDXh3afnX8vG6hgk-DJqc
zjCbRZH^IFVE;csh(8oi}^1W+#KvkLLN3{W9%MVnv<tGK&$$b1E!m@nNha>>XhsYj%
zj8}Lqw@u@Xov1bTI<-k+HP=$H30y*~!r&a3IOjYBldY!5WD9w&Z5jjfH~D--@UTfX
zY2XW+>@fV}D;2h0lTmlnYXC`n9qeT$gM#-TQpNf&aF*}jR1bGYU?pCqEyyfp-i*!V
zzLfd?q(Ikhyg)fdv^@zXEg~~N1WBm7kG6^p;&<<I6BXYwoX#*&@m0WuiHdJIT$rf%
zeCT)>THSGQRk&BFO)p{1z(k`{E%?q6%@?4P=hTErY=0VSu>DlQcj)f~X5NDAkWQgB
z*+DaDh7Uozc?fj7Kqhb#fvSAa0R!b=aU&Ru%Q|F$$|1m4F;>tPY?1r4Et07?3ii!+
z&j`70p`{IM4?$SY12mo!#Kt|y2=$sgidHk|CNyAJ!M@mh*Tu{Pr9=087k1(3CYT(i
z!XA*aUE5@Dy0G9M)O1dq75sy588G;8(Y6N2xlvXeg~787v~UX<=lHKu95+CDH%=L=
z+hX}OaO&h<%U-j%45Zz%>h6%^266j4%(tStoAPXL&KG8Vi6B&@S{ank-$^7j7oKKm
z!c$G7Vn}E}9r^LVB#21CDYk~zo$g+v`?dN+M^^lZd@)3r)CXblzUmWN0?D=Rv%nhN
zXIb$sXpny<4Kma}hm|!O5CWH$KNhyuj!1Po9b#1Tc9=lMCI6Mx-+?}FU7w$VbPY=N
zH$b|++X$sFU5tC7)$}oFHGQkOR&((_Sf*G1M4C%qwGs`H=7{-^bVCyc3EzfblaMRG
zy2^h<F~+)E*KEiiz!L+EWF1Im=r12)rU#UGHSA_Wt?P1ap>+tOt^yp6{tiVRL@}+B
zye^C2-A2Ul2zYL%WDpRp$<OT*a=Zcgu^N#3W0~BXh>-Hp(wnq^COXDm#~3r;D#c+%
zn`bIn0L+BEJ3rrmElqw$I?T6Vn5l~MvRGvUQLIF$fJ;9Dm7$+byETwhN)dhx)sWDV
zW^RQ5#)yw)iA6AU@bPG+!CDv9Mym&-6ZlgCmr5XSfl?)E4ah9#WDW<Nt-%+G^$#^&
z=+(Db*h&l0I=~#+%7CWFSj{9Hn;EK5`p+gQ5YM?-!vLlyu|R7kDjA4}Pk*=Kx~OTR
z+Jv)1kf&&eMqhNJ<Q6guZd^-A0ze}ZCBaT-3DyuK$>-A!&J3jUy_};o?R8q*NNu)r
z(GKnIsA>;jzM=K>kE;F-Co9cz2qQiNLw6f~`6@I>mIi49;pSe705WzmlDmx6u9Yr<
zkmzr~)~xo05LuJemaY{)Sx<yUWe{WSHNu-9V7Z9Bfzo0>ax*)F`0f~S{pW%BnSmkF
z${=iSAPE)h1GYDSTf<o02ZlcPE;^sGm0{rASj|D8_OIXu;eHMGC%E^+4Ztk{Ub_dl
z=&1M#NeDC%fK}``&k+^top8DE9qd1Ny>F4{%S5GA7YV4HLtuxny&>fMAl{vU+XE!1
zCL!98M2ilf73cF-D0Ex^?Z&`r;&8)}Ms(fu+-TW7-dwUbH{}zJ!c23-&pMguQR4g0
zG6OXI5rF^J4v^yh%@7ds(;RX8>&(xkf2O&-+{b@g?!5nXxm*D0KLjk+qHEEECpS=!
z_%TnSiPH;=r%sB?KI|1hF53(|Pg{i=f~|7M)|}tZ_Daa1x4na%ju_i3)cOu)Dza^)
zKEn41d{*w8ZQIC9g|^ocNgjqzOY#tWT9R3|*Kj-mXJHIsa>)ti9nrGi^MUnRZ6DKg
zfrY<JB`OB#{2kb|<U;<m9UW;E4Brx(4P3{stRxO<5UsG+jL}KBK<CiKk4$2<wcIKP
zXClBZg#%+<&DK7&jCz2TfvRhtl+MR0_d~qFYKtMn1Q!scRVuz*1#$mVR6;k{hT2*p
zyIE~1h4_YeQd|Z5%HDl|d}MSA;TE`ei|u23i_)UDKuy`Qw|K8EIrzQ8U;T&D1FG~k
z4$9*E;B`O%Ik&+%AhbOV=b%tf11BI9l)?!LO~K$KBq?|U&QC(YRd51ATVrrCGI;jG
zQ3TIQI02!l9nQg&wvU-*HK~Mxx!DK$p0#HY4j9C3Q{V=L>O45@LiH9nhXl_A=>a3t
zf5=-!C*xkzUSo1y?A^N;=5>43y~=2&f0h`j2FZh;0QBTnoa%H7JbIF`+nH_)##{Gl
zfg84c{vZt?<jiQbU0FyI(>V!;GO=W08?I4-q<treygkIEl8G-fKZh(<wo*@Iv#IGA
z(3|keT?NM>*26-mTmdZ0g%2F(bLAjZxMqN0ph}{@>~<T|XDQi-j4&fH!z;;Z+j_KC
zn3n~C`T1zScPW_`)DFb;AM(9Uf=4C3&8)Y#lGbKTA*o&<D(%N@o^!DR5DmHF`AuCi
zPK@p70JOdx@(5Vki|fJqWisDRqF*w9(<idT2d+RfDxarA!iV9&MVrb)2%x_^$r2eZ
zaA&r1D@jro>6!&$5tNr%O1Tc)O1Zu(&z%z@+$_k8#4XQj;+BL2hL{04oj@?RN{DXw
zviyH9^9perBu5b8;C4r{1glnNv#}S%kJrRz<IGV)NF}~nqMZc(tD)c;Ob6C|unr{E
zte+zqj+L8waEOXqAmthZDz2$7hJbLaoB|}PHf4ZGq&oqSe>h<co9GBm*;Mdibhhym
zn46&u0TG1k2ap{?K3qG9B0J^A!l7dj(g0o!vTW3jqd_6MMgVOGAUq$|ijgb0xCX=^
zHhctDipP(}k^43sW%}**rbEz%a(2Os!qpIJ$8KG{HtJL{%OFd@d#N+U<?DN#dax+e
zLT8lh7>uyPp*2aNE-t?WMe0lgTLgZ{Hx5$OD3&mtq9oFxN|qOCmt|gTV<>QT%xT2c
zm(z6h<we+ASRsr(Auca$n~QMUz3@460osvA(c&K-q^{#Q=T)A@V9;2!EfpJEnErj$
zZYRZsP%$-7tir1N5O3xQ)egD)JzPai(i2YFgbK&IZ_sw;WZIb%Xl)V=ovmas|1F>|
z+h8t#5%h-qR>uIQe^?_<(!uzJkeF8S8zkCVYDcRx(Zv0zd%6<i#mAiK=u~J1_E2J~
zCI~O}1zYqtwD%gg??7;(aghS}J=|FH-9)53=(3q4GXXUOelJ@|OVkfd&=4*-N(z1W
zz5-Q#0)sKA0iR)noqRFE+mNhyVbM=(8qq=uF^GHv@|F94#ndo=*nzo!{Hx$_Aj*Qf
zB&&uf0sNm3rA{W%h4|fv;(@SOR$6eCxF-cyTb?<O)!dD?#Wf!WR{Z8daZetj^tozr
zCPa93Ous>Cj*_zalP%&$-!k1|LayRB>&4IS0dl3q-$11^b05O<%<`QU>IZT!5Eq`|
z@_kk_L521$Ov3L8s-52o$n%DvZ+Y+)$a_hn#Sb%oX`Z(`0fpUa9%!t5?G8bnx9ePZ
zK@#41F8uZ+yyIN>9XPjV@_7U^LyY9z0Neo=h93UkOCr8y&`2=<eKrt3VDSB5EBr*|
zJ*buVdw$FU4RDbjBv!=2gFk0AzhJ%0<U!{5aG8Vu3Dwm<XJF1H%>P8rz_PoEQuF6Y
zKt+BxO*v`s(K7}mAudJ0Jq9<~@?<?&EPjs?wTGJH5K|oO0u6Eu3W%f11F^0L^AO_j
zV@dcixt-Nb=~5wt{+$v7O`6$Vc)9Ds?!qfv1G@{aa@o3@uNLIKTP@yr&Q(++T7FcS
ziMBv`HU(5Ih#d3?48Q6c-vEkrY%dNb;sSeI!(tcXo(eV|B$NcAEkz20eozyn;ARyz
z$7JLcraT83L!K%scjm%haF%T@tH}lLc0WW9m4wuA<$%>p!9k7L#$E7Dri7_|9-t~e
zYX-8KsWcXO1#1&=GXbG-CLoxsX~blKvw}_aa$HcoN#nG{<uE&*k>t8Uz;<!z_TC`I
zJXeXMKJ%F}A^fERjq1>Exyk!U1y>n1neCE(k#3X4N>Y=}s(A4E@TbsdMiL#J^=B^U
zBAvA#*XsPQVw7N>IPTmoPvu=6gy^PqOy5N5nieztn<{Ozrduf+4ucPvWfxGH<zxIl
zlAgx*LkhM?*QgC3b)+=>T2v<dj!rDBm@O!03s4ct-K-eHA5x44-3+PTuek@9U;x2E
zHZ{x-`xqlw2W(M6r==3~p1(3dpihS9uV?^7tqz_FlmIel!DtG0GK*Sa_HsMfT|5P;
z0mOo!6=+hnfF({cZl1jbf980s_z{wnP+iCZX(eUB3e(j94PFh?YmFo_K`5osL=3Yr
z8U1*aMN`n>D2Va?x8f26jVUfIqI3UgOs6ErbaQe{Hz&t5laDFJgvM0&93AbP#D_!@
zN3d)m7>1DPtkg*8)gw&D2m;%V|Ih!t8H;oRX|%6`z#H@{4*8U%kraT+eAj5$B3z@a
z@v*wAl{Eu$t(@|MSrx)f)1f9u+-M%B%WY-)k1=xZ+UZyog+s~0wX0l&o_q>UE#H0^
zgfSdt;~_dTKt<Me`3}9+gOfRkLBdS-ZXz6je^I5IvJ!hrp|}~z0MoyrO1GbhqeC1w
z*Ahfy8c~K;vHg!g>9Qc}n&!}!$wLptgXcqj=^78Q(oE_Xb{YDW#`GWX1*zX9VOA~#
zn7T(vM)M@P+>d$pe%is1B!&TiV1p!W<Cw5qaS702>2*rsWS6P<5k2H~LM@~n#gC-R
z!<bN^WF8PO)9_^f1fWsw&wTA@E&Q3XaNu1cu&~hd+k=m&kffufKjRYYUE$pD>hOIe
zwFRH2Dz4un;xLHrzLePXD4@_)nC8Ikg!@Oh;MGiz!G#3MR00=!$5aYeg}VT57;YKd
zU$k@NaFSg^`AXC^6-2?=xB{55oy2aZfqD!H+!Q+&rNj_Fpjmlpqe1*)iP$!ol3|7a
z73Ox59DYU`sZC7S*=!BL^0r$|3sKY>L=8AA3ZOp$bWtzJ7_v)@ha6CH#3+vs3Cz6-
ztRZIl9w$V9oao^t5^lo~!bLsCFzD3n0qh{V>g}T~YwRgP4#~rDGCv%_F@z7>wdD>;
z5A)w8U5breLfo$Z9?2^1`k6>O=Kll2x5B+&8?3u>))V24bAqJfI5LTJ^%sEH#d!&o
zjw2lE1m<@_MbG?qf;g_Yb+=o$d!c^!Qek(cVRyB0_gd5Lm(08WZuw-m^^?m|bh=N9
zu(&|>G)R}LLm$tnm98LXxs;<hqcz|da#pj-r8zGRU5c7Pv>!m*3g8}udpq2p;DUni
z0cH8=N_UVthJ^lU6p@sWBsuMd{~&Hj#!+V=jDcL@><gPsC&bkdm}D~lco@70yU_FN
zfuw+qQH#?H)dXyu^8i%oWOjO6*Ibfs2536$b&-<8_CebDJA!Rc?dT)r1r<cQD@wiF
zL$7Jj^B6ec>F@)~(V&rM`8;Sw@a$W)1PrO3Q{H1|s4G8uTt~3Txv;eaJAN+gd4iod
z7xn_dPM!;U5wNyypeW|2;{QZRPFL&Pw`<{bDx`Nj&Z)R3adNWO`zzvsH~dPE)8ZDH
ze;pAOwNP0^yJsK-h6rX!1V;A(#^_<})=|k(<h+4$#+;ur|9UVDsqsYdE$)#aw+%qb
z1p$Mh4eM+@M$wO}JuU8ZiorBw^PB$NGpRK7+^*CUEPO6(1Hpbd7xogtj-CtqFM{=)
z3&VNgpD7K-*Fz}DUx)D_8TVSa5OMpThfBon3viuqUxa%n+&{s+3+_6&MEkCXOSJD3
z5)4lLYdGy&5153|2Drs=UxND--2Z|La>P$`GlZX5Jz%i;u+PjPVJ!DPktAG;uh$pf
z;4i*$X7NpZ5Th^M00WjJP%6I3#DT90b0R#S-_ART1A>qS*-$KAhw()<7~|G8>G_w2
z+TyrIyoNIin87tf#ye^W3HiCE7YTs}_av*RExyT`vl?~Mf(AhYn%k--BiBc6;<Y}>
z<2@2|%l;a~b70<?-guH|I!WC?Tyr5X`NNRC;pGz2bJapPO?s}{i{ZN9Uet61AME6_
zWw5oEBr!o!hILl#e?khZ)<JSle9w}V`e!Ko&P@!$($foAss6XZQl6>lM`jukQk#BE
zh&V@bzb5z`#r>MZG%M5wsbnUqX$n9k(}la;fu7U9o;uko8oqVkOu%ku4_<cYDd|Jv
z)Y=P)AiNDL9TxWxP+h2OGsEEQGU+m$jJJ@?1Rz#>1&v~D>1BKrn*wb&X!4j^2Pr#h
zGw~%&9f^B6s@r7TY<kta#iC8S`!bH=Z_`lxjJ8Q_H!%Hh%uE!lYS{^98Ul(Ca@xh~
z%dLPc9K|7!AgJY2!DyDf*EQV`?bM9TIHdHBMLKWaavj=KQwmYCtW7bYm5XQz$DDe+
zJA=&*%`Z-PK%7=q^K)V)aC9?{LoM#}c-EQTUlUs~4O>t)Xpy+Dp=IXgRjlSnvVdqJ
zaetmJl{h6<)2Z6Mry%cm@Rh~u31<Ka*&UnWfwB5nnI1$4Ui=Yv9U*26+!-h*8XGWb
z?O>n5vgd381KqCL(J?*mn6GpMI!5%DGm0~`K}v<<{#mi?J68D-#CqcXFTy$Ep|#=V
z;d)m2BuV{re^jy$W<V@Ps9rk8?+84KmOe7Z9)3<Ra_g9R9#mjVjNG+U+p0w19-cy2
zeH8QvmV|K;ZAB1ADqgX1JpqD*xZB!3m^B#Sr@@dP#<RGkq@%qmN0tVc;KiVCz~>#|
zj2Lz=x9zun!^ijMgl4C<uR@vC9ccoNR)m<*iy=Ow;Hq?G5aV81N<u5*O6{I@LKymw
zLyqw-F~c?3A-IQtVsoNzuoKLH4{igL{p3pp6xaX1Rc*U+u>@|%ogG3f1st(J#aI9(
z_jubLS<#Y=q9nN3fcfdf{B$|=(ate==D?|(ZtZ$8+DSKA{du+%(duuJ>2sWochGf8
zxVHlzH9(gPF9-vUmSHO3zXL<rDp~5If%Pz{PRDiXD!Qg44DqaIwFA)A0fg|Z`B&PG
zK!<55aJR0@H-I+f5lI-7rUtSCMq(hne{j;ZHWkaoKqr2t;?6mlqYt_I@nt_CCsvRW
zayd2F`DeojHP@70<YDfsxG$5pXewZ4%Aa0vQBI6JmYkEGS8xXAoTQR2=V{YC%!U1*
ziZvvkpG?@FJd_l6pQ(frQgLRQ29b;&^y8bZR4y2DY#=@hjA$m81EIFwdNb{w^>NSJ
z^IX*Dv{1A4DEi6k8;O{+M#z{yq~Ol8$EM)Ub4TTC6hK35_{~s@!VnCsp*|j14~<Jd
zOaR@!!UO=hLwZ=O=5BPzr=%s?eel{;&tX<eO!r0TO&Trr7_PPpvz|fUkayJ*&t6t*
zQ@gQ7$g-`W0p-VNO34%Lg2gecs-Sj2BDy5rABMHKzlEy6G|O92Cq$&R8QPp*KwyW#
z^Ho6!Qe-HOOipBbmdW4qn7*XoN4+r8thr2eU)r15kxrM85Mw(LOIR*J7SiqU!NBN8
zV3aeJ81uDCQqNR!d2c0P7^tBcSX5YBSevvGE-x4sLI?vjHSn9sG1KJmgc!r(r8??*
za!3)xm{PMA>AG-XeIhlSNJo?dV^>-sH74xi8dy5P&`ZN5*x!z8PQhvnSMl*k4RE?-
z<&1`fn3C$}c`emjo6X=9ko5LsQqN)c-9S9zYClZ=XE4Wd2pSA@pUzPMpAo+5=ONgJ
zHAl9%{A6K2_vK)3#9hyX9M<Z3tTAG3;?>VHU3v&<A?Mt+B;>Fm${0bDf5s&xKE9|y
z+pgV61;$Df0$&n{H;u(jxDc*rh6tp|!!((&tP)oVnoD;zU;4T|(j06BT@KD10~Qm%
zWT?vq|ER;QGRSG*WFJat8j)|Jt&Q*=;6G%>TN6zqyt;h4MTG)ke^3bbFrCSVq(PXq
z6l}!Pz+{J#B$(DZC`Ovb{y*vez66h6=nZCPA25jftAit<Cky`t4s>(}hrtcP9SgVJ
zApX!D%%WGf-kJ^<$$vNv_aL$jfcq2NtKgDu?=`r{w|^#F<lFB-@z56D2q!3n{~ElC
zQhy$Si_$)R1};>9&2SD0O}7WHhVn671?MLr{CrX&h-Ur|a_&IVR*KcWgR#L|6s-0$
z$dGE^#Snc4ZlLyE?6vjzBa~S9v4Gkw9{B;|&7Z^w7Y9_BJTF{LX~K_TILU)a_}H7u
z?;rG*g3bA^h6WBiBE2^%JQs?F0}pi5a~%8*EuKJ8qCCiN(IOZw>%q-eJUtP9rjwHO
zp*_cwb%tLKm+`o}!_Rnec?l(lUk)zG;)f(6y78C?u5K2qLP)H6z6%U}v*{a326c$)
zNJ$nH3-5yPfxzfFZ1-oKpaAlRi+g+W!6r_OIo_j8^lA%RahHIbxG_Rg?<(}v2gg;3
zg>A%JgkyXC2KcGQzKI$kA`tex$tw4Uci^2nQf%PGJ9>o%uaDe`Qj@9>{io13MY~|_
z@UOqK<#-Lj4I8e)6jz^6Mw~5A#Z?SVcc%-vQn)Zkuj=vk4<xhV+0Qw2oetgS7W7*K
zJ+{3Y<DCn1P?_UF4Qa3KCo1I>Xbe{I4tgN2`zmDHgCvOrs_iGl9cC3f5|L_ZXS4Bd
zwtpp_bGbj7^fLXY5QB4jNGC`blnQaESJ&JJdoG0bf4x5dpbD1@<Dk$%;^{KeRoeD2
z{azFg!C9+zF_gy@t47G{G#N8w$G~KgeiGJ3++I9X4n*vcVZ{z)&kqh&8-jNHhT-P`
zy|?RA@u|6Dv6Ay}&Nz9WSau<+cr&Etq%wUWO{Q@ep$ehsi{kN?Y2(w2C+Me5uuhwh
zUVN>gc;Z9TCd$*Ug-+<2;CK`_0l#bUo2c50FBb!mD~hkQ6pt7k$tfQFLGhT>$XKS&
z4qlD~SKxOgej^|c%M9kgHyXb&_>IMBpbtP;0|7LQj-Zy8HmTA#U_xu|R^nZFLuXJI
zZl}<@sDZwa1%dK|N?T{|C;upI(v(w347>$Q_zI$s(f<k#L*!Q#_aHp;n7k_lup_|L
z{>UIMbdu?jv!3hd(zx7`v~%;hYISF0&L)cf=<P2W3vLkWe-W3?kpG-qbaemPfqSnh
zxcFA^3t6j8hdJnUL#%7MG1^)1OF@qoxfR5|;=Y_&K7~}!4ovIcikk(@zlVm|-v~+;
zw1>ZRYmyP97RO=qNKH02(2ZCfSQ1G2^dCuhd{ly72x82T3u^ukB?~%;c5pv+77t5u
zzo0D<$h3*a^KZt!+s>XF1o=*)`5xRzyO`qYE=EJM7g=%Vj$1Tf$?0_@z%l<-O2M~T
zs=)JkU-4b7rE_=T$*0aFze)uS<pmAxEr?#$LUx<#HE6f0%+1)K?l7}_Nvq1+2e&R@
z+X)k5FLWNbb|vGIC{;Td<SZoT%yb74Zj>BnlE&SUOr1otm8H^hi~u%IWl;J7J_r|9
z8l-38+X>j)k`KPG;rmjmhOZsI(-MR4X82x~UWD%`eA{>_FT+=i)D2P_d>=@w;CmRp
zR_P#o+u=LPeJ9~tCXsHWP-PWH>3#V61GZWE2|f^^D=pkN2C%K%cL2V3c#gM_BUSni
z>7e$j3~^r`U^)pVkWvkN0{8ub*r@a}V2$vdl0Ja%CiuRS4#4+5e2vm;@KH<mN$cRF
zIwI0x_&$QKLD~l2cPP&+ZG|tQ+5@M5C9ZZE1W<cJstZw#SX#8Gf;$^S&@B@HqY7%|
ztDD7|zctOwK9EA=Utt9ghtR<kx;|OaM+>#5-~t4zEJx^zM)@yaH12Gq0_>~%L9@S%
zKPh{CKlT4k2o$N(57?lU>rl`g)jOmjZ36@LKb*QyTK5_knOZF6?_v3Op`dt!+QsvO
z07iCL&F>}49oX%FTZI^&t3IHSNEooJ20d8092IL)dW;2T&vyuqn8N&+3+~SoKk8LL
zwe!&dUq_Eu!jzdF!Nj|kBo9}bGg6rGPuS1CpYfx*pwt{in;QClx9|bXYG+X4rdiy!
z&Gj33jp?EPt-Qv!n6?=y#k|-iFvur^P`p<$FDu*^U~ZJthv{LHNo3KOgcTHji;x>?
zo)w4jfV~E7C(RDWByL$sSMSkqBi03q!?UiqaVR!<xFsg~40DrynkA-L-1d@Ke+v$0
zZn+7y4B`fejUONfZc`l)zoye#d~$U%1@J0Tq=Z*E6PBCYCY#re3KKWsPz8-)igq<i
zXxt#a{tHPZSnX}9y&dlbfi!^y%E?G^*VJP22aCbk=@#fpb!^2b5b|a51#+p(R^-4B
z-ww87Ecq6f&SEPjXue`R=BD}9(PM5EQ*93*{u{R9W`Zs$)w311!3QD?IuO(gRzkJi
znV%-j%d*YDOha}9TCK}2&C{M3;PefEq&Bppq$a$=My4l`1)+>cX;(a08d);NuSAx%
z2A9-J^2ymt*XG_CEG;qMJ(_==jw348A=dv2N-VM@xRj3V2=O?<QdoPQLz#5nxil8K
zb4i|Sz_QXZ(*ouXD6<#1`UK0sj~dS_mDe<u*<ZD6HXXsc8A_y>p85lobR-A5Rlh=S
zk{!u;D~?FKYi5W%6?~d4URM)6a@Ny%Ky6(-9o_`QZBfXa_T$-(D{`I>KCMbOT#@rq
z@F~0jh)W*E)laW3UQrT=hg$t5`D22`;3SqkT|D@(+aV7}Wl9vu*5#&c5zxrPYU9(k
zM^_iieJLhVEF03~U5x_0@b?rXLR<L@e;;cv{Nd>wJCS|lqQPuMJ_tOG)SF3Uk3Cd4
zz-0_I_k}(FPx6pZp-7=V2nA$YsL)2C6og1{<2$HC(i&k5uV2IUulik}DwzHSTs4^9
zSKRd>)31dWWLGX{bzsrw)q!Uqwx_a~aD!&_D?lg2^m{Od(9pqxz(N7+noxFd829eS
zSveNw7J<m7$j>0Bz!AdE3O69|evKTnCy&TLEDHPMejRv|qn~WXja#8yXf)%(qB<k4
z9d0<upI4=WpkNq(6G%BBJ+C1}z>>uj;Lh??wTtPVbob-8`*lThn##BX3M7p{?^#)~
z6%qh1jpj30Q_1{VRX~L3f)i(l?>*4Jo)`G8hw;O;u&2O*aOM&lYzu)O$a1kzdzW__
zR8FLyn2PsKa<A~zGxLW~($s50VDm@Z&xOF|kIC<O8N}FBC|o^ncwVMl*gKGDP5~+)
z2qLH85a_jr1gi=C({|00*1QY4J^r%qc3z9-JyTO6+*=#M$O{SLn1sA?9hX<Gm-^x)
zw5o{6;1T}PYbc`PO{E8H{2&&UVSWe}aFM>d`VTRBnG|+rs=X6zd_NX-)4Di_b%6_w
z$Wmx<pU<KtNnoh@4^Vqkj+v^RzXIfJ0WCg_c*5;`-D!9KY~pMDrlAE|Ti<)2+NUW|
zw;*5Cg?D$V8%aRLLCpe%T&lgR*<h${B;1Ut8j_qnARj0b$wqB@I-Ex6r9Zd^&&@(a
z2}F#A3cEJ4kkQLmW75Re{;rwJTtO|=tlH8OFTWbSDe?fkQ4F-a0cvhaXGoaUpj=7c
zh8Jp0;>Mlws5ZRSd^y=E5;2AwI<B*C!S+KE&2)$C7I_Ph!dzx7pD!EuLj^EL5?3#$
z<D{~VB&qx;LNlpO{xmK11W(hFLkbTPV3NXv^h~7iAk!sMc=%`1+q3wdqw#>!@_%D;
z-oOvfm-yolkhtE!t-bGPyDoPq1#syFs#KU;FMBI+dO?Y%p~#2D*sWN#eB&U=J{V%t
zhJcMA2zc_qdehDzYJ?ml`;du@)L_(y>j-4aT8MSy!pmWHx>W=TkBTQ)Tihmb{|dRV
zE4%$h+ILuk7~dRjY+!2pMU@?NjOyJZ>4cmP;-M1yA#LE~!EL{YjV(B1alP&Ukd$o2
z5i3LBu>yr-WlhLF)K{!Wv3QUL!nH&@Pz;zNJQajSL>8g}A~K+f+;Vih;+iZpeidAp
z-Ole?pyolpt;G_)lUEYNYeWCB3jfta^O&DQYjJY}Uupm}hD1W7x(4=Ickv~{cLW(N
zS2m(!<yJ8G#zokj4<)v34tA%w=Q(_V9<D|q<M^VVm_a-pzX~&zsBqc{c~UwDiH93C
z^HN?c*_oE7a!XSUiU41C*uQc9{`VAc4e}s7A%^uo1)2$NxPw<#iNpg!(v{+j#Jf5D
znC>#DFhJAY!K<smmzzf6dIW6s8^C&@-GdSei^+sl__Z8f8{QjVq>Cr|^a911VS($#
zF!ccmgH=s@AS~c|H#bMK>9o}}i(s+XmM)K?OOO!gnu=|D8PsVGC-D#xfRDhX?ptHb
zMF>yviM!r~-3csBFfgz*0pq3Pi#Ext^5QSySi@8-<_`UnmR*-C$XIIFwq^32y_Jc2
z*+c6OZ_J}=QIH>|)Ug0WS_m3tXDIt1JXRUj+Y>-+!k;crCc>1Yl6X3ySj?2Oc(L%x
zvV-$_2jI8KgEYP`6++4Q4jCZvtj5y{+8z{>jc2|pNF6cn8sA0y6Ar_I3qXZT!JQs#
zOy+wI=MlX7>hnjD{j7u5-DI(TGJm%UQIlZH>zk><GAUtP``lWvjv$$_MJMwTaDRvp
zb`2FYSpgWkQt!S3`|!7G7uNZlvZa;nPCOeR*1rSnodR_u-EsyiZ%*8E?$>+I8R`is
zeIy;m+I``=zPP{&Z0B2{VLM-?hV6VSHEid57R`ZG8^pTYlot=1*7Ju=gGCUYEA;Bx
zKD@kX56(%_ZxHg?iJEX2s1^$Gj1Y-;PKrTzo_vi1=ft1O@O}plRy;wAXSc0_VUqTe
zm;WewQ1g|NWrx6v{=E#tBy0nE*t$&L*dGru1N{jV10W&X7+JDRU5a=vpu)L8kFP+2
zhYPRt1j@ep-Uqmdl9L`h^B9-Ze#RdxLgOnqy+_Yg_dcX}#$eQr1YFX&ihRG*lEQbF
z=Ho{8WOa}G7x)LFCP4&GU*iyvV?@XCJMx5`aX}LID)E3=W05fH1ib;et|rbYO^tg0
Z7mXEWL<j9lgB@a1=G&v%b)Wz7{{VRD`t<++

literal 0
HcmV?d00001

-- 
2.15.1
