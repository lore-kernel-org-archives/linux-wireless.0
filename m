Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60336 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0J3NHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 09:07:01 -0400
Received: by eye27 with SMTP id 27so2619311eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 06:06:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] rt2x00: Update rt2860/rt2870 firmware
Date: Sat, 30 Oct 2010 15:06:54 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010301506.56031.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update rt2860 and rt2870 to the latest version, as extracted
from the latest legacy drivers from the Ralink website.

This firmware supports the rt3x00 chipsets from Ralink as well,
so rt3070.bin rt3071.bin and rt3090.bin are outdated after this.
rt2x00 never used these firmware files, so I guess they
were added because of the staging drivers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 rt2860.bin |  Bin 8192 -> 8192 bytes
 rt2870.bin |  Bin 4096 -> 8192 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/rt2860.bin b/rt2860.bin
index 778a771716aff389c79fec3b245ed00beba23a67..e13e2763e61888d3aae3b38c1fca1151540008ba 100644
GIT binary patch
literal 8192
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

literal 8192
zcmeHMZEO_B8NQp{+dJFX-rGByJ20@>oC7!k7Gq;aO%umoM~v|YK0{Ddvs6w?2vnQo
zHmcehZ)~iPC@CxBe*9}?S85vxok}bv{Zmfo6h&&4p4N(#AE`Qo8=5x2O%*mFfPH;u
z&xj<o@~i!KC-2NV@5jtL&wD$2`xtQ}2>o7B3WWmlPCyI2XJfJV?n>h{O;4sL(pe)L
z$)waSP7=#3z80&OxnzJ^d>G6B;E?CfNt0T-gq<B0&*Ru%H8rfY$3E2JVQn~epRSSN
z*s|siYk?Tj17luu%NR0amM&svU}{I3?KK}I!=s$WlVP0)Q`yvx$8BV8JvW@%A)(hy
z*>#OudJsFEl2~sFuA(cq<l1fC(nC3Fr?T1XM0PSuv$)aH8?bt5D3h}EE!Yz4Aib^7
zZ-Bl5`i&HH*ik{k@}*DM031QN0s5`bZ-l;qsy&sK9>bkpYN3ac1)A~MDdiq0AEog>
z)A(O${BaszP2+26d_9fxX}p4z1R3E%7B6S<QWoFI;@eq#D~mtR;+tQ{^xkwvR$Pf(
zqdr+q5*lBVFj3}7^-wt(fWZI^4!t+zS3&N!dAAzXnb*FwZwW2BdQSBUav7AXPDO%T
z4#Fmt6XXh4;01XN2#OpklY;_zu<Id>TQt23)4!9@Rr5lo!|uvCvU8s^<a9d^IuB*q
zok3^6Gi>n@R%m`5)IJl<L^A7?ck=ICxfQt5qpblcaHTe)dutbzYq7%8)usZdJ`G&F
zc5zXGs!ZI>oz<nJ_pDwyH+S|X2+qXm$=vfvboQv0pPQRA|DM00ZOSc6+%Y^~kf6)c
zWZiaWBG;rllh>$H^+*2l7tlAdffcxfFF}w=NghE$VTr5DIf@gvcn@R^g>!+aA+pZN
zBButqj+eYjx*^Fy1t!vyMnn0RMiIq$8ReW;omZUG&Rfn$h83}2HGb<;-p#*zT?>pC
zB+lGuIxYel$2J}Qbg?)RYOll!Zzv1O55{w!zQ1I=co=!J$?)B+D0z!JdDh}Q&zDE?
z8n?;3#csdSr-VQWff52G1WE{$5GWx~LZE~|34sy<|91qCxCM#dK;k1vdJ9Q^K%qxb
z=&=QOB|)_Z(AsBExB-RQRG%PMa+2qLRS@JVPKt~u%H7w0=}q_D{{VaUm(cfueQL0N
zr})w?@%1Kgp*eVPAo!!f;Hmw=Q$xX1iQu1xgCFRU|5>T&Icda{UYzuJq&JP2&#3>v
z(tnwhs2#D77|oSAc&Vr4zzv;4(wj(nJrl9KVVqc^Uo`-Afb<r|2xtMzTbV4QW<6;N
zYvp0BI;@3boL<Y+0cuvUzJdaM0R4IjL<AZ`sRKYUFlr%Im|hQCf_KHQt{@{$<u=@P
zUDajk05BHH-DyA&abkQFX)JlB9Svv!JSw|mqmMKC<-5*tz>&xGIQDJlAPXxb<Mjt`
zUd&%)VTI(L;sB@)H_ufUC-HfIfVn69&I2o+Ht!~}%+yQQZeDQ?e%%ag;T2bB;wO{%
zYrM@Da!#MqZ#+;aQUFF%;oQMhlGDCr_OfXK)*jopx=X9MmAN=gi!+`!KU4)LZqwCW
zfrzQUN5m)!83HUr-z5EAeOiF@*YxYCrf)Wy+hyq%osHyn%~3VF&(eR9yr0gIdP-t*
zbi8@2QR3PM$}Ew`iO;Alkmki1v2CNeZhdCmY-BnrM<t6d!->BE1;pb{pgE4%9BH1f
z2-}>JbDEit8uc@uPK7FplG&T-C7tlC4}HfIa`@1{1EIf&p%>)P&$Q5Qe&z9mKAYOp
zG1b#P)jLAsqXNtMGjl!J^LC=z=^#C<YbU*|bM5+fhdQdwBU4XwOzmx-+E>)=hkz%F
z0eg!9`|brala54nr|5K;55m`g7luY|8|`Hv`h<=Vz9<T!>!gB{VDB}N-J5e-N&DLg
zT408L=dh)B0!kxr^}w|Uu3os9t{tupYHJFKYho;|b5iYYDg0O_mEnO>0e%fQz(keC
z+jVAu^mX+^x$A6KJDZ!{klaYgVc6U@(yE8lIv+VKlL~c16qIV=f*J(1&uCp^qMBCw
zxP8K`CWqB4LWYUFeLQmlFyr+5)V)Pj1l&2bHwcisasIn;mflUaQTb^<8IdtMe^h>k
zNte+1WAX_meTdE<xAZvp7~9+Ar}^2VW{rAOAl<W<%{8POaJWE=4A}G2&&kj5v&X=G
zY&E+vos>`Tv&X@Hd^P*C)4C<@AloUcw%%=_tvInvNe2{+okh#qrWglbg4$*aZNX~1
z()2Syj`QH90MDq9ZuK%h4ky#NhglNK{h*7F`rROBvpeA(N*)Mn@V7mz?S}L1FzF73
zLWxZV<xZt2Om-6DPkQp-j}=Tb8=ro7HvYzRtN9q48@9Q5!HhAnGNCWbXamAY53I*S
z>w!@BQ1s+a^g$t8S=_^>-wmIB*v;oo*Ji5ZAPuU<`Baz5ldc;Du;i(7X23qAoJrVE
z!kwaKQe-f!^@O!!F?I^B?X?dX!(KUBXQ2Rt1Zda$ExrlQqq;e0*0M$#m!;ZX_vZYB
z8iQVlA_KZ$s4U)+JUGGWHLi~g_aK|+Hn^dp8!~?=N2{4uzI@!`Tkxo&k6IF+ET`)F
zpcMivDV<wsZc#P^@5P-WB~3R#(gZe}3FpG+u1$j5pJz5L%+4ie7lA_x!65|(cnBG)
z*BAzRaL_D+6n&7QGe}e|lJSBrb4ZR>ol{e7Qlx>X^Bl4{_g+!GRjxJTg=dLt+z$kK
zSli)36xqyHyT7<jEnBA(QMR^xnM0Ay;{#Idps^nr!yNMiepr7RtYjB;Q@TwVFyH`r
zab`bQ_qzM5g55yIdCCyztOf*%jgN&TId`vsStpFyiMNL47}KkwiVPa_rXGhK0PD=s
z2Xb~>ZuuUI2^?+o-sr!n+V|jel%pJin&>9xfi`ZzDuHo@#c#pR&N-mpoyMF4Pwp3)
zS)YKGG#b?Wb<9&Bw8>m1>Qjxn@6K4n<bUiL^W?V`u0OIYMa6-7OP^#h@Phy_0-_)O
zAuyfnf=SN0D|vyvpMlAq+Np`T`o==8$viXRz+<h^{JF)8N#OJOEo3JgZ7N7X7^BFs
zj9{;WXXYu=LKkL)f#@0bAe=AweJwd>w|NLMWf}_D?l!1!DjBG!jGGo=-X+)f&Iw($
z^wW^R99~-dX-gY2(K*=O%h#x{#kYGU?3H2|P}*0i$-%7E7d+mod}16*+OjayHvkZc
fq-DO(J&+Vn=~F_Wgg^;_5&|Uz{>KPZ%zXSGs=Fu0

diff --git a/rt2870.bin b/rt2870.bin
index d94fc7ee072c17a532eac1d3287eab130d09fd91..c8507a4b8aae3edd1a6607af0280f4b1f590cae7 100644
GIT binary patch
literal 8192
zcmeHLZ)_CD6~CR`JD+_v-n-p{v%%=toG~_qZW7wsmeqp)WBeD^e*nkcI;bMVs0+CZ
zpTJv!zqD1^I8mg2s9M>rDj}hh=qVrCDpX4vMM^7G8}&>2M`LqCKSac%!b(XKe0{Tb
z)HcDSs?sJ^&XQ-|%)IyJ_ukCDH}7(}91?dS@d+fJN7Ap5^lK#j2}w92{aHb=cTjaT
zinbv6oazt6EBHutPO-S}WA$d7jHy^8y($)F_M2$NXNg~4rm&U_(yYb(oRL_?+bqt+
z85CW>8BVmgOE~kLQpUv5NX46qCCE7bHy%m9w2TOLM=U|Wk+L6&i;s)H{c5;uFnnMr
z+;ceGb0plOg}*l(erF`oXhfbq6M6Bh)bgD4lqs2(&&Q<0*lo#LhD1SS(xhbMuEEqI
z=@)Utt9;FQlpcwMUd*q0jB8kCM-Dhhu?!JwGr8+!6--?w7)bSVsew!Pr%{AWp9ty#
z&ctDjPYuMgZXJk)aUwU@1;z-t7AKx^N0~@2*;PCG{u|40u=QNBJ3q+Ydjt&9b)rPC
zfi|dbfwoi+LtCbYpbhDM(v>L>GG$t&+YE!!AZgC<eAexRK^YrxY*5(25j<dba}3KQ
zv|&74H((ht%1Fzoq6J1ZDmb#a6IQTWXQ6rwyj6H*c>-vvb_wY^Qy_Jq2kly3>sF?B
zh3UF?`~6$)=%egf!|GoA!3+2kxJ4guWZg0Ms3r0^v&)|v<IEP1R)I#Q>d{XEEtm<9
z{z|zeBAhu3Q$aJFpDOdFUgA?@B3#wQD$5_l?Hs*l`Tbb?khTl-wzdM3H0$=e1F7a*
zswH=I)H@!yA5Tzwvpen{bB|kwN*4;(YTd;#&oRT`=wEv1sp^yFNP(fp@fS3&zkhm*
z`DB4*GjpXozK#ucCdcRkISvp#AQC$Oy~HwVnI(!sju_RdUV5!h?GyZ+wm=3t`t=|g
zhz=Mi+OH^f>)VPdtL#9B>)>2tc;J)I*p}7Jx}CN}0geGq9czAfl#HL?j2&bYW>p+u
z{xby(E+nJs(&PT)<hZfhf6T0dA>K;Hfy-FK<gJHby@V+RDJQMihwNU`4&S=`LtnH`
zh&~pK@}hh-F8^Ma|N0Z3FIqp_-8S3PI@>z|*FT{1C|YlBCEc&X?QbJJtZOB`tn=25
zZysr@G{<KTw#^=Do$brd^?|^_yuhKnK;No>O4_u_cF}D!cftmO_kH;TZ4*MOwG=+6
zfatBOupV#@naJtQy0xVBb&clO!hk#J=!z31T?tnYCEn6Y68nvS9aSQ+pGBe*cGOPW
z0y8tsLY%fq7o3<GB>f!&a9?7MH#?u5t4eOCWD<<nLuw64jrqxBoP^Y>DwtGr*VQmg
z`%|^$CW_WN)6QwLl1!?%0yZNBXWBju(0OBrdMG~?19o2R4TEbvxsv;GEL_N>J$^Gp
znol6G6(Wbgw6M@2vCxrM08zy7^v0hlAro<ouAPiO%cw<k?Nt0Uqn6OM>D1o+@n?kj
zljctKWPo(eFPSxrTbSWkA|Ra_U3rZP7hrV3_ujX`;^*eh#-A1DPl3RxRe{Bg1yXa#
z_-SE&+B=*wLs6%h*iCbbht(tZk<NIQR|)^N$=v|O9!DO@(#DF<%o!F07)$&TWntpR
z%j$l4{><FDd1LN*vR9I{Z@7EybI$XS&B$KLuAb4wJ_5Ci&zb0M?y?snwG~R*;4aB}
zd13|rc|)=r%}S@y43SQC$%8c4sCN0&btv{@7Cu?W!h0pOK^<-wgm)grDjuTyBTAZO
zU6J)#S>KcRNI#hPK$jDnj6u@L@TDk!iO@vOY<8Mp)2|mcthr%UGqOT!1fvE67kqFU
z0<^yO*qv*%n@njH8<P}lm|PR#^AO8Da3Kcnrw;*l&jS~i^&PUl8^Cn{xCnsjSqsjr
zcbd%RHM^O69s#WhZuP&M)?}h}pa8-$Rp6S2M3$VicPXjU-tFjs#GAdJp*kQ#brdp`
za(U1>s$ABbF(vCx*=aH)>)o>ctpoy#s#ct%sbS7S^N{H20z5q)vxI%{JlO`%6SRdj
zk(qcT_6HWHv^z94#DNSMGy<t9CT&H0SmTWX57TlTcu<}P7(TGj0#<JU<yykm@Ck+O
z=~~=(lNaDQ^a`~iLb8lPHo6(jT7Dm0fVa{DJcW`xo#7%C4VJVEQgb!6q<ZMLLcbe&
z1$v0W6aYiR=Ct2=N+i;9*OD4^$Y*y<co#rWmJ3rsto^;Cg#~HtACS8^tlgujDK0gP
zvhI*s3MTo%BzK5R=~0`5Is53<sr3Fx^;={r!y||HVwcKA;3@YCWy>}PPbiP!Fx+|p
zEUSJqbr>}AOnv(%K%~X=?EoJGTzF+{g}xrl^8>8_y_-U221D8_!H|3dOW+aSGiEb5
zB)Rl)mw=bse*@ntB#v^(gNNN=6_wiPJeNKIXjLBByoV70FW=SoWLJ{%UiV^lpW(iM
zGr6kO(K1bLyT5XqDw|#t{-`MMNNT|9Vjsk51AH%T1F+zGu?G4E=(oep+ps$Y6pk<6
zVFO@<$r|YEq2CUD166w<DJNJ`w*3G^QGCU}q6dl|D0<-Y?Sa^_4|AVg{r{H@>i<{&
zYxVz?_4U{Np9ucf_5TJiya(c^Q~zK2ckBNvpJx5PfnBV`E&Nolw*KFU`!lcqul#5A
z{{!|stp0zHWrO;^!1hI`|6eWE|Hb;h^J7046zl(D{lEIN^B1K4?=IH=57z(P?6;a?
X{r~x{B8upW9w>U?|Iq`ni%<U(H|e-#

delta 1042
zcmXX^O>7%Q6yBX3Z~RloyR)uMls4HKw`qzRTp%<FkRRLiwuwpevq{B)bSWmJs6ktr
z6<lJ^0Skl@X_BdW0)d=Eg%FBFEFn&mgcHYb;KE^{S$<AgiTV%-F|$h#@0)Mld*6HW
zW(E&qwZGYH0_iM}o&nN(0KEy&0ze-Cw1UuwDUi4VlAS<#7ogQlKvbgwN`99j{ED4<
z*uFNXT}1Q5M0R7AKxm`zC(_p!Bzr=JlX7%Qj!w%_T^^s2%clJKZTY8n(8)V!5OW-w
zU;Cw_2h9U?y*fLx3sS_CY`szfh5)>RvRw)qLA#{-duv><uBvpHFZB8nM=P}$5r#n{
z;Ar(w&=csf#(=+Z2I_*a*C_1$yE%&@Yr8N-`@oriucWVoZpmjv0(RZ(*s$vv`Ugn0
zeR<8#CNRE)-92I|t~2|{7{gimqR=6n!>8!0f=a&<dU{jaW7|b1&t^rNoRWpgU{Gn3
z(2j~88tBny9H-=~mvhz8Y_&MY&M2}Glsx?co;W@~or~eus#kK=v268aKWI+TpW%r_
zuanbbd8v`ZPq7)GI6e1|l?~BQAajA3d3VE^V>Zg{GP5Ex&zEJEb9arDqZv~AfhnLw
zH&RyUwZMImm<8v&OA}%TBBsWu)ibQ#gtY~HCbK|)5Kq%L!~`7`+mBi6OX?!5-C}`T
z^fn9Ziy{7LdLVXJiUf4q`jPA8zSm=MBc47oo=gjDp2QOboV7Dr47Yeh)kK!Xym{V3
zr;zy-R(K35oEO!PuKHf@(PI9ig&2nXGJB0KzsI5L48)D|aib@0JfA)^uBQ)-&Puw~
zyy+AaMIW+U;r&fl)nJ*GEpz*Cr<?dvO~WHzFX2brwS&_hjp}_ncQX@WnPdGSLyl>d
znP!>WUmQ<2*ZXSP)_Ol~d#vMk*84qAA8zrN^?v`vhnKosVzz$l46rNK7#(4ZeiJ-b
zDa4H%Y44XNh22-I8J>U|`?v0ft^S@O@Hx8<+S!)^2@m9oiV{Oag0}vbYfbX_jx%8f
ztQ!J;iy+R{1@m!+SL0ij0q`Wt0JuN^EBM<B1YWdDDf3yvf3#F~34hN$Nf2BLyF_8v
z>awo?!{07}ysaP5KSQTMa+ONq&SY}cnTi`BXcnz0-kK4-jC`w07sE;VY4~^~vJIB`
X%@LGb#aj=;F9o*D$e<t`yF2tBF3Nh?

-- 
1.7.2.3

