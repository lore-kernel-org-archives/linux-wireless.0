Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:44793 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbeIEUWu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 16:22:50 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        netdev@vger.kernel.org,
        =?UTF-8?q?=E9=99=86=E6=9C=B1=E4=BC=9F?= <alex_lu@realsil.com.cn>
Subject: [PATCH] Subject: [PATCH] rtl_bt: Add firmware and configuration files for the Bluetooth part of RTL8822CU
Date: Wed,  5 Sep 2018 10:51:46 -0500
Message-Id: <20180905155146.28556-1-Larry.Finger@lwfinger.net> (sfid-20180905_175207_334213_E26D7924)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These devices are new models from Realtek. Updates to driver btrtl will
soon be submitted to the kernel.

These files were provided by the Realtek developer.

Signed-off-by: 陆朱伟 <alex_lu@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 WHENCE                  |   2 ++
 rtl_bt/rtl8822cu_fw.bin | Bin 0 -> 22412 bytes
 2 files changed, 2 insertions(+)
 create mode 100644 rtl_bt/rtl8822cu_fw.bin

diff --git a/WHENCE b/WHENCE
index cda8a6d..30be952 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3149,6 +3149,7 @@ File: rtl_bt/rtl8723d_fw.bin
 File: rtl_bt/rtl8723d_config.bin
 File: rtl_bt/rtl8821c_fw.bin
 File: rtl_bt/rtl8821c_config.bin
+File: rtl_bt/rtl8822cu_fw.bin
 
 Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
@@ -3157,6 +3158,7 @@ From https://github.com/troy-tan/driver_store
 Files rtl_bt/rtl8822b_* came directly from Realtek. These files are
 updated on April 14, 2017.
 Files rtl_bt/rtl8821c_* and rtl_bt/rtl8723d_* came directly from Realtek.
+File rtl_bt/rtl8822cu_fw.bin came directly from Realtek.
 
 --------------------------------------------------------------------------
 
