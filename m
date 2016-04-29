Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31943 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbcD2Rnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2016 13:43:43 -0400
Subject: [PATCH 2/4] ath10k: QCA6174 hw2.1: add board-2.bin
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Date: Fri, 29 Apr 2016 20:43:30 +0300
Message-ID: <20160429174330.9072.92458.stgit@potku.adurom.net> (sfid-20160429_194427_860757_327885D2)
In-Reply-To: <20160429173841.9072.66852.stgit@potku.adurom.net>
References: <20160429173841.9072.66852.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file uses the new format which contains multiple board files for various
boards.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 WHENCE                           |    1 +
 ath10k/QCA6174/hw2.1/board-2.bin |  Bin
 2 files changed, 1 insertion(+)
 create mode 100644 ath10k/QCA6174/hw2.1/board-2.bin

diff --git a/WHENCE b/WHENCE
index 7949d5acb832..6901069aa7b5 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2550,6 +2550,7 @@ File: ath10k/QCA988X/hw2.0/firmware-5.bin
 Version: 10.2.4.70.9-2
 Licence: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt
 File: ath10k/QCA6174/hw2.1/board.bin
+File: ath10k/QCA6174/hw2.1/board-2.bin
 File: ath10k/QCA6174/hw2.1/firmware-5.bin
 Version: SW_RM.1.1.1-00157-QCARMSWPZ-1
 Licence: ath10k/QCA6174/hw2.1/notice_ath10k_firmware-5.txt
