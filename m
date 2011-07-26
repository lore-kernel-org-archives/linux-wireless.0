Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15803 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1GZIiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 04:38:08 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 01:37:26 -0700
From: Benny Chuang <bchuang@qca.qualcomm.com>
To: <auke-jan.h.kok@intel.com>, <David.Woodhouse@intel.com>,
	<dwmw2@infradead.org>, <linux-wireless@vger.kernel.org>
CC: <samuel.ortiz@intel.com>, <vipimeht@qca.qualcomm.com>,
	<vwei@qca.qualcomm.com>, <skchen@qca.qualcomm.com>,
	<surajs@qca.qualcomm.com>, <maggieh@qca.qualcomm.com>,
	<samuelc@qca.qualcomm.com>, <suraj.chilled@gmail.com>,
	Benny Chuang <bchuang@qca.qualcomm.com>
Subject: [PATCH 2/2] Qualcomm Atheros adds Bluetooth firmware for WiFi-BT combo module
Date: Tue, 26 Jul 2011 16:38:05 +0800
Message-ID: <1311669485-4204-1-git-send-email-bchuang@qca.qualcomm.com> (sfid-20110726_103825_661090_32C5E931)
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
 ar3k/30101coex/RamPatch.txt           |  Bin 0 -> 19436 bytes
 ar3k/30101coex/ar3kbdaddr.pst         |  Bin 0 -> 13 bytes
 6 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 ar3k/30101coex/PS_ASIC.pst
 create mode 100644 ar3k/30101coex/PS_ASIC_aclHighPri.pst
 create mode 100644 ar3k/30101coex/PS_ASIC_aclLowPri.pst
 create mode 100644 ar3k/30101coex/RamPatch.txt
 create mode 100644 ar3k/30101coex/ar3kbdaddr.pst

diff --git a/WHENCE b/WHENCE
index 8e10723..6231d7e 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1734,3 +1734,16 @@ File: ath6k/AR6003.1/hw2.1.1/endpointping.bin
 File: ath6k/AR6003.1/hw2.1.1/otp.bin
 
 License: Redistributable. See LICENCE.atheros_firmware for details
+
+--------------------------------------------------------------------------
+
+Driver: ath6kl - Atheros support for AR3001 WiFi-Bluetooth combo module
+
+File: ar3k/30101coex
+File: ar3k/30101coex/ar3kbdaddr.pst
+File: ar3k/30101coex/PS_ASIC_aclLowPri.pst
+File: ar3k/30101coex/PS_ASIC_aclHighPri.pst
+File: ar3k/30101coex/PS_ASIC.pst
+File: ar3k/30101coex/RamPatch.txt
+
+License: Redistributable. See LICENCE.atheros_firmware for details
diff --git a/ar3k/30101coex/PS_ASIC.pst b/ar3k/30101coex/PS_ASIC.pst
new file mode 100644
index 0000000000000000000000000000000000000000..617d21388ac5cf1ac4aa44b4c2bb42ca20629591
GIT binary patch
literal 2166
zcmah~+fLg+5Pi>AjKpIp*<D}5o9#Glr6M7qPbd#2-hf4LP;gq>ukV@JT_>eCv@(<N
z%<P#n7f+^Bs<!qOkAB_V?|046ZTrc|<o4tF^-?LF1<4qeie;+_$0$-bhLo1)jMR!X
zCMLBe4ZSnaG$H=upRf!{mdE3i#|FxKwT5sez<AZP-Ij*tZe!`D_&_5<ZK{AU_6SQ&
zI37dpuZ|Eu6**wz6h!t2fgGBO;(#P}zKS3uG0h5Z&t`eZOCmVSd`5LmnW8$SNPOqH
z{9I51v*WuE6G7Y&%V;DAN<pGWgTO{<2#49Y{{Ax9Ct69(gpY6C@IdNSR|jU4jsi1f
z>S|YM!qJ(4acpP;Gf5&~YN{%VA|VQRLXIhNPe}t+LW>0-2zh{qpYTF1{FE#lpP&~u
z{;iR>lGl7eHAs$VA&DDtsY8z5J`#ID$U$&dO(vIsF;~_H4+w!xySEkTf<T>vr)$oF
zWf%xZ7k{kyh?%_%7X_Ijiwd0_s?Vt*Lg-{JT%gWXunLxpQ;yG~;w=1K&IZYXUPYMz
z12!*1FFdebY`mAVgiG*BHKn5*Q7VOlS6Way-X&fh!%Ub&3bRm)QZ&dHZIDSv$%H0y
zH8(0kAqz}2f=k`w(&v=`u%S8LW+5+hvi6ZHR9X77ejV(tr^r0gJ8XoDhaXg3enI2j
zbpvJR^s=$`ncD7!$9Zad{&z~PT{rv9K*N@t3J&({{)`pg)_I=NYGa!nxoEJGz2wLg
z{>SB@j1D89VmAW0a9++yFW_0WP227uoVYN&@{~T3QzsWo3^!OouG!jE122j_FQxT%
zN1yt^Zs?P_=3h_Ea6q7BDM?(9z|{|Bj-n9b$b6jH0Jv?*CS)v1@VmKA-sX2$y?-*7
zJ#Y-h^=rc$0U)N+%g^IF1wsBJpmN6@Fk?<!Pb7-U7$wHQ!0o#4)@!=5tL<02`+i6#
znui$L$0*P|SRgVc{B&~>l-Zm|wT2Q+&J*G1K!$@AZc!Oj5AShtd3E7GU587}AxlZ7
zSi%z<BbL$T+p$1$S!mGbl;S#$b@Tc10{?Ea*?Af-={>Q6zBP|_|4c*oWVic)x}Kh1
z4$Z2W<y&pC^I1B&bS=J8e|3;LhQ?k!H2pn{AMD$U(Dey5eM`SYgVvx$`BMHEyS?C_
oBc~7?Pbil1<0_29O=jH_EDlHV5rtzLhPwUdCb{o8)Iaa}34I363jhEB

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/PS_ASIC_aclHighPri.pst b/ar3k/30101coex/PS_ASIC_aclHighPri.pst
new file mode 100644
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
new file mode 100644
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
new file mode 100644
index 0000000000000000000000000000000000000000..3a89f0c7962be2cfcbb9a6a1f0f9946aff7ea967
GIT binary patch
literal 19436
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

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/ar3kbdaddr.pst b/ar3k/30101coex/ar3kbdaddr.pst
new file mode 100644
index 0000000000000000000000000000000000000000..ab466e49a70ef369a02110e90283d5b11ed6be95
GIT binary patch
literal 13
UcmXpsGEPf1G*2@yHZb4<02aRj{Qv*}

literal 0
HcmV?d00001

-- 
1.6.3.3

