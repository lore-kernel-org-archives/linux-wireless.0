Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:56345 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1GHGWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 02:22:19 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 23:21:40 -0700
From: Benny Chuang <bchuang@qca.qualcomm.com>
To: <auke-jan.h.kok@intel.com>, <David.Woodhouse@intel.com>,
	<dwmw2@infradead.org>, <linux-wireless@vger.kernel.org>
CC: <samuel.ortiz@intel.com>, <vipimeht@qca.qualcomm.com>,
	<vwei@qca.qualcomm.com>, <skchen@qca.qualcomm.com>,
	<surajs@qca.qualcomm.com>, <maggieh@qca.qualcomm.com>,
	<samuelc@qca.qualcomm.com>, <suraj.chilled@gmail.com>,
	<martin.xu@intel.com>, Benny Chuang <bchuang@qca.qualcomm.com>
Subject: [PATCH 2/2] Qualcomm Atheros adds Bluetooth config files for WiFi-BT combo chip
Date: Fri, 8 Jul 2011 14:22:16 +0800
Message-ID: <1310106136-6054-1-git-send-email-bchuang@qca.qualcomm.com> (sfid-20110708_082233_390967_E9EEEC07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Benny Chuang <bchuang@qca.qualcomm.com>
---
 WHENCE                                |   13 +++++++++++++
 ar3k/30101coex/PS_ASIC.pst            |  Bin 0 -> 2166 bytes
 ar3k/30101coex/PS_ASIC_aclHighPri.pst |  Bin 0 -> 2166 bytes
 ar3k/30101coex/PS_ASIC_aclLowPri.pst  |  Bin 0 -> 2166 bytes
 ar3k/30101coex/RamPatch.txt           |  Bin 0 -> 17916 bytes
 ar3k/30101coex/ar3kbdaddr.pst         |  Bin 0 -> 13 bytes
 6 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100755 ar3k/30101coex/PS_ASIC.pst
 create mode 100755 ar3k/30101coex/PS_ASIC_aclHighPri.pst
 create mode 100755 ar3k/30101coex/PS_ASIC_aclLowPri.pst
 create mode 100755 ar3k/30101coex/RamPatch.txt
 create mode 100755 ar3k/30101coex/ar3kbdaddr.pst

diff --git a/WHENCE b/WHENCE
index ec7f5dd..e5f2071 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1731,3 +1731,16 @@ File: AR6003.1/hw2.1.1/endpointping.bin
 File: AR6003.1/hw2.1.1/otp.bin
 
 Licence: Redistributable. See LICENCE.atheros_firmware for details
+
+--------------------------------------------------------------------------
+
+Driver: ath6kl - Atheros support for A3001 WiFi-Bluetooth combo module
+
+File: ar3k/30101coex
+File: ar3k/30101coex/ar3kbdaddr.pst
+File: ar3k/30101coex/PS_ASIC_aclHighPri.pst
+File: ar3k/30101coex/PS_ASIC_aclLowPri.pst
+File: ar3k/30101coex/PS_ASIC.pst
+File: ar3k/30101coex/RamPatch.txt
+
+Licence: Redistributable. See LICENCE.atheros_firmware for details
diff --git a/ar3k/30101coex/PS_ASIC.pst b/ar3k/30101coex/PS_ASIC.pst
new file mode 100755
index 0000000000000000000000000000000000000000..11b635d796490eba2ca52a59a757c1aca3070824
GIT binary patch
literal 2166
zcmZ`)OHbQC5WeSEjKr}m*<C-w&32p?sYnRu3FTno4Oj%H3QnQ@_5Egc*Ku1lS~=s{
zd3^KqY(A%IZ{P9gx839M&<x$apPkL_zg*m|mC{+DjA5!+x0-N_B86i}X?ZS4ZJ1+X
zQd?4ZIsr{H;vc_4GBBAQk7G^+l-Ftv;mm;XrfIu94b8*O(p~YHMugf_0b%SBmYQ%h
zu)${TT}Pl(p&cJk!4cXcbeJoO1CrS3Dgu$jv?#p1GwZd)f|JY_RM(U#s#A(YcbUuU
ziV}!TeZeNYxFeF$m>e(#i5>+)HcCS{oQ>O`uY-M|jnqu?@zxDbq~3LP%8b%c$V{2K
z+EtoxbS7Y2HZ&nKNg`lssw#>iNfhwpz6vQ~Pe}t+LaP-Y5P5)yS7;#?eo7QBGe|FF
z{H>8&iEFu{8cB|5C4n1JsY8rjJ`#CB$VT9+CX<W7m@Dgz2ZX?;-EBp>Af(R0(=|uI
zGz0{svp-gR#LQZTi-JfIMTPbV)#uP)A#^eqE~L&?unLllQ;v_K;wZc?Cxc*-UPYMz
zbIr*#_>u=tM?uR;LM3RWn$nSuD3!uND=jD;eTkOGu#ik5ghi-DDICO$Hprx-WI_{x
z!Ho)2hyoK0<5Ksy^l>GK!q5`8*$H8+z2yp3mj0~Y2Ycu#GSBn@8{z8d7gg8a(6|rX
zK-mSo?yUVzZTHIKJhwgneWccIo8xYvVNZ?)1$+K@&I~W>G(Xa2XPW~#Ymkz?<R_i;
zKQ0GlbQl2@yAjBx5ap8e3YulxwCw@JnKQ#HPw5GrI=Wb6xRDjanqj?h1#nRuc`0r8
z2fFMByQ52U%Wp5ua6+JDDT!T=z|{}+j-p^=B0kP+0Nl1@6Eb$<@+7X4zvJ_3PtxEK
zPQ+yoOu@K*ZFnO<Y(BsKI<8YB$bSS>?s5mrm=o6%iJ~$_i7_xxyY0K}mTv53|HB@B
zo*YKYU_*Nw1(0EZFg`h9b{sQX@~GBeBE>uretKj$nBf+cLG^GC$K}nH|8$+4np2b#
zOtFS0HbyL?&5p1@a#?8L=aj-7+q(ODeTBdKY;lpsYx+dYptt7P9>3Gjz1aP6psuHv
z*Hg1<?t^=6vWrDJs&p;BQvX$u)(MThd20Gc2tV1s9ii(JYWkM`um-L{i?UPx7`wgT
wpJPrzxICd)%8#q08)`D^KEa|ep(iOE+c4Dazn;Vgb_N_wP5t9%+>${58;Ok09{>OV

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/PS_ASIC_aclHighPri.pst b/ar3k/30101coex/PS_ASIC_aclHighPri.pst
new file mode 100755
index 0000000000000000000000000000000000000000..67fb856bf3cb37fc678e0ed783bd25b9d0e4ce03
GIT binary patch
literal 2166
zcmaJ?OK;mo5WeeI43J~fXm|OPZxltf0b;<g)03eCBd%;BG8M>F<Mh|}o0(mT4Uh^8
zYB)QOZ=PH%msFqp8y>@<f4ZF8u|ExqcZ<hAZyt8W*dkKSF;(q4OE}Ju!Et1)JXd7)
z%yB810~tJ3z|w;F$FGpoCy4n`$w@$7RjYG^vjE2Xw(CzcwqK5(K39LxgwVP=B1{9q
zwIv)2Y%o;@rwQm>XypScI6?=6in*o~e1V#(t|1UvN~<c!tJ$C>7F4oaQPWUisL3f2
z-AyU4Tgo6d_XV5qqDLeXO^$K|iJb&Y$l=-%4rk-x$Lr`{XfHLBe0=Z6XEJZLzGlYQ
zBxYuvYwc=FIJOWlnhi_HOqL0lhU%J<L=pu&W$>FL_M9wGWwhP$0Z~SHc!d^X;ip8Q
znL&CX6K<W{N?e;QHAr$oTM68WN)uxY@`=a`LN)?l4Y^Vbrd-)zJR$@(tG6}TijX>m
zXB&=!X$S~NwLevS!pvHZi-JfIMUD1|)#uP)A$BqsE~ZW^SVu|5DJMixa}>ds${<*z
z*H9tAv^kjuU-A&>Bx<Q7RH9aHDWB+saw#0N@{01wmuLkHE6F56SjAebg@bs}28DE#
zOlT%BxKUvWQDCBBT<V^#LtGi6aJ0c~aYdNgV7W$>r9Ydu(VquO+*kSy8{zi(AFA*E
zLgRkvM=EaU_2~UK>iSn6=cOO`?>%+?&|Z!sjVDqT6#R#$56lR%s`;MwN8g@FtwBom
zQkZnk|Fj&8vvCAWsv}TJA=VqRTWGGkw(HIy-l-X0dB)D@T<L0u;YL;vYk~E~6~IMx
z;iYsqo$2E+`XhaG5B&Dhj#mUmmXg>F2(*5vcalUKGx2F=BjBzhpON!3msfF{{TyFd
zdy<BLa3(H$U=Bw6wdIWfvE}ma)3i>JpzskerRENpF(=v+nW1%x5@TSX_AvB^1Ks=m
z>2H7jadnt%q755tR6vFW!uaIG*->V(;ZbeCM2dML!t}^+FhduWL-lYE$Lsss@aeib
zb=N2*m}&=2Y>ZS!n;l_+l(NvkFDZvRw)Oeb-7Wqei`7k@?&x=727Pb8`pY*O`xk$@
zjMNYG@_KDn%YE=@U2(I@CzZa#SL&Av(mJuR_s{L{1mS1@vm<nUM(xnif2@J)(4y>=
xKgPNj!gI<g2+b3UWx}{hx}hes9uh1HGkTW7sSRV@e(6bkU}wO=+|>X2`4^GE&Lsc<

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/PS_ASIC_aclLowPri.pst b/ar3k/30101coex/PS_ASIC_aclLowPri.pst
new file mode 100755
index 0000000000000000000000000000000000000000..7e3c301578e74f89f6f5124688d19e9ff5ef2655
GIT binary patch
literal 2166
zcmaJ?OHbQC5WeSEjKr}m*<C-w&32p?sYnRu3FTno4Oj%H3QnQ@_5Egc*KsSg(aIUm
z&f}Y>XY)B#d;5+@zwI86hi2&Z{p@UZ|K;L#t(49JWeiiry48eZ6e%1-O3QOWYQr28
zliHHP(+Oyr5&!rVl7Y$ecpP&opuARV2xkV2H%;5^X=omHmhOtrG$Pcd3J7D5u+)U3
zfekiu?>YjV3hnrS3Xaeop~GBJ9FW9LR}qLLrbXf9omsCX7Mx_hpt`0^QJqpGy31T%
zSCl|(>I*jE#T}81#^iu0Nc1QWvQZks;cVRgd>!lyZKP(BkGF1kBK5ATQ)ZNoLT1X;
z)vnTnqcZ{HvY`o?NfH55Q&mwENuq!!_f<#{drBIp5?ZbJfXD+pyh01H@Kd62nL&CX
z<8O`JN?gko)ktzgD+%0)N*!YK@{!03LN)?lHJMxt##~u%JRk%%?QSd51tE0~o~}6x
zrXe68o&B-mBWBhzTogo#C@Qo^s6K}V3!#&_a3OWBf>n@YoN{~=6-VKHIT-|t^eV~(
zm}^d^!IwOEItp4&5-LF})s&8OM5z=GT4_P)=u5ObhJ|DjAuK{IO5q@0v_U2vB@>zm
z3~p4ILKK*27?--orH?B?6o!_#%}xko?JZZRvh-*DKG;J~k$I*M*a%lozo@$YhQ@v9
z2Ffnzb!Y8&YP(k+=eh0q?<2K#+Z=ZT4SRAdDA@DIb7pv1r}>dKJKG${S%Z}9B|qt$
z|8Y4eqr(WO*o{Cgg(#P#SI{imrfm-(&YT%uc}h>{)X~Kn!;P#U)(q>7D}amQ$V+Lv
zKhR}A*d1M(TYh_Kh7$rMOG)f{1g?IlcN7I16Y+6o1K_qLn~<>+mnU(Z{2iZPdy)o^
za3U^yU<$_dYr`7>V)Oa+*KwU9LH;A4a+f<`#+<mGNEDSZN{oSl+HK!$w{&AS`ycl3
z^W-pE1{>PjD1ZzLgz?D<v*VcAl1H@$6Dj72@Y5s1!3?*k4628FI4*Cl{HN>W)SRM}
zV2U*~u`yy9ZFYnOlFLE^Kc^J#*w)?G>nr@-XN!w8UehOH2E8@U_V}HK?#1qp19d&U
zyq=m>b06GmlU*#*QKf6~mHMZGv`%R3%~R7qLiox4?Fe0;P}8^chc$2wT9lpg$Jp%!
t{~U7)!sQ9YQhr<|-B6QR_X!q-2|Y>S*oL8Q|MVn2uruIbYU;m!eglcT&LjW;

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/RamPatch.txt b/ar3k/30101coex/RamPatch.txt
new file mode 100755
index 0000000000000000000000000000000000000000..152bfcd3c969fa96c6d17030d0b44f7598350d2b
GIT binary patch
literal 17916
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
OrsNf6Me3p1*Y`gx_p8SM

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/ar3kbdaddr.pst b/ar3k/30101coex/ar3kbdaddr.pst
new file mode 100755
index 0000000000000000000000000000000000000000..0a9efba5c33d518879e37080bf24a2dd64baa8ea
GIT binary patch
literal 13
UcmXpsGBYqSG*2@yHZb4<022!WnE(I)

literal 0
HcmV?d00001

-- 
1.6.3.3