diff --git a/ath10k/QCA6174/hw2.1/board-2.bin b/ath10k/QCA6174/hw2.1/board-2.bin
new file mode 100644
index 0000000000000000000000000000000000000000..3e0da12c277188e31c081773a9b5b18f86f1d91c
GIT binary patch
literal 263188
zcmeI53sh5AzW+}Mw*^Kqfe=qZ5>6muQXfs^VW?0Zr4SS;AR<9PKtRBvs6`$Han@K%
zEk&pGw%A%ry>mNV3}ZWUy?1$6r?>5`eceI((3$aeY=>#Nb6K-k-2B(lHmj>^`Ty;c
z90<t?Ch{`y+s@{<&+oS%=Y02Jnw;}t@4San*Q6Gh4EjxL(jH08Pp29h8YoCKLw-`!
zCdidd2a+0h)~!BRy{BsL{v<=Zap&r)>VtJVtCRHlnCjIBnko;p9(b&}VU1&r39r3w
zOiXNig8=&bT?ENup+G<hJ98=GqLTNKpOl26AP7ky5QoIDC5p<)NR3$+TW3GA8I?*5
z&6DEe<G;Uolc`eOLs3G%ix-V=_yuwGgj|8xl9H0bg52zMBRQzAt*+djL)}aH$D7IV
zw9+!Rbxe$q()k5ar%nY@BKT)dVkH!A-MZE3m`MySluKID!{{h?=&cQ6_3P>i7$2XZ
z7_Jj`eCxNzlN~b&I*&g##x<FL8`*hJz%SU-xXk|SleCAu9!5!vq;E<+IlJ%J#9#9o
zq|<#%sK%bNFeO}?T=(>;-WLxy7G>tGINjab)74Ovl&7#*etv?2z$w?j2{u4ln4m>Z
z?}@HG&_ZRgK!88Bw(|R_#T#%V2)a=LRA5#VXdGyKYJh5d>g+%pWHN+?OOXttv1hrw
zzqZD|MpHgTK`I^W?@#YC9ii#|uCB<M=*sbeL^3uwSkqtsT8wa&FiIFI6bh#<i9^Dc
z%N40<4`*)7Hmr+V|3D%|H8#C`mdkCO&-IeB%??~>Z2IK@$!(pa&V=RjC$=Xh&P1M-
z>F}{m;lG~)BoB>PMz0Ou7`ZxR872AJXV#Ic*DS-=uUdvk_OZ*F@zc#MsXEd3=6j!T
zpER89?FOuEDsN0F(&`Kfwp0Kmsnz=PXQ|qjqCF|wnFyVTEt#1}-A^F!997;_wAYxe
zU8@t9H|N$FbC?xsq1E~<1P+;Mj9X}0{ga}@DRufsXpPLD4HUJR>Wzi8QoSs<HD!<1
zMBgV1oCs{A6>3p#OUk4AEu!UI;BmG^xLOP?8uSH|0|m4UTC_pn5jsj1z;?xdos0ML
z4qmy-9WjHFxb!_Q4)VpUIf0_S4{1(lPO$xSKAx8o!$DC2Q~(t~1yF%`S0KBfw!81&
zKe^=2%H?#}R5>{KtzXq@`s05y%|cMnSC<Ad28ymsyYSYp>NWjwzX=MOR>6N7iEmOx
zQd$<SOvx~1ZQ87lHzsUIBDJzh%Dc~Bc>5A(bINLZ&i&gvALUm*d-k{Q-@4`O&n_yd
z?LP75dCuk(LWAdDJ4fo1?>5eUu03aO*MECrJA6xrpW~MO#tvWHZOPeBYTEv1vurIW
za*2zx$L*wQyY1(=C9NmYMBL`*QxbiPTLHM2YrA_-f56$%p&OQAl1D~IM}|g6hlfT+
zhOXZj8M!_>I&^(>c=YQV;DkJMV{~Nr#@~mBEhFDt2MfnT*DZfr+-l<0YkwgYBvZ-M
zYP;3j?dxaMg0F`x)ach1D&>qpz|cpRGW2(lqsOy<uUJ40b#_R=2E9APz6(S}eM^B$
zzID3n*-noSsECVqpa$%GfFW*OoC6>5-g~#<1O9>I1Nh`qDv=Mc>4JQK^ZhYhKH%h;
zuI}=kDanSQlc&3mm)9DT4Ph3`&yG<i`{1xT<srkelP|M@6vJ{`;8i%>WlS`P#{)DQ
za6UEL@eDo*T_|1g3x!@(02P=W1zh=nXnW$=0Ai=W0>(pg!Uwd$`+vx7M}QCDY?F6<
zKy*!XbZM1ZVXlgh6_!gSoQ)`pP)AlqMv@%0Gb)O+(n6_JRxFpx%rY4bnX|JqAHLNq
z@&TUB*L3-S){ct0)O16HA!1*1#qLy-VWnZE)q3O^s_tM#V`{cRtE20hD)y#sHmuS`
zSglV$pv}A|wLmR0++WvX-kqAKV{{AzdMI;C)~<vcb%Z*?+zh2W^$PV0wuSletlbIu
zvM}8`b1Rg#%EHz6*#d1@^-wQL9R)3Fp|nyBgTokR64)Y>=whJLS|}~oZLkH}p@Td%
zBzBA(b)-6y4e+bAP(Hojb-2v$yh`G7HuK^@K44yC$3am6Q~(t~1$;sQcU%DHS1M?U
zEz84{3c1ud2M6DJ!=&kt{eO;yPwO=U@x<eKVd>Ia@0dd$kFrcEw1z&ug7tV@2nvEh
zB?EDm@xqcNaE5-zLM>hurhy0e^G&=PJ|MTe_Qd%M?`7L<P9ePRKgaO_zz;b2$@_l*
zp3jrnA(p)FfBuY(4<MsD`?Cw+T`F7OX4(EH)t~GSD=x?_4K|lbinr!~Es+#UmX#ET
zC_+NRluGzRI%j{GvaGbEM4>DzD}|&~lqeM8a=AQQCX>_Te4PF8cY=yy_)bqMZ{Hps
zt|$ptkR+3Zhm-owe&WM~3OFjjaRHp2nh&`8<<xw@mtQ*ejpfCsz;yTk3K)XEFp4@8
zN>R?Nz-O<h1<!4e1)SI*LvG+MzO5D?AF#fn0{H-PN8<Vcckp{T-|Gh;A24~+=HgNB
z<Pq@*6+i`MR{`V$kPo=?I}G^%&$L560QmsEJ7q3DQ!U;x_!OUeAMycnuQ`s03ZMe0
z04m@s3UC~NJBxgP_oM*d+#?@AxB=t?`0fq#d7}Ww1#lMm0B_X8y3Pt9AK<LW;yPZ?
zd_b(hfdshS{sOTM>j$*|aGUi5!f^cnPkv8u{Qzf`W?=n*r^_qZ^#fk&>Vb6u9yCZS
zmM5Mj>j(6}`T=RMe!yuqkZh1zEJxYE@$wpW{Qxci3kyJiKP}z|w{EYTUnumV0;s_3
zD1dwb@&R{#XCWWpnRe6W1KKNUv$Dzh0j-BB>Qgff(S~TN^=J>pt{Sij)(=>|uhm?W
znypjnlveAL5NI_wq;63!Gpwy^HrJ)*>QrQ50SLff^w%V8R;$#iiuSyQgj}^otzo-j
zR|Bvu6VL+d0u;#PYMm|6npFq&BGpmQVh@y})i5~estp49vQSuYz+ou@5@?4G9#J!D
zrs7amHH-#{ZNaaW+m8bna1jh8@mvy@n)Bj7K44yC$3am6Q~(t~1$;sQcU%DHm&>K0
zwoFU-_8B1C3Xt^!*!=~@3*PTIK(-a=&KM|U_ZJv1+{umuu&sckKkiL-e}VCW*E<e)
zPX$c0;G1~2d_WahKmgVWV6E-%`zNg*Fv&mr>jy~Wxy8X|i8)M`V+Ok|blJ9TA=_a6
zfUq#Ket?r7*AL*EYxK>g0vs2>*{S&e++Sce=VBrBjeNjDn8iE4h6T+B#8i912RQC8
zQ2OQV_yEHclH>jYoH)n_a7u6%`2bMD#~vqhbB7icKn3PP0T1~As=vO*zrVj<?!F+s
zXRx~~eQ<D)4uHy$P<gx{@gF<aUo$o~79(6Gj1q<lg~F*z;*hZAaz$#|!<iei4eR38
zKafaKjZLt(0Lf%uflmAW0>pZ`zrYIEUtmR*MpIR_B1&1QR&rKTrHR&5uUHWYdke7p
z3)pQqELIq?BO*dorcycPxtN{1eGKFSJe#5E@&QF1rbqQ@T7#M@I%L|T&tg`ogV_BA
za@$iH^qXjf?1$Xel->HxG$W&6CI24E)RMAan?^^<sNA-cy-?D~{B40w<8JL{kxG2a
z)NZVY5+k++QabeIOu8s4@TRH5_^387AWR%+Yw=S!B=v-*$5WcL*|c6JWx)Z{VPgZ6
zW)B>M!2MjH1IE}SQiuhn)|3O<OnQ|pgl)mEmXCc%!P9k_#=BDzm(!dV2l4^)B0CO>
z3ZMe004m@U3UC~NJF8OB5?hu_RVvpk@*nHgQ1BIVQX#|7?(w*=#DDCviL@Fo1jCnC
z*5g$n=*O{h^`xKi!jd1yx@|psR_I|XPrU8-zQi~2?)U)MCxG2wz-C?d7ntk^K7id<
zAUoH-zd&Kx<oyMl{A7OuZ}t~ZlqqCo($X@{N=sy+CB@4X5(z*eu!gpSKaBWG6{Sj8
z6F{jT+Y7+{0`l<Ua7c344Ny*0aQ4G7>_wnbK^p~FrMy^9>W9;`Oh)QE`-u+|D&VL9
z#|3Z}`2a_Cu<We@$Om|<*utuhe89oFoz+P(F|kI6^#e{HVfldnq#h!(oxBe=O-iBQ
zM+7_h0->1Z)(^<ZNR5e$ZE1A8D^w~mG*60;kN^JWO{Pk94@C+6E?!J{!!L-dMjp?M
zC;0DvVL@(ox{-M5YpW}_=TP@j{_*DV8h2U%sL`Hueu31fQ-PES{*iRA-9Nh~NWhK9
zjn7aFJEYLQzk&7J<H?Sh1SM<@_J@{S!PwY@!>dwoa4_YVX_}@;mP)0QvKO6B>@RSd
zZPh2q4SPL|k`_tdlzP(5Wj68G1a{!`>Aoctyx+JrktWyed$sF8`9|}7#TWa|bnPwA
zG_Ndv+hTe8IK>7wLEr-jG?tsp+T#DP1^T-7m1miC(4wzve>ti0uElcfIK>>KcZs$I
zWKu@$V@x$&D9Q+kw+<ca;sPcrLA#Hspz}p(0qd-mr=Fsic6yJfEFgzU);2Ju^kz{~
zz*_3#r=Ud}y<1cgkWD2qkJ2Tg%>hZ&T55y@TIf2FIUtMLpxw=Er#Fc<1gxgsB>^&c
zQ2>m=?5B5%3IfupILbl-WQ<aFjC!V+ZLuogv&m!Zp?8RK15zl1EnpjCBaG3&l(1*D
zCg2)r(J_9yq^pgh2Le`!NPs`tA14Pc36U>XtF&nuWo1vaoa}k2_e>vY5GWBd%U9Cc
z<c-_Q+76!RdEwNHte?a%p#rGD%qif?2WYqysZwa{St`AJEW@u>b9l-^KUc?XVQMO1
zBI=$GXnUFE1CH4F0Aju51Aqh2C?l#$N~$8lw^m3)I2%zGp^mJKj3k-m1MHSAqG^r`
z;5Y$dXKoIBx2MLo9^f^4&VKWk|NWnDzZv=4AO1Qvdi~m8zxmVEum1MOt6vU(e)-y8
zzxe#KKl<(!&dixlmk&sNRo5DrEYJ(|sjuid1aX1sf;g-7*a?aaJSezdaDQr_u3Zol
z_>drm3$z3#3DyeMCcL12RIrZxvjtwz?G7{q8U*Upmvs9B*9)`)Ed+i}W%U{kiZ=wV
z3S5=itJ@P86Br|ag#}=YycZ4o#OniB2CmF{$<QWF3DgJb*?_q>p+)w9c&&JC*7FHJ
z6DNoh0%64g=*oNw0tw<Z;x*8Azpbs+`qT-^*r>12<}xX?KBh^wQ&1o<3D#e;9y>&t
z4jF6oh1v`zKISo5r66CBDTx1!1dQ$a25l*mO($+>SML<$2~q_55w=B}ai>0Co5rl$
z(5NnluHeeq7TOl3jy8+30}?lMs&@&t3ep8J0oG%kl(AXAOIyff(DBB{^>x~9OeVeF
zGW2vOW&iAz5fEo=fht>>hv_)c5DczuhOUaqhb*>55oy7UKv(($+A3x%{jey(*vfWF
zT8uyoeFsxXZy}%W*uYjMosMHhU<`e;ww5u&C!-`7qXx!Er(@}nrw>t$9p$@<c9<S9
zu7~rh)^1_a=$Lm$x;x$6cz5TU`1wAoz@=ddg(gCqmRYu=qxsA;|8nYsSBZc@%R-cN
zbohM_n#?;o4xT!G_Jv>f*@eA#saQd4!nGSR%{vaZ{A15QzwobY=w5NKQleR|U2od5
zqp{`KGcWf3;uU)n>i?E3p%szZ#MIK#Bklim{Cw|wY{>72AhCo|X%o`7mj1Nu+2b$0
z(9e!enqBcHUqG7^DC+x==7i=1+fV1?o|k)H9Up}o4J|5w3ZMe004lKH6>!G|aQ;X}
zrI;#9Bx3`$e#fHwrd=51`k7WCBxG>#nE!z3-DwtPdg7<z1Kz&GzVAQ(_9cEkV8ZY9
z`T<2H=gE~oJJ#kDmYpNV`IXO}<@3Y)dU<g%`C+%PDFB<`eZL&u_>cRGZE@TB0VVLx
zp9KUIfb@q$#c-%jlm4CkIl;v&H{fhVZ0{81>?eI-LIoTZD5&l3?HhRe6V6_{^5qxT
zzWDPOfBf`Mm#$v=!|$&SUj47nKe_tJryqUs@#POc`|vM+{_iio`qLjSUAcVu<7-zS
ze}3u1tCxTO!IjIuzj)>H;0KO<V|no@aPh2KKtB;pi6B#F)Pg>E%cX)Bbgx7C>mkeG
z;lEf8r<^ee82ac^TmBC0YmhURCPJMw|6hNa=D+4L;S5#>#0IYh8yl<-)|2Dl)xi{4
zLBz#nC4Er>KaiJvFa7Klwcxo8vY(vTAR~vE=2HP5oB^7#3APDLWz&JA#+`Mm9d{3?
zs%GE$>-ApkFOcBC2fUNXvwi@K7QqfI5QzQ6wo~B!>Gk>n#YJ{LpyAQ_aXvt(OXuy~
z8>fvAh=~zW-1~X%eLeIdR>BW>58dgQN$<|@=ZWvm(#)(MaA#xBPOAw%;4(WvpQPO@
zK47}*2lT#pcz@BxJYD|#y)PWzTa=ln$-iK+w4S1RUpjoCC_C@I{11Ci9o|=zl^31=
z78htL+MKs4|6_X<T|R&VExm5^neT_H{HHaqXT^U?=tTukf!R^Ol@ExvCru>7a9J)V
z>j%_il=Bq06$PYHvVK69=?G1e^#f|6E5{2nyM6$yA;7L5Fm4AfG&cQmfaJDLvc|xK
z<?|=DCnnBBo}KydtzL2c0MF(tyPyc3CY=6Yf<>HMx?L|Po@#7KDblXc(Y;4n4w{Pf
zaRzu3-_b|)KGWEiV%BPP;Sgvxl|taYi9m^Vl}-hL76>F5*0O=FuG*HA?GRvkkG8a%
zD)kQ<Vy)IgebnKn%A1Y3Oq7~#Ia<_aEN1Q}+X#@r(egH94#TLW5NI(LF{{ar1Q3A3
zgT_MUJ~h*LB=?|k2NS1WV+%Z4wBNXeiB>CHo-Ar-yIKi>SKVCZynf`s!Chu$p-AF#
zVdy{wPyti`6+i`0fxAipjstLKRSG#hRThcte84md!NKr%|C;`cv(qjN!fF9sn!~}t
z(<*qsYQRJbz6o~22b7d|pT7WnfZgVl)%2YEH*SA{TeqD3gb(OG@#cBX!u$T3p66dX
zN8b07Z#K?;u03aO*MECrJA6xrpW~MO#tvWHZOPeBYTEv1vurIWa*2zx$L*wQyY1(=
zC9NmYMBL`*QxbiPTLHM2+3)n6#q|Rg_x&*4tG~1L0}6o;C|t_&1Yv*`z}hO9d{cqN
zw|;<rXN|+I19q0ckf5(}-~-x!;Nb({wfQ(75XP+^z&Gn&^8vHGe!z73fYDLDtMtS-
zGkm}uuOHyaDSBCFzWIQYXS$v)uS`ic1f6`TtEYUI@j-*cVtL|e>SP}rR;Q#HmYqD!
z29ga@i{&UAI9^_3Of-nc1IyU}|CKM4$FMVa9sEL}7ZpGSW=8>!`G8vB12lvWa9036
zpugYF2XuAW`2br1{-$Gau%^HMwTTr1rY^Z%KLGX?nC|)k(XhWjX_Z=Gu8NQqmP;j^
zb+>+iv`{LQ!QUy!%rY4bnX|JqAHLNq@&TUB*L2qpXl<{k&B``J7$RB^Rn(_u8lnyG
z?*3>GRo7IpH+7Rit6RRW)m)RBtyAihR_l`xXf-#aZc#5YtgUM{*QMs_RJsT@U~bN;
zN!YAbsZ|y2c?}7<Y7KeY4_%qtvg#A^)KTgva|@ITWO6ky2qe&&RR{GV)ltx550s(_
zH~?cni@Jn-S*UIubh-=Lu28SA1=^v5N7Rg(sW_BX4WmI~1N>^u;0Flo%0=SED~XE~
z^Wq?X7T~;Ifb;RZoEQ#@3ZMe004jhA%)0{axB$*CmrG%3d6H=f<S^$P9Q@X=Oq%}K
z-%KjhYWm|@kH>|epsy}<XABfxnN%3a7${;rUKHN?RlTG??#-Ye$AYFm?l-K*)565t
ze(y_slj?>K$Stp`g$)K^9{|>}>j#|S_yG93e<weA|9_$n_yG9hX=2Iy{^!rw_y97h
zvp>7QyZr^iiY4;g;$XAH945;#gWVRoY}>YwZ6TpyVPWv6c+P&?`T+|2`T<He>jzBu
z$^HRkc>=N-!S?Op;fj)Q1xYelcsMzKXFu^_LIoTZ;J5(JA|K$W4wk)D;LiAfXy5~)
zC-DLPy<!11)Y%~c8}#mwz`jO60Im_>?TpNA{l&)ztgonW<pW~$v9S((z<clAh7b4$
z<O4jpPmvFBR%yEH2LK<?UA~j$15S4xFRwKw8^SD>pB*E7z;WOM9s)k#Wj2sv01SWx
zUWLP5EFZuHXg1({YPRFW`{35?mGcXQUQ_@Tm>mU>4?sTP&hISb13c4i+I&DqMO|t-
z;RE(HSL{wT8CDwL5Au&ZL)9IuXiUupK7eLPfz5_h1Os>i0&V6!sRe40;r_Z7^X}9<
z9iw9)05A1h;8lK(Izk=c_);HQm><vD4R8Cy;B9{^l(x#k)vy!+2~2<k%~`d80jyNR
z;9OvfOrnc{PHPjk$d>Ci*aGd)K^~z3*fDZ|Er?_T{A#)VIDi2c!B7&<C2^@aFAn4b
z=0$cK6cs=PPytlHCluf~0C!fYpe42}4}<;XrOr7x_|_YQ5BPtMg-`1>1M$S;d12|&
zTkn`dACIz3Dzt_^zJm35TnGw+K_vrmmhr-pC2)p*$3iV$6}+bcCR*@Kyjwni-~sOe
z2f$j_{RJlbXP*x!$Sn;vmr9Da=724c6ib$s6o)8)4^S!zAK>IiK7eno(Knk4a9jXq
zr{)8$emVN}jnUCz$U`?qM}}|weR$Y1^38Rya6EMV%P(j1T(R%FUjgI;?*2KN%`-$k
zfZdBA#(;c4CoI9#N$xf0{RMFSfQjG0yI}nQ<O3$AgPMyc(+<O75fwlMW?cc~1CS56
z^P3F$0ME2TJ^=XuzB^?uK2t5;G58dpdmr)vbFVp$hzg(rr~oS9D+;*d0ysbN0Tb{2
zJuUIgJ@Nr^xjY=#58%5u(C3W;92dY@<O94>59>NBfP8?nB8%%7`2ZUqunzeE<O4kT
z)ki+SMWhA)sMqC+(SZt}0<)+9@&U*P-1+T=e1K=#As>Kz0N<Um;6KpK>jm;DKKDN4
z1Lj_H91#^j1yBK0z*iLDH~@DR`2bI;fQfp1bB}xg@&SDJ1^T>Ifa3x<i+q5$3Sxan
z1&|MLRAcd#kq@x(0Wru2ARpktuRrnuE+WnA)7H5d+~tbVfeN4kv#0>_0muj3`R#>#
zfM?nvAAo!S-<>iSpQ#q_7<`J)y$|_-xz`*=L<LX*Q~(w56$RXJ0h}NCfQk41o|gFL
z9{B*|1NiO>^m(fQ#|3Z}`2cSf#QKg3ARpkU#^Nh4Xg(m;u=+q#<$=}%k5xCUIas}?
zYVZCe!}^K}2X9rijStYr#x;;<Ccldyx%5kcfD(4*Qp80i?_=)^Sau(RkOTs8n1L<v
z|4=H$&^#$VKK}cgH<>EcJrpJMyLi#~hF=iZK*$w{g>{7r3v#p5jpU%dwz_hA4s|c(
zA8#hd(@L-@5~P?IA*J&Rq)wd*q(tz~p2SKhkUa$)Gl}8;0(OOX%w50-JY8Oyl57Y%
z`BGO;`7Yyw28qS;#M9KtJ~*sSNi!@vd72F*8>AM?Q8sYAyvCSl5RV6zvjLu~1J~kx
zaO?KU`GrC+Du4>ijshO?0aSl|jemcCzubL6de2~YSNh=KARPdeBcbwmLE=AluD@n%
zY%E5&N*E;!6$*t@m&74q%jJsHw1+b{W*gSUt$!eqq8giCKFj8|m(R9!KG)mG*`|RD
zjZMECAi1rR)S0k+{uMRR(JQJnnyRW5QOZiSlCzpBO|+(Z#fr$CQBhHlIU8Q0P(<vA
zh)|WORE~Le=EJvoMLxi@`I;^tP}E_1RG+3bsHvhurak&BW|ca~YCZA{mD`@upx;C*
zWIyD#rtH>lrWqM!wLZ~9nOaizYt!gR8I{|XvKLAknZGU2Y22;dEK-SYnc9u@P-4Wk
zKuU+coJki&1>Q7u7$4Q<1%!zMZ7qHZhoqj+^ms~>Hk;PVq*m)u7~`<9fl0Fm4np95
zF3<sEY!WHN0#j?s0c|F|N*2Pl;8)A-#{mqu2!@h)E{RLcd2t{gFfX#>pr`;UfC``j
zKA`}|0l2d&6)mx4xm2Zc%_9G?ZVd%rF((x={Olf&3rqaRE}KZJ@j@_sd1XCb6@q>o
zJ6BKo880mPaje_cvuA}Kwz8)z0AD@6iFd~b)OMdZf8o9CT${})tm%3F+&drTS3Z08
zx9?Mwvp>72r29nQo99_S*qp+$p6AcJc8=61qdNPubIWVHN&NzwW&3xm@8nmMDP(2R
z(lX9UOJt!X#mf~ENvK>NN>L8}Fyb#&lq%ubzEV+2l2RcLFAj$!m&s&uaz4&}I98Uy
z_jzce0IQT2%SruknwH5(eP=)MVL}BQ72vo4&Q8q-j1G@}ePeWV81m4K(UIXBe;*#U
zjC^w)EF2GAxBShqZ!9l91&|L|d~@!2#mEQP_y7a)0l0pE<1dDrGV%c~!YufQ!!B2h
z4paaYm_-GU4?sTP&TlW|13c3X`2get`0kVi|AB5^FOX01x%VL-F!!3{h^PQ6fC``j
zzM_CTE`akRAHYWdOzq>Fd*lNMH-LNq-@So8ZxrCT0L~&G;Ej4%*I5DN1Dq9ET*t@<
z*!X~T$Oj-F;K8px@&PU)&Fj<FxftB#iqU}zpaQd~0P+FI2i*DXg?xZ#+94l+d;s5_
zG8dnz7Vj8*iqE|d`GC3C97jY2Pyti`74Q`WI1a#_MLu9^7Jx6xH}}W~ARoYYU!c!h
z1voB%v&aW{t02~QQ~>z^M>Q5-8TkMk9}qW*4+uJWoBaj;0rwa1<aZ^A-JhYWD`0$o
z1BPO_hV1?Z)^Cp|J7yAe-rrzsjB7Ig_AcN9y32R6`wN`zI$mCDOg4mBEI&I&_7^w~
z`wKh-`wP6x22u>LjQ|O}3WvMc{ROxH%?9|zT)Yo%-CjArQ0PSkP=VP|0Qmsq1Md9J
zLO#GV?T`;ZK7j8|ar;3C11@rTFNsSR^Ws20U|wX$K~Vuz02M$5d_n<tTma|yfDahp
z_7|8aaN7zDcw89YR$#mU+X~or9Pp|T^y96|^?tCQ?08`bc-Soimi~C_o%I6Pdcczc
z-+O;geS8x?6(8{L_WcF^{XPEu1t$FSxW9lxf%^;aO)UE6SOJa;;4Jb1b36eHY&hft
z7TAP(c{#`j*!X~W<O6X101tk5kPmPX$@@p7KGwqJiqU}zpaQd~0P+FI2i*DXg?xZ#
z+94l+d;s5_;$t7reC%}j6rXz^@&R+NIgW@5paQ4>D&Q*$a2$X;i+q5mRKP?%zPU#}
z0M`%TyD!k^tpXeuz**!2yj2kEJ1T&DfTJ3VuZ(<vjSpCld;szR9{l<vAK)UAk3FCD
z{&Zcg7#*kpDlm%*ARmByz@6V-$Om|)9r6Ll2k_k~-hV>E7A`uvmBgjyyf}~#m>1b`
zP*eaFKm||%pHRRZ7r^<E514rG?`er|;*k$PK7jAOK%ch?a9jXqkq_`zL9Fkn0P+Ej
zYAn9;g60Eas#hOqsyxto;IZn4H3zHrRPEiLWH3}zIe4q8Sw28-)W<fEXC}XkAi4dA
z+w3n87Bj`IqEw2Zc~X3Q{P#C+GF7U3C`#ye@uKk!zaXxakSh>dQc_Y_kei)uBnS1i
z)s@?GsCy~@cr!VkR$9ikj)@VDukSCSL|l*T`u?!i6w3v0mIR&G_a7bQns{q*e*tI3
zzGIWK*LHjj(&@e>6ujSn>EP1jx+l+cJzZYO?l16CR}btP@Ss6ru{`lK*<YXs_7_Nl
z{RK|5fn<Z!VmZnNj+fW4`wMUZ*mwW}{K@Te&BYtw7Ye<o04gv$3V6r|$op$+{A)Dj
za`y$Pbg;iay~}ijru)0PB5R^6#|sk4*x+DIfBkDQ!d1d3VW?0joVp|q30p2#q^3Qb
zxiQ<YE^hq;i4@h?^zzxpHd}5x@?0+|v$kpALSxe}2S{$~gt&v{^GDZ2N0(Nq73Qi4
zSz)<U!r6$j2z6v-WF*N^JENjFD=m~tWyNy2%q)}9kU2X$^Wj^)A|K${d`*`RXl<{k
z&B``J7$RB^Rn(_u8lnx+R_oCos;;SGZ|Ww4R=0d#tGOmMTc^}1t=1<Y&}wc--J)J*
zSX<X@u1n3;sdN!+z}%cwldxH>QmZQ3^BNLz)f%;i?aJJiRiBWjj#5XNTcA`RldE;M
zKx<YV)QeO{L5n?5idMtmFb1@!OURdn>efN0yP)j~^$J^{9XfbK&8V4*Ls``@8YDKr
zuh!!Iyn|Qna!1UdBrbi=iv#(9d669lMFmg+Q~(w52?aO~z@3%LrJ=S=OXPAo%sB@K
zzx6AVra$&KlM1z({&?2oaUm$^t4rM(1BF*66$UZ}idc^qg|~iHFX@kaGbqThpy`kM
z4eRl=;3*5hSC4Pv-SGkCRkbJ1U&zk2S$2PcGw*zqU-|6W-@Z>#&VJZmp!P)Ho9D@F
z5t~z1)ARh9*UpjpWK?H=c0qY<H(TFkZT&mepX?7SmdJC9gUu3im@LN(c3bGOZQDY&
zg@lHMg~6kCXMdTpthA&=p)4yag``xJC=}sxxjbAZlhfpUoc-_~Kv4|e=}G17+rz^Z
zCE*H^WU}yZQs3E6e3(!HM+G=8fV0R4II4qXZxuj3z+1%@R{h1t2k7G}UHO1&y|Ehk
z0AK~k-Hm*J``_`qVEq8(101Gj1|QtI?aE;|ETRIaz^p5Pd;szRcYc#0AK;mG$Oj-F
zz;~y({UC$^7rDHb#HEXQaUdTsFS6sHr~oQ}3ZMc$p@2Isfb%0Cz()W~?c<wx<O2vd
zfP4Voy@5V&6yUf3&LSV+je1zuSpnn&oE2GI$BT~-;9Wn!fa?d?))63gKk@<Y|33iv
z02gh%e?;nIEnKb`9jE{*FpCNxAAo$oo!?%_2Y99(@&U*P@ZBjs_VLWePM1&dx%VL-
zF!!3{h^PQ6fC``jzM=rf0l2fs2TaWZ@J0FN9{B*|1NiO>^m(fQ#|3Z}`2cSf#QKg3
zARpkU#^Ng@A7I~KU>)u+04v(#`T@83zX0R|Tm<s5=d<3QuFDmp0~J68W>Ep;1CS56
z^V<vg0ME2TJ^=XuzB|SHPe|CpMMt-ixYV2%2l4^)B0CO>3ZMe004m@U3b^9}I6v|M
zd<4MMKE8=ZJ^=XuzWV}w-YURx0h~oXz*_~ezM}%j2RN#+_{zu!*!chh@&U*P-2V3;
z`2ZJ<+&&3iC;^u%Mh7Z@3e2Jc$Oj-FaObxd@&TS{hkO9?0epALLiyZwcU}jd;&bmq
zK49)O#}QEhQ~(t~1$;#TjstLKkq?-f1>lSF%{}q~$OrJ<7wGd=0gemcEb;-~Dv0$R
z6+k|~QH{k{UeJ6%tYP(mrpg1Y2Og_#SaYy?Pu1T2Ne15i1@uOJTmyM#^1BF<OTQEd
zC}C$VMO;+!KK8zVW%nTnNgxo18Q2p452aEJ&6DEe<G;Uolc`eOLs3G%ix-V=_yutd
zgj|7G*mtO~AU8YRNDk_2t1GwXQ1?>)@n&*7t+b479TOv@bbf)<sZ)WJ2>#iVSP2Ef
z1UP0A!~F&93h@}^16)M8J0HW&;90p`F*;BIRA3er@Q@Fn`s-`_`}_Ol?hDd;2D`h`
z2L}h~0H_=ZmB$Mb|FLuZHDhCAF~U{CC}F5jD4e<^4hdT>SEQyroVhXEur6->1Bn#X
z*!1#QHn+WewypEI-bT(g4P0n!`sD!0ZJngfgyr+EsELkVQKivTRjr6pR;rbp)l_Ms
zHPtItMDC1=ih|79@Dhb0Vn;-Ts!XMF%(FNtKGQYw0iI3Oboqdy4%4IhG_65R6&*6|
z(PuHM)InD3k!Psf_LK(wCR!o;A-6SUw|+Ct$SAAzi5|+-lCoc$Mn}r1+_sdxP}0c!
zZGleXZtZ4~N_@-IZmfqABen%nI`rjCx+p5}rm4gDs5UPkOdM!y@l!Y?^@OI!Q<}8d
zv|c8)T93jQhm8$Pnmuq30{3%)4j5yTNFf%OT2l^aGwD^b5Vi%sS~K_o0=sgNc=1Z&
zBE`HokPny_*>O-*02M$5PywG%z#SLB`Bf@fV#{)=O68hG{$t%53cg}aDrETCJsua9
z_>WySkyhh{VEFRNdb}zG{Wx~6p7b+bSn}gox2<Q-3O#IPzW4r~`uHZ^9UoBJed7Fu
z_p)<sHm9(r=lOH*e3W1L?AhPGPf^bP?4pwH6Mb)<XZ>Jv3d?$)Kl9o-QlE_K?9a|E
zuk9xF3v8C{-?6@vUs0xzl}Ss>I4doYg_aaAS4bqGa(O64Irzhfzf@7GglGFoMJY*2
zg*?1C9FklnlgY{XIQ!vPSq9(dp^XBpQeG@4^}}geCL{Ho{ltd}6>wC5;{rH~e1M}m
zSoT%{<O94_Y+==3(0o8lH4h&U8(Zbzt*U0%4~T{5{SJJ<=_4#3@SoH}WVVy{`BPL1
z1wZV3fKW`w*l&ZJjMSL8*p^1eyF#Vn<pUBN_yCqW;M%}{_h*$4Amcdm0rzr)&#Da)
za6AGxK0`6=hyX~ie1i4c<H?Sh1fBVWu`#xZ_dkMzgDJ;M(=<i0R4Sd6z36#@4>--X
z>XYP#y&gtMi==N#J?Z8$oA_&f_uY4=PxmdM;Qa<58(f-Px9`=i1LYgd_Z464JJYqd
zJkz|g_-%{j>Ejd|*aU$OAkbKDGHZ+f!xrf4+E<=s)<KKDuKnet%DWcJvEvkTklrQQ
z7LZ99wU05?bfG9CAl^E3tcwens08gkrh?8Fr3I|BTAq4}V%q6FqOyP-Dp}jWl+v3;
zNdarAkDr1TZS-zYNkBH0#5_uuh&Bf#QERCY5@@08MCO1jYJ+w+vz^`~+7PgsdY1&q
z;6(v22D6{uDJlp^r{X9J36L>L*)i&wVz$MqfX^n6v4`Fv$_+@N47Px6jEyix15?7D
z)tZ27q(#U0>5{HCiXI49B_aX-WPfBGxFkfrT&>ckWt5dY(Q>lqrQS1rq(PuW%q(9?
zYm+x_FKat^qUVKEFS33T!-NW;0yC$8D<7cYQlv_uv1h6D^05rRTFv1p3;kRjw}q*x
zfQhJkKA`PomJ2vy=L3lKk`Dk5K%<PPDk-Uo2;W*E4dHA=S%f;WGBT26mJhI7x`?JZ
zE`Z|%h@H7P@ZFvo+j`ED{LNqf_kX_qX5?>w`0Lo{^=p6q=1*6@`r99`emVU4<!gWa
z;`7h`=(|@qGiN?sJ|Oi~U29;nKrhgzzM|_8#091c;;hzVCnz@Xpx}PN{i%Jrc0o+w
zLxLDC&=Qy=SSwhY@PhhL!8-EK7I;CoJJ1kl5U5jM((MmiFVG6K5coNj)oVB?-VnGd
za8+urZckuLV2nV+w#a+Yuur@`aAn}itd|UJ;*>yrpq>qwdlOn@4~W-_*JeGR@H26O
zI3ZBSc4a;Vfdugy@fv8m-`3V@ed+{dY}8k1bD0!cAJZh;DJT$_1naL^j~${+hm1A)
zLTv^UAM=>3Qjjmm6vTf<0>*ZIgSM2(rV}@`t9J_W1Staj2-~8~xKp36O=H$=XjGR&
zS8(NQ3vCNiN1H|20f`$r)w={+1?hsA0PC?%%Gj*mr7dJK=y>Df`a114CX-%o8G5>t
zvVZo<2#7PbK$We`!*rZz2nN?SLs!M*Ll)bjh_qlvpey|WZ56YXepr-XY-KwoEk>Y)
zzJsZxw~)_wY+x&sPRB7LFowQaTg#Z?lTi|kQ3GS7)3Nl((}$?Wj`CeaJ4}xl*TeZ$
zYqv0Ibj-UW-JNc3yv6&rf2u1FTpFfOXd<*}nPodVn$JA*FQ-0ul?WKLEJR61hu`<0
z$-JZE;Hl$hU-)&OUD$h<iWRgbT)QFDyyIZYKlc3d3;)W7?iB|sC7R{h^`<R58e5J%
z^J4EWUa>c!{%^?=S`n#DOf4-v(*94!&-cE^hWvgA5=$7BHX(g$=}+69J^s=Q{p{$Z
z*%g2C1++PVqP`DlPH0ZB{d7L=dAax1@lm+Z(4qpU04jhApaKhC0geN3XCoPvVyY~W
zj1AQK9gFUpc43g~XIh1jkio%Y{sX3Wr&*ZkiJyuOc>9u#19<xqKOZpR2R@*d<pT<U
zCm?)48Sn&?-uF-TL;dsQN;nHV!8vj~&J)<<oFCrT%ZrQ254(jw`ezfo@0Y_H|8ak@
zEncQ9D<ynDSs4omC;;gXhl=4)ohIWr`*VVeS#H4DirC&M%Gpo)z=R4oDgd{BZ{NV%
zpK$itl`p@z_QjvS_~WO4x^(r@AAWyz@alhk{>jx(KK<y6k1v1t*@u7m^M8Nw)t~-w
z>B{BHA78ry`SVL3UcLPL53XGP{lzPn2S0G^8_SDNfs1F=0{V$)N(7lYqZahRTP_v6
zpnDz4Uk_Oh5C6q-IOU8%z|cpR+VXc`UxS>nG!g2g`TzRUH2*c131_f6AU1e4*w|ow
zu$~+TuMVcb3L-8pE9r|8_<_9Sd+BGds0Gh$kp1Mu1{pcTG@lCi;0(}=O|VU1Dw_@@
zHSVli&8-d)Z``@s{?1>o_lggQM?PT2??dDRoFzp*0QmstdjgM90aU<I0ptUa4{*F6
zyelIg;F(^?2dqRs0QmriUzVxf_B&K_C{EP^`2Yu@u!stv0;m8gfC~7G0`9l~&Oa3!
zKw{Iz0><%zX<-2piM{zWv4HXBGd+RG2M}(+`Tak4jC{aM-){@IKaLCFEb;*hcdqB+
z%8(D33zhHUF^~_a+gY6i>j$hyK48XgQ{)4jB}F~}`2gp80*_GvRKQUI<O7foaJ(P9
zD<dD^nO?{TARmD12RQz&O!c<kvED>^susuxOz4CqQ~(t~1yBK0z;_hjH~@DR`GA?3
zOXLHP515%dX|eahaRHn~K47um5!1VV<O8OspU<~OKETcg7?BT{@tYa>0B1>&4?sS^
z`JTXIQ~(ulQ~>z^<O3Y<2k*+r2Y99z@&U*PARplPyE4_=e#d$f<*8aAA26X4mQVpy
z02M$5Pyydjz#SLB`H>HpnYlzh0QrEKxsw)qFB})ZS>yv2`yDa8>qkCddiwc%>xIk*
z#2Qu~XsSHWdf>6@hBe#{1hKJI4qp3S1h9U9!GRBWCsQDxgq^wUb{JIhK5mvH*n&VH
z_7ih19;;Nso*GnAe0==(H*Ydks(UC(=y&m=@eRKquC|aX5L;4QR9KLkoo=KW9<8sh
zt*+djL)}XWb?J_k?x?(sZ50zEq;!6P)TvW}lnDOWlUNA_*yX;{F_Rc<FTy3Qtq1PV
zTN}jQU0q!P<Kr_F!*#-rZ~gXovSTK}nH!%QYUXTY=RE<xV7t4_{_K;qhrJ#~NsFX!
z!p<zWPv5bLzuq-Sr~8&rjXh^!O1Lz+ZtshS_ZMx<)8)V4`@-S9MVWb;{0kOK>nW=D
zrNak`vh(iC|FHMe;eAC}dC~cAae=0y&3UWxKekuV<^PAp($YJ*-|?fV9(aydnp9Zu
zEhb$p9-soKz$`1^$_GT-lO~d3xGb0V*Vp*hWR&w1C=%-L@0UskySvi6Oh;%MJdrig
zmE#48|Jb?ynz6C57~v{mlrU5%6i!_dhlDMcD^k-Q&fJ)7SQoecfkcXGY<l@Dm)km@
z>m_BI9k|fg^veN~+d4^|3CrhCY)?#_i9E{_;}hM(e?JFE9vZQXUK_qKa&^cuO7gYO
ztRq*iS%$A)wG5H$6Bjd!Cz)MP1iKZU{($?W;cRa=^oge$TT+U&D|B@4k(Ps|Vtt%J
zXSH_pQN7PJwxyW0T3t8<noXq;xNjm*qFtp^L7)W!35K<7psTC4C1pDVnBJo;?WRio
zgN9hE^-v#m_^I+{V=fb=rdy5{wHb?<`_<95z|rzHV-CZpr4VQ_7BQ>U8a4oj2aScy
zeQKuhNbW)74kk{$#uj+8Xuoj_6RlRZJXzGvb_IOEp;z5p=7RrNgBR#B^K&7I%b@5$
z1yBK002M$5P=UKj0geN3XH^P0JyjNo>>C73vk)9ScCKF2pK*5Dg~4u<Uzg@^aPYJW
z{?kZ&6YPc$C@Jqgf8p&**>;;#R?~Ct-`@Eszw+6$zkUDKEoXmrQAut0i8s%4Hm498
zJpbA`QlEUcarSfVIeWYQ+Y{U2TRQw4x9m4|_~LF$&VEwU_CK3tYeA7qT%0{_Cso^R
zKgTU;J&`8jHb0+|=v&+hz`e|Vr|0bG&<)El$s?nqBSWL3!$Tt@L)UMNj9ecb9lAa`
zJo@zwa6%rsF*-7Q<L|@6mXU9+gN5Uv>z2PQZZ+}hwZ9MxlBr~BwcYCN_VqJr!Pi3;
zYV>Ohm2$=)VCbVu8TvcO(U1$-OhKK#Fp4@8iaPqL0+)R7#A(KM(wo3kHXTT6+*!Ap
zd;1@6+_~ER&R?(hiVs+ad;qWlMA?~pKaYHX?M|KeiF^QPF&B?vXK;*(*~1blfC|jM
z0>}rjPXNf%0Wb6H&&}OG0`dW#%@Ohe$OrJ<DKq%d3A^GG7=5S!Du4>00;m8ga2G4!
zjtk)YQ?UUgHcc#Gy!o`TfN{KFT3En1RWJ=az@Klrkq;o>^C#Z_x7&_v-~QntfGthL
z*{1^V*9n+VfyoMRTmWa0516bE9(kt#@&VrIwa{uKA8^pVzd#J~0muj3_SYNN4{(ua
z!9N3bxngvn0;s?&Du8?d`vjmJo(p)HXK_+|rfcK_Jew-y1CS5kyHghY2fBH^Kt9FM
zhYFwqr~oQ}3ZMdaj{+PA;Lai+;5{k8H@nCOkni~u@BiCvN49VO@DRY3CgSW<0ptVt
zZly);<G29MA|J5GZ-{ALKJo$66wt?;BOk!=0kOyjARlns-)7_kTqK&;r>%1_xXTrz
z0~J68W>Ep;1K1}3?eJW{%RGyd;xk<%AK=+kAs>Kz0N<T57oVvX?-+cFqYo881yBK0
z02M$5?j8l)aRHnk`2getZ13*LPv`gdaLj&x=PX+jTwHSY!!bmOm$OiGNY4Jd=l2B9
h<Ze-b;{rH~e8Al@GroBq$Ori5yv@{E`x+nc{{e|8p2h$G

literal 0
HcmV?d00001