diff --git a/rtl_bt/rtl8822cu_fw.bin b/rtl_bt/rtl8822cu_fw.bin
new file mode 100644
index 0000000000000000000000000000000000000000..558037c14cb51243528cfb433c6ad4a829b716f7
GIT binary patch
literal 22412
zcmeHv3wTu3z3<xd%FN`oGYMpX2tyKHAz(-XsKvSo(ejueDk_57JqhE4nLUXHY;AjN
zH;C_`ARrLvxx-9A8iENk33~2n&xrx6jnP5?^+0VSpeM`&1`J@^TXKK@Ju@MA)Sh!s
z&;8DKzdPTz_F8+*dawWbzt(^M@3z~dRradtqLn|<s~E>rtmxLYBZ?Sf9k=4~Z+?HN
z(pHxGg@)2VS?QWm`Mr{WfKciePn5==(~+JYh&^W@JtLqz{k>6}w>K(##gcWQ-sl>y
zTq>8k!@bceFS|^6`Y0#87_JXhmi9))&fe(iPIkGnWDVZd;H|22LfeFZd~!nDL_8-d
zPdWOsSM73z>O*q0wsTxy9C{lU7?0=p_;Ui%69N<bvibgrluN0c8R7|M{?&JxUAu*y
zS64B6;U~O&A2Z2|5e(hDyd%RTM-KBcpJkFSeay?{sV4c!4|#cgno0gu4==x&Zjz6D
zz{}Nm7g6U)q~AqZH{yE4E4;isE88UB@LOI!HryoNjJO|lRv=!o2<6cB-=U9jh@U{b
zAMqxWNzM!8W4!tCXKXgg6KiM3+O3VR-7|x0=ZLS}=(csrx-G{_Jw3Q?&*06`$)s$*
z+?CyC_A{4!BHJ%^a?S<8;cY^9EQp7$rG-Po{gytlliA0$@bXQV!|Z*$T!{JKzKfSj
z5r49qmw$<v<_+MGv)(kx#~ZOGyh+v|tw+!y7!gtsc!YEW6G9T;##WY;m*aXOs12Bc
z^G<66RVOTc%+Bm@CS(0uO!8Yzyo?;@|Efx=)E&_t9_AOD2Cj^8O2MpvCEDPtbg1&r
zUm5AjXnU?v^`OQ!aAjDv)TiQ&)$YEuU}`Q~k%C_GOW8$}RS32^xOoFk>sieM{kEhn
zx((X(?7XJRq+$m=2TbxNj7hIUKp*FoK9T}Lu~6&|>Z8o%4r&6HKH(&@H=`WQ^_L#j
zszK}J#X^5sv8As*$n2Cy<7*CjE}AhfqcSf~^nS0ZjyVlBvH8!JM$MOkstYQ#D0Fkq
z*nAiL&LpEx7jvSXv^DtMc2ju&nU3hojohk9w(`>Nv~T!KZqCo2JN=de?Vo#o-Vosm
zKkGAv*MvCnDF^TRahRL@Szl?}?&i`qx!DxjcUmkFOD4LjN?s3FmFNo#56qq3{<-|g
zqyyy?zdyOH<3ejACpCvB=BF$jFIr0{wr~Dy&91Te^1d<oI|tjZ40EC>#7hk!>MsZF
z=d@Alo@S+esjB3qNL7h$inY{yV8iF0?w!B$9^&Q?NcBPE(gxeW%1nQKNM*|mh<n8@
z-Y>qu`#mqbak}G*uk@wJ#?RD?H8#$j(&p(FyRNN+fb}&a<lJkL8xe~$0Sk!z2(Kfw
zA`sq5@~d1zLs@ZIu@qG2GV`8U*Um8Q1C>ekiw!DgWl3d;HDvG`^F*(4na0M<Dc@ms
z4bLqA^z&k8?Br7&7H_+{d0=I(nB})bTfL*lVNcv|hBDesA@^tPO~S>y_r4y?ESTSz
z7O)o2J1uxMxmArCz@(wT=oh@krCOVz-FSeR|9p!|Lfg(5ULhExeSUW;;0OKO%yG=3
zedJymXJuo#WAe&$v2dAMELfQ&YWOKD3&g1_jUsc-;W5w4!)i+S+(5@(mFq^ns!_Ev
zS=6k|6uFgZQR8AY<M^Dwj=d-MYWYzC&xPmqdM^BWZ^w*|8SBnzT-p5afDnCduMqw9
z-b>k;ZJrB<8inZEM$RRjlfuuH9zv;<HcNC<V|~bdj&rT{K3Y=M$t#%D*6C@8&4Y6$
z@MAvkV;FOxeNoQkVS;$A!y49TE$09ELu(&%jk0SBo^;IJyReU2f|Is>iGxlWv(sFe
zd3kwM(g##-CW+f=Z<<5a5SPbctp=PpMZm(e7k{oYRO%0>w5lXlLu0_{b!vJzN$<bv
z7QV=?(O$`})g88&hj(dv3|sU#%i5~hoQkbqnIy;R4pi6ov7!Oz^!co)qOa9~me3BX
ziM5lYw4*^g=6}-;wehE_<Vxca!(m~E#=-6`5UEzSU)wXg87FmxMk)+mb$47+*HmB5
zs-;ordSr9ML}s78$9h%`ETf;4>KDD*JWFSapP4_r#d0D!Fd)fp!M8V3AKVwL4+;m9
zw-`4V)^mUmT^02?2DsFM@GH#!eAU=W%aJjMX-)J!Zve8m6&XDT{Byn8J?(y>iRCQG
zAKudz5HHmDw37pYjtfOT?CIGS<ZSS13dIYxzT{)-JkFhbe4L{xaArHJF@C7}q1N_`
zfav3vZFLxry@r#SUX#8|B@Wa`=XM2{Bp+Pk82KT~`F{SWkGu-}TcT-ROY}}}`te5{
zsXeKi_JszV>q48_o@z`xJo43H$2Pagjia{k$F{V|^^Fc|#Bf|wh`i?dprL1zAFxqf
z-!3$*aioN^j(IMW?^@p`L>qS%*e%h;jYj)(j(LuCSPjnI9DK1|c>Be6&#twA#)ihs
z<3B+<<=Eax#})7N*6F6>Ir$@c%tuFlNb5Z6qt)%4<k^=JSr?Jp<Q*xI6uaKRE{>E0
zq9D@BcC_*Ks4XL3HE$g8N-bJ^xp6{1b3g5H+8wRG=$&hqFJyQJ9yN)c3-i3%YIE>#
zRDZjsXuiX6iZz*ns-UWx6S?ZtuzHnV<SGWLQzE*DPT3YXH2ECAz_GktetS7)UTCkv
z(`py-OtCL)Gc<Y|2c(=L$zI=gH+o&)xX*6PUxt6{?ahv#0pq5Ild%>W{%2BZc(0>5
ztl!KovugL*eSO0=FD_=6<<i#aZhI&ap?S~jo4MB!iMZ{lo7>{4^v!R^Q)!!jsidTt
zkx25EDUsnD&Xl+#11>4znaOYNof+wCo5{IfKg&H}+<cRxXxfzXzeITdJiFXGv&#|b
zJL}lv=$>|F#`|Ym5#D!vJbm9;>8xRkWtwGL#;cLDDO=v1t~-2YM&_3HBVW$Q##8nE
zj~!g?xpP@temCR&$mJPaZTMU_QWX)?D{}wnnu-YeMk^}ky0e;|XC0&c+ACRiUUerO
ziJj9{#}P*ipN!pN*)RrYHls=lTu8K+cn8Y^F}&hKdJn>G1j3sM+`pS+2MG6Y$WKEU
z3EE9GTZJ_77)=Oj1UgHEYX+Q2f%>5ATNu{lPmpBuN0Wqu2|Pyi|5%k;nQ|og@H3$K
zM(45+SMXUMALQ!NY)|>`Zc-Pl!THeUtqE{A7e51U%Un<T>$-jh-U(b0(Q456zXL^d
zpYcTNeA<<uXRaTDr_%ADf}rOT=wR3;n~wr7tc>w4D@`J|0RKt#p+(EYu4G${a_TtX
zTd_;>i(Q=4(4*p++i=_&ufbne!(g)yslhq*N@@LZu~pcEcI%47MBl2V!n>1f%L0OL
zK;q`t2l0OJfk2W?<&@1^uoA@i>3FqMI4GNUPvRuz6y8+<%iRSmcPHT+>8e}Tvj8d2
zMIG>5wu0x9dgcdgKIR0*cFqlWd`wyxQH?`u(jET%2Eu&YSZ>7}V4>go#0&d<MZhBI
z-uBPAd*5_$kH6{A6z%IHx@w6Y^X{2W>DRqe&ov`8v%P6oE8+onbKm%>gx4(5d%QJ4
zOTjdZAuX6wP~@K$nD#~o>h`||T;da=%YBicI|#fNYz}@9OfHxV%&0HWzoIKJY}QOs
z7iOZSI+u2Sf;3vem81QvGZ|xA*=dQEb~4v!tho*=J#i(sfW!WYU8!4AHY5W!ld6dS
zAoxqbBEcomaN=tTZi%-gzLsE*cw6FYiN7WIs|TGYcqEu6`1T?Y+!Ea+7$!c3=#<zf
z?6?ikP_%NYm<I@=vF1tR`O=l+ZNmbfjLy6~f{si`D+i{DU9vg7nAv6Xucpy+_ar8z
z`89w?qE9K<IZo0zue#+g(y(L0<CKYWay<A?NI2Rm2DvW5hYzK51+9XITVXvrW-N0}
zB)I_aFd=Z&&Au3gmdv%<qne%=ovZh}?m6rUdEA~mJ#wjMddG}N*d4*Rr&XLQ;75Tk
zGq)x<Gkq@Lt0M+qkS4m4d71@{{MsxuD3KUFaZm(zmM_wWj6X&viApki8`dqc#>6Mk
zTw?S-Cy?X+$qAJ!2Rlk>t~$ZHj|>pa5KfLDdgLN1;c3bS?=D4BBSKJ$4D)wfxYL^w
z<a3!bGqB!q)!lnx1o|H~WY)6zvB}Jy;53;1N04(m_L<~_Jis6=(|8g%iDV*L-`LnJ
z=0AMQ>|^~M(QV$2=o66H+~JPskC9#mIgTV=c9~?2kpU@KkUOGH*ul*wuJ+yWpk_`^
z8rDASz$r&&D>HvGUeg0u*vicN$M0z{`Pqd9-n0T*KOVa;Y*k_P*u^n5pIz3*ci&?E
z4f;-uJT9vVBx8|$Mer>a#m1_FyjSjJ_UHbA<e&jpeQ0gdoF=VxNyz9VEVop_kd{6Z
zWF0EQ2QvKfr9Iv`d)MxLGpMzif_I%UI+unCkCywKPrY$!xziMWGi(aS@=U=Mrv%7U
zb09Cx0TfdkG#*`>cyURi%4H2Prz%gp_`uqjJV5^qRB?x=;{PWaRp7CiOO-2L{L$LU
zep~0HfP7K*4OGh)Py5z%$`@Dr<V$-Ix_wXKZH@1<&V8M0ky`8fpz|5TFZiCt^F`lt
zcs}cU9?z$JFW~u%@5N5}(mLPEc)sLY-#K6fuhJ@a42HJeL*m69zWPqjCDHej&n?g|
zu*)4YYCmI_56&Qc#XB>=<6W*Q>F9Kn80qY+xAbv<RT}>$%&`qLsvTjU9`J&21>qku
zV{;pDS|iqQcks<%#(~t`HM`&1P4t;vK0WiunG0u3!TZm!%bw}%vTwS#Pc4F1n6BX~
zBO0VcC6`-20C_XkAN8fc+mR&V%B#yA&3#ELrkonM^3T2wUur<yesvzTWtq0#q3L0l
z^QH+QQ1!WVD!99(KFup<MZn31B!!!1cA~8#l(Rt?c1(fLIN;h-_CbXdQ9q;-ug)LF
z?<so^ZyLM}%unOLSEsVgbsCY|5ig^fujUslRoT?@g+qG(KCjrg&|4KziIzUkp*fIV
zg+sK{iFG2HtvSr9liFnSj|wx+aC5ObeK#z*V$*KXU`(W+*^N0;o$(6fjrUhIt!;WU
zv}Zb?FZ9?MV_X(q?iDVL0qi{yHiZcOUMPK8k%_BHs!EoGG*@`3;|hO|DcBHHB<Wxb
zD(4hyZL{Ym((LXOTk-tmt{(?Ux(3YSgtE&7yUhN<H{{3WLU5e|8gr+2z$Jz6IU_}+
zux<)?yTST8;JJISv)6KH@7_T$0+QrXs>?1vRXX5WTRM;G2Q}lg;3A(tC1I~gN0KO?
z(2ek<>2TD#)shh8YH0VLy~5R|oDH3~o}V@C*(;1>63D|-&ZnGLOSNtx#MNBWf?%(c
zFlK~7_;E5<b5QNbad$f22@$84H2z0tI-WTcdB5*}RSeX0N5IF_bcgiI&f8M=i`&qn
zGwQIO*Yv2RN~LwpE8;fQ%u_S1=&wr2846p}S3<_3(WZpcoliRIgNqJEA@ST(eAht^
zW3CU*DZcyQJpY<fq2ZO%jR%DwFY)e*$Q_tTN<@Hef>oDc=0Y$-(m-Qq4Xa(Z;XNg^
zE`(Oy67W0zQ5jB&-lUZ(n+}w6#(rU&5Hv|Ycch+K?>miB)<_z9`rZr<&v~EU2))nZ
z;*RYV5t@@VVv>Y&x}z~z)GT?|MzwiKw{hS~I%<mBl~Fh~>Wb5{FKHF}0Jo^o+;zqS
z8JnBm9MZaLKTC2qhn622z$wx!4cdtIsHF$ov{R}mt9{ZzyL7+r2fm*>gyJVk%0UTM
zH9p|xYTUuc8`Y9j;tqbQ@RJqi4VXENO9)xd52cF?>#0Hb>OTIoRoH4g_S5}BFinbS
zvXs5T$c0dvBy1Ie(<E`59%~w#tq_`~<fb9_in2C|a<?Jpe_UZo&D-K-zP`m0$+)@q
zi!oAtP~1hkP$G#X)tH004Wo`wpI_Iy3@%3sc5E9itqW2u%~6y+m*}Zu8~Td>L;10>
zmq_Tx-5fM-?%1|k=}Rtsu5?|HN|eOM*pZk=yv}WsW@E>;LP-k7`uUIbvgSY33(Z3c
zeiz!lp}qXIRjc}jRim96xRR~x!1cR?)xgRQJzoiUh~ZSygOWZ(2u_j!Noau;5jNn9
zXxCFCla%^{ST+tz30#n;&;a5GIPB@z*0KA?=L%c3M`<5>X<yuE1=3%4MDw9=KDILx
zCGEyB?!6IfWO>PGr!}N`)g2MHbpz@q4#HQOL=cwF3tKI~TH2%9je4a<5-7d6ts-KP
zXmr=ljA%t-Zi(>~T{pg|tyA|;`m5ucf$^nBIrJx%SR+zNdK4IP$S7xgWt8JE%EXK{
zUpwPcYB4_JwCma`9n#jHG2`oJ6r&l5IVJG9u{GZzZ1wCEf=1Nd8IQe6JQQ!!nNO_4
z|H(d0#i(NtQ3pO$^Xj9}A;k7+>X1<<_9^#k_bK<U>=RL}#27~eWFHSatI9R`^gLlg
zAvjtpD@rRG0IkmiZXS(3vWj}YU=kmw@4GEJ#%c`<+t>BcSxSj$0Cgw<9Gru5{0HRa
zK#zF+ijs_wSWg}Lv!Fjs?n<8qJVSM7jDAuXf+ad1nSSx&R<8>1os=hD-0l@G{#fDA
zO?+Blrw`Or>W<V$m}DGBazZ!8{@_y_fA3Qmkz@_aW`4>w-7~dGZBx5Czs<`5mNmJc
z-DbyNDf<88cp2!Zy)q<mDM-{IIaeR&x02eVAXh+~(4|7=j%h6tV?KhqUGe%!fz>`e
z=BLfIM7R57^Vz{(VzLsAgUV>)Wg1YXa_Y75CdQiVU+opJ0%>_h=n`vvIO!pEo+bLC
zSH)YRFL-71mxC=Q#zAc-`(<V2zFO~DrQTN5vkdl@s7E^xt84q_x#!Z{@BKG*dol0N
z5eS}c4-A*&OV1rF_w(*vudkEG>GO8#-K-`O@pP{4?CiSDzqXU>PnOnp$(LU6(P{Ub
zIN0?<C-%{IRr-s&K8O@FA)21)itNmsW22ch^Ddj>vJ;c)rx*D-Yx^nY%6L%xr1JeM
zwkd6EPVmw*U4?Bgop@0C`>x6DliSvx@So601?@sq>S{Y7L|1h|$KG{AY$e^zq3p@|
z0r5oGRoRsn`0)v|OGLTczz<I32A)8Wqv8pxONj315>ZQzF7HZm-Jr<eseaBSUwWkT
z#qh|$hJ#t)EVOv9=`;hX5f0wuk}ujI!&G+0rF(^!{u1j$JSfSZ4DrO@@$y^*2Hkxk
z2>$|6{3P-b79)rV#D5NzR}%WM$G}4{X{o}m=pkd)>`%ObqJP0^E6x+1ww_mV!B<l0
z+m+J2SH{$W{{wCnw=D=J%5gOe^yYT=Lpc39;8G!ochtFGsUvRFTo~FWa^r0#{#V6&
zq#9g}^}G;b)kTiEXpKofQ`*3IAWhyuunD;5p@ks6bdLWoZp$ST_E%S%bkuNE8`EeU
zHf)S>cjHd;OQ@!F_FrstuN`Y&2pWzWHco5(^W__Aq0zGoTWS0S_POA8=Q)Jn{cdQT
zP*w;wIt&~2TZFB*6iLcjU?qY-n;UC859gdD*wkEtHnn8IScFR)#*$Q<7{^F|l~>hO
z)u*>rdTB**vlU$8SP-=K{S3GfoT5v8+S-?KT}xW%f2gG_w4@(wNj864xZZJ1lXZ>1
zCwf8fL9jt*P!C8V{GoxC?9;*xJ~hDNi5suS4|LWnxHTAXTEo`J8>hKd)<~+T&R4A(
zC0cOjbf<4gqzu}+TAwMh_f#@&oG51w-Y9SHDc3370s3605)#xf;8iM7juPjxX+3nu
zlKm>2M|LT#W)kKR(-$uTUQEC>$<PUzhsOS8ReELGk<`N^Es>;DXlJe${ENJL_x+z$
zMwnY8?kQ_OjS)wl-v8Fl=N)v9vSw$R{awd~&wsmf!>QDrA4ksZG@UyMDXarh{J|NW
zG5LCihCg+V<m+A~_woHte%kZS>Yb@O&+SaHKeaPa|KrGCulq>rlf5V2S?$U9L_8mO
z(mg5md3JN8!10`8+L@<MnIdm|Iw;$pC)vIivVEr_+jl6k{e1_Xgto!^4kRt$5dE^3
zZJ+M8@7}ljrQPm-bz?Qf64E+UMyRf*M8mHM(YR$L_j?BhYNhks?nhAG5)J;^-8;0#
zOS`|W&MmEU4>Z=}@a*$gqVILMKfSJw=j-ZB**^d&%ZBx_M4R7AwpZ_bY3D@8bv0w_
z`jzpG**_pj;Tomhy0<3VZ96CJOvd^+9TOe)PbUq+N?D)UW^ky2G&82i&jUEwJfv$L
zdf=K)l`|!nk*g&b`Y73-^r8N^;n-i?8j1C11Clc1C&G9%eM{PgROk@&&>;{U4eI8g
zE6E36aEJG{+`LxUTkIFM>ZHfr8sIsuMhcD%;HLg#;y0LmOhDew0r#ZXWB5*cbgtuZ
zU?3r=!`<S6aUA#(s!MX67V_a3aLeNMfh(hd1C?^2M7cCz3?Zli2P1xb8|IVjUk(hO
z(7Y%-E_8_l0|Qq`o@0#ZNnR$NhVXg<FDs*nq#a8-E?m&(3m0_bn2YqZw`OQJrELaR
zw_<Jayw7w!9Zls9Zhkq^tZ6iGad$8+%Idn$dZHu5v?zCXjtDGVCr34ixx4iuFiqVe
z5nOKF55!rye1=i^H$zNO;u}P8{3xvw)fvN)@<h|b;Ze?28B7&T%0F3RmJ*K^c_r41
z=lGFGJ?ij8d2ystRx6t0WqbJ?q>3CJQ6^$^bsf=co96Iwe!vY4fYcpsJ|{TenNe}B
z7HifWSyM{u9d*3T53G2`;qn)rLn)U~D>S?_T?$7cg%QJ1{YTIjU=MVg2p@Zzxtius
zRjFoUVdS;xkx1=%sn2?TnLqVBQzYraaA8D1&JKQwe?Sr%3d3gpe)KiqDhxdZ{BAg^
zK|3!)l3C=h@9SttRU~EnbIuxB!&ji>21hH(G5b&W1%AyY?22pNr=F&lgY|t9YNbZX
zl`>K!l3ngs^K<-Kgxf!5zp3J9Bi3vdenE9w!cwq4*xZ*2UQqbWy*xqGddFRe{}FKo
zUrb{Hl_?AhiVhVT)Vs?>`j?XiNQVa+5t(>1uX|;nhE~qgBsiPH-I#MlWGw2gDecDE
z(7L39YaN##t7#xObq*}BhE7i&#p^awO~L8eJK(~qg(anS25L(YA&9jHtm-Gn`<$or
zdG@nOTAH&{1wLJSOuIShl{t}rzC7A?jrtJm5*!olAs8mTB4GLe;}HPo3LWx4(;%CF
zU-WvDY;G+A{qZmNYN6##+}9BwL$FV@i^^*bC$-93sfKsY8YSMnXHb4cIVxjRcxhvR
zgN8ufZYa?E>x05c$i2~K^z!?nhK5+{bl#ek^LBoK`k}g7zYzVUQtH)sDQMjW{}ZE)
z%70t`&3_vIT4f$hP4SV(>lpkmDf$1@l;H3o7Zm8g<Nm(L9Ov(;eHzP`;KdU160PiV
zhcz_Lk=<%NJ67rrGWS8;qCR*=(<5%>q(hDi4k0wh4Q-q9b_#FhZs0EbGaH!5QX5O(
zfi$nAzvn(g&{}&9-wf6JX&lMN$4bo2%wL>N`A~Q_3%nn-HMSPASr9F5qc<V=Q+LWH
z=w2YR2;EddbM%k{eZ@=s6uljCXf{Hk*(khsttVzrz`~WPj7t7U`r*k#cuR~OI5*`Z
z;-wyRj|X2YZ<nKud-Gdql~Q|BwuoD?9xI5?1QrMto=?TBnRLogc>Y0!OH9^TqDHN3
z{$iR@V+Pd5xUz>Fo0{6OUms2TunDrBR}aoAQ{f3S!1X`rSiDyY-b2@O?_STP9Nhb)
z)h6}ax0iSjeNV;~enUFwh5>X#!Nu4kn!{K5s8sNp9OS3;JcoC6!ya!L;g*^;rDesQ
z>D}@BG3z<vuIT0~1{(?4OLKSt`cM6XDYh?h_b}SIBuu+*3a42u=AYbY4eR(U<e9=2
zv;EFAYgw_{bswyrQi2J1Pw+xB1EBuXV0GYAIZ3-;9~_Ze;@5a>PnBRTR9IExQH^BW
zs5w^DrUjJ*z3RUKR5Ak=FiA)BM`^}}p7E`B$y0-6;0H$(PQ%^Zn4%31*}SQc*$3Qt
zfLD9r%!*vt5#_ik&FmIflW7v^XazV2$wPNpqi|zxi7vpq)5EGMCmT7Q3n|VeeZyfH
zx8hWlA|30|(_O{u9VXmQtOxXZ9WjnMdC6JZHL6WCo6bMs52D?45AZs|0fZp%NFT!D
zn_-g#+(PFUdeRHayhfaPqU}2L@jozD$iBsE90{DF*c-%k05PnCo65o6VRq8Rq_zt`
z=jJCBa8k+vRvWv2OM#`Ad}*FnpWFL|-u)(Q1Lf^>A7_dr;f_^PMdSQU7i225eW_|#
zW!90*!)4XXg<X)+v~uTqoZs(E<&W|kf90@5x9*y{f5oTVf;F9(H}?IuW!Ao+t$b(I
zPEJ|1JA+9s;WwJ2DZz08?NMEiuoHap7s)kul%|A}jxEGff9!5N4ae@o(|Bwtp2^1^
zE>=tP!2j^duBP<x8+G83puyUy2CP3^tm~P*lYK$5ZdPqdFbQvWl%$08N9W^dIJyu|
z<I$yfK3tp}Z()&R*p{pfnK%o{I18D;mju7G7qs58`8UeF^cctvviUXTjyHDG`}az^
z3r{|-+kjkCAe+mS@^p_q;7*Rim2n7M>4(5oY{zIlQy{};A><&y0%TTi^3n;QCHT#5
z(Xg@>J)6^#!pd8Cc6&<}yQ9U-zSok&=C)Yayq0`6zhxp@&{D{(Ek&%NrIamfxryD`
z!V8R<=Awy5jlwLps6}9RwUo2FTjsKRTC8kw%OZAf%VKt4%Mx~f%Y$r5i^v{mS<W78
zsb&wgNbKR3N7?sVR-un4(8u4Q4;qacW2?Av=>)@<f|}klWaF&z_vepe7Q?J@i{^29
zCUBI`TJ^K^E&Az<8P?G&$0kvFU*etq7d)~5e>q^BHNfUi&!1bsF~K-%9K|TBX34YI
z&s@`omZi4x=T7F-%rcD9kCbTi6jQsu{O2L<P+uP7tikc1gr4;(V<z~A&FzJS-rU@*
zm^BJvPT1Z)>RaO|D>mfKR_p|S?s)VN*<M>iI$m(C3(>pERS|mZkiq|?LulBum-v<&
ztg+JpjPU^MJ7LR1chAHNEXHlOA(wM$q4QX^1J4s2B)`SKBR$c(I7{6KkbUtla-5*U
zJ8-rdVSnRX5=vJv3G8pY=_`lXI-;|^rUK~HE<EN<n@l5DEj8NokQNpJ2PBa-NP+Nc
z+?JB%t&?myXe=}iYEx+D`qi$QpuRu{n;+rei(xJ7%e4XFV65N4v7jt-YU5>a`cG=e
zI{4tw|8H+x-bgqv#;a9d=3R4&Yl7TTOWzVl3_szly9U6ev3_WstWu;R0-gg>ffO0U
zPgo;bACg_ICCP2>GxA=}DiaQcm9W0e6ny@a7+wFu?CtZ;%s$CE%i`l)jB`o2kosX}
zoi#yk=)JtT_X}g)c$=*;-Aya#g#G1`Q04(s@HeOA=({gu_<I$dTsSyT8xEQZVD0#W
zbTQSB`<qk3_J29madLK}F)+WlIS6^;wAjQgfc38V=Nl4z(3<9y#%y@WmY4bz8t*Pv
z)n(X{{pAg+x>TEytUQ!;hCL^=SbETfn2io*9=DgJeIXliva=z38)~Prkss8QT2Mcw
zzz|rzom&YDJt+z8z+(Gr+ex&M(5++TtMeULci4n=Ozeimsy3Hs+}jgjWlB)k71yw1
zEM&Kuh5q}ivMYxl8HU^G<qp%~`+4p$gQy;>dMsH?=co7$r#dby^&0reO6p;+hM$O3
zW&d4XQ;%s=@~RnPzJGn`hEvPkr~2RQHf>IkG{?q*1}i%mNjk1O{3kcppH*YKq^~uF
zH=JS@cQhML>5p|>Xz&{F{CltQ7`4Vp$vu{+;7jSbV{dBD-M+M*dwl6Vi+z00y}nEZ
zPiORGZj9Nvs~^~B<K|lXG)q(>Tk%?U_LkurhOMXdO~IVV4r!<ioDRNdw3Ai__UU!`
zj_y7q_Dk?4<*FskapL&3AA#T4yaBXpf5BnLP@XPlgh~EU%C&n4=EAoNooH(XS*g~a
zRV?MsdL3i@tlAW+I6d0Gv>})OmmP~rH+;Uf+44oos&w1Pwr85BhLa0Nv}ul#-HZ0P
zW}|`yPHH#vys7PXz!BWsh3DQ2zaQ?n@>FSka6qc>OKJOLM`zy&K-5DG3;Wa)0a*=;
zPm=xW(?do`=aS&Ew;8rq5619Gf@cz&$MlbIY8*AtpntzVV`WG51~I}{Hj=LRMf*<!
zvk%TYIRD`8_YO9e9jtf!#Q*L=-+S#{2fEt2p6@O5GS?&gk9v3QPOp7@e>iexw`cmV
zcSj<<JB<_S-jG{f59<o$x40FP&pz5_>9+iqlYTvI#T%3C^=IeVb6=C}FE|YLiO>bD
zd1tbtr?fDfVqg8*M28jmPk%ZVdEI9Xu#g?+;0p6vmc5bp+exs#EIdEXp}O&bH%eQU
zw3T*$Fq2zBIoypinisz@<F{SPyLQ6wr^RZj@)z!({)>vX>D_Brbe~=OnAXOvpnvA>
zfBr4igx}9lO})K+_rCH2yFXAXI;LjF)e3LuRoKC;aY*6s9(d~4ca%!uTVYN6^4s&L
zH;0&{&RemYthMPja7LT+(2O=!9;|YB&eaSpEhxjGg(cJ4yF<{;ynSEE(&FyWl(z2R
z@<YNQcM#gZUG%*3?XpHyK_T$!1O+pz3JQ>p*-w)uX9BqLF@ZV0Ke>DRwKck)8&K+H
z@1%<(YLkwEyY=evT!^z^=z-P|JgX75*JR;0il5UsLcz+MOLO#3?qLCTX=Kf$iz8vj
zMdfroMxJvDZ!@RxYv#PhTgrPBdFPjJ!^XTn8~P!fccKXi8$ZH7WMfKp`*dc=#x#LT
z%9}NgffXGWQ|mHqnf~!jgi}p{C1;7hUDdF9jy|7n<J_J@>22cgIMB#d_}-}K>Usy^
zz@*&rJycT-tG~6S8yrLL^$1Q0W)n1p@So-|^=1M7PPYj=X1U6}cYvlquEpw6+eyG&
zv6X<uIr>P*2V|c}c8b@=jJw5tQ(c9P?GQW}b+bj&QjJKIZ%pnSKC^DDn7LGK`)-|H
zoW<v2oHv78dkq}$biT}^sw=jQZe`|6<5zDbO`LjJfw&shXn!2<**1~K?H*a$9klS3
z9@x_H%cr;ZuGy7d(;a?mS7v+rKDqS$@athsp=_Qo2^52meJxTI3<1|X-c;tPQ8+{T
zkC{v5p({f6x^Iq)(FEEXnv2lP`n9;WWc@mfpY?MXaT(A0N7NOIWBbR{<%-|oErWau
zzDRg)G<cWw_--gEU#n1(46GXDa9-nd2YKAmKj~O>@JYuoV38QlGS)g0kZl4s8%}!h
z5@zRIJS;IACW@V@JhXV&L-YsjU)2v&+?-PrFU6dLyv`6lhj<L4X*r;6*Y;EHXLTA;
z?l;ukEY|SCj<N%;rnTN(u(~Dw=9yCUDx%G4V&<yv+X$i_%)do}s9Odh>K;Dx@w;rB
z8g`cJ$Cb2mH63r4w9B7xu!q@n0<B0}aR$kLuLIinTk|~8yS-_31){NTrfmZHTkd_@
zyP)Zj67@=rILo;(G&XNCpNa2|6s#Q_jhgFDZ`w|6=O}IGB-%b1D?zf{ywe@@jR2&q
z*9w@F%x6Iw*5|_#4(p56i$kTwyyqX+JBX?z1M+FcYRnt6w+YbTtSx;JIulLY&TA;_
zC*U`s6EO!y_~(Si+suBs!5nxgG<LG8DZBj!zU=nwwmIREwhp>IshxAjoW3mE?Vsg^
zGi<AOiMz<=G930?;vO`Jb9z(#>I%?V^Lsak`}R9dO&m(kqPJzp^c`Rk!o7R*o}Gbs
z0C^;T(7qY{$$>h2&mkf_f*>KtX7A)DP8b75aIXpejqF2j{fL)$;#<GJ9OLEv#}SZz
z`v@<$0+uIOG`Y;ec<|pW$1;{NPcg$gvsheT=334e@+=?B;w}0542y-CEW+<IPzLcI
zkjK(2o$?HnMa*JlitwLjAj5Ja#aA<M?TYv>8I~!CW#ku9jQq(IBfkK#i2O+uBYz^r
z$e(~%K>m1&kw1=N<mV%{AU_YW_=gNjF2%o(jY<3@K1Sq^q4LNdO)>IsKx{#N4we6H
zhGi7RA7ofYQv7~~WdvdY`DTidpG`6Hha<Kie;CEc&q6HTnPJJKcwvUcL~%uiB?Ga5
ze4b+Dr&EmlG{hF<ry>@=mtjev_>K%qGR3!NSd54T<QphPzMf*_Cn2^VUq><WwTQ)}
z42y<hU4}(Xu{Oh^LM$MkqZs*+AuWQI_J&3Avi?qWEUratWUBSUzGP7q;_NR=8N=n$
z$tP}McS$#~YLP`n<p1!?<vNJ6N;(_q@l2(=X{U-~4CPPX#9Sh?WGvz=Or^50qT4Lv
z)hfIQ_!hAYVq-aD><+e;&1D^IKGIf%g{+7zVtn`AjPZ-{ejh+<3Cmct6m=fN`@>8-
zF^$7_zMR;BwmMjAKQ|u$NNE)}mhw;oGgaO#EQRA)8pczm`e$vq>gMIc)zAJVOU?LI
zYOS_T-J^O`y+vK4zCkUicd4D~+gLTiBM3zn_5_**oWII$voK9Q)|j=v%kt4Y^5gBz
zLVG8!qCK`s{VdwMOY^AusHR5!2eh|OGqk<o?4Nco<vtw$UA0avsGn0$Rq?D?^$NR1
zwVTaS{j@_=%@|v$`XF1co;0ac-Nnk(oMEnd(m1T=*pa$tkCyA!-BF`^;hw1+t1iWS
zZbHCk6XPqn2gWbw%D?jn*YksFuKX??TVAARt?Uu@fMC>}T$G}__!C}Nf3HbroS3DX
zz|lHT8&u||n{FzaXfg9&ja4e=-~C__W0UYrHD>!?`Xk&l6|`$={Cn&vkcXxOrUD~P
zjX!Th`o=))S%h?v|3CXBwk0qY?Tn2-bCJ#s#GbhEK9LuQJs}UA$oJD7N&LI!SXz0;
zu%-MDy!<fm>w^eqeZ0I1_R;&BdASX8#SO4iXKDCG8s8gF#JAHG`2P6gRFhndvY+h4
zH_7<U`hCPv)VY9flpBYe<Z1ZsdO6D45a--wk{?2wVSJaIfw&LxAJO(Mq`$;B*OQQb
z?9WW$DgG<;9cMuAN#C*j4e*beZ`XIwHzLF%T&M5A``=36L1UqD5HCycVo<(``0IKI
z8ux!x53vM&m~V;o^IxHNfIbHh6@wq*7oID@I-}2WgwI5sGQWS1?m>@sCJgyjm)3~*
z<x~XvzT}U7&~L2OzeoQ-WBO`aL)%I4;4vLUvY)gNLNK9&pplRcf;jo>br6?c=Ve0+
z*h`G(zg`#d))(xr>LR{P6OqxAikWcIzfTvDf0IdGh4X*wocQ-LxRd{8eT3$?_9G)&
zS7XOWA3<w&y*^^C88`&rx7@ph$>a7iW$&0%AJ^AGQ*;uVqJu-B2Yfx&RXKNv-v$n$
z{Z{mWkj^ydL4mWlZfXSZPl6Y{rt8Q<scX6pOI+76=4*5vqvE;_&C!u<BT?&mT}S3O
z=sHs4x{l<yt|M8|b>JBss_US6Y}&vS*|8D)XX`_;c|E_K$*su$|9X%AZhDV`7<57J
zF>z4u;psPjquztG9>$*0sKrV2jOjgc2K64<0Uhpndizrq%|{kW{K@^zdXIGcpU``3
z1?&)QAbdsgHsL;!y-5E-bTx5C2_GgSZ(F}=h)&@@st1Ae9Q>*tgwFL)sh`;iehIfH
z&gYLZHL@G$kIv_}>qGQ@`ldF9kLh_$A41=0l1`WAkuh8|WDYUCh&8Sk5r*hR%Agmq
z4C+O`qv%C$D#%5<oK&jlMW)%tv|8|<(2GohUgQS6d$vu0e+J=Tj(_ymXhpJzXhooR
zAUrcfE5Z+IMQF8{ou1dP&v4A6;sE@lK%TsH2a_uhh<4F_(OzzD<>l2}Y@fbPUou<K
zmrRT6OK#!ET&FL&;oqe%0gMgmOGZFn0t>~?VLYrxFk&7StYRncPv-H360{}hpm-xd
z@nYH%!rjpI#I+@sAv_ZCC$quRCFar#ntbc;xgq=h-%W2~`A_Igm^939<cC3PVo<au
zSqkh<kTR9^G2t20o1|Q)H_<|G@?sOd?I5U$Yfgrq6@rVQu>O!CNjW<S+V!8&qgeVA
zdXx>P)D=YSzg~|*eEnJk(xbe9nDi*bxBuo}V{{pQS)fZXLXTpE9>oZIXu<*bUUi5j
zW$o+W=O6<-zK54@{sk{@15f`D_@TG)4Xzn*|BW&Tq#L{U+k7RB`c_{_&|-CEwGC5z
zCE@<FlY`DM6TXsSK|F+;&^~wtu<w5p-_b(mcpU4!1M<r4`yqoMUIF|<{*q|E5d0M0
z?Fi1}M93cm*MwgQ&nET=w~TgRs&Dj*R0^KP+-j14PUrpqf?p)UA4C&~_a}Ut5iluV
zSmS(mQ9AK`H6IX8;&dyg9ei#43u}D&fICh4@@VLtrW^C8{cJ_Mv?ht~rU_rsx6{-Y
zEVRDW2UDUheQyok?Em{<`WyRTBKe8rs9yMB+Jl(*bCTr_Aovm55C|Tw_rau%<DuAh
zy0kZEFUHRJ*ZX0L;r_4l!$kbX`{7vKzlAR*!YD(1F%eu7o-CRg<82bYn4XXK`QO<e
z6LB&s>6$;LCxBC1F(29^8owf64*F!W_R%V9wBPKL>G&VD%3c~!E-D$m)i2XyCQk8t
zmiTTr<{N3U;v2~f-u0SqBwdeiX*4Y9vTBKfU3JIkSi(1wVG_K7d3AY~&UC-!1aY9?
zY`)by60;|GPr?%~1Glb6xD;aF;43NNDd_<Gfea^qNkMK!d)!x2+n}$c*01%Iw0DTF
zq^3b%NqesIm9%@%S5hO|9`#WpZYas8$+!DTdKF)Aldq(0LwqG|iTg@=Rq>Uy?mAyd
zuY9AgB$Ru59sDCb)AsGYlAdlCBBMT9JLoIvsju;s^f+#JulY)P3@u*sl~nyV@Rj6%
zuOtU%UTA*=PpjfF>8rky7NgggucU`j=KpnHNtXT*U-6Zci_?>I<XH##OClNKs+)Wz
zk#wh$#t!;QBDsv{u^EA6e9}|Vxql7s%?M2hB;yl)OW<nqnMC-(fd5EV7)obJwj<u-
zbp(><5@#%d2Z#Dkg6AZRM$v33ei*2&gkDT&ybX51MRiGHUY*uP<??``I36}qidRi4
zm(Y8;LEEqQwd7QMEv-;|Ev<kQD<6CWdTZud4qr=;T<2@4>MOpM9tKZ#y|1MQ(KoX%
zi^(u6Gp_TTWVGEk#B<VO@GzVkV|3pWFP(l}X}xXXkkVWYO4eNSd^9i63(rSZ`@-|;
z30$pk@J{>fL%biA0k6F5D+NwS_vYBiAKRDkd$i$Sxy4%@+^R3(d&?4y0$XhI_RXa9
zId4HYjMVfug0Dpp!}6+clI@xYq&#>&A`eJo3T{MvBhJdE#;F0LoqQk_+Q|#j^YEe;
z^Me!)_BqZ4jRg~c`H~8BQ?*m(JJbchzg~4NX{ewrQ1IZWulPY4h4s*3C9e5Fx@L_)
zJOIH|0>%j5h<?t7K9YFYguZ}eYJ#W!DKVHL_#}8GKVAfX2|7jm1HptMha9F+F?+7R
z<FEL}8KwBf85#GDGeW7woTuQ)WLSIl0eneJ`o`Ab{yh!Dk(Rd(_h0jklZEp|zHxLt
z?BX!RHxBWuSKTqL6?eb5b=Fqdewviv)dk|UNoPj9_9uvG{!<XYd*iipVnF%XU}EWx
X=Skf0O#K_&@eHJL>@Lk;e)zuu-ts=k

literal 0
HcmV?d00001

-- 
2.18.0
