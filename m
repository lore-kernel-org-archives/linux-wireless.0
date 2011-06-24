Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14899 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1FXFpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 01:45:24 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 22:44:48 -0700
From: Benny Chuang <bchuang@qca.qualcomm.com>
To: <auke-jan.h.kok@intel.com>, <David.Woodhouse@intel.com>,
	<dwmw2@infradead.org>, <linux-wireless@vger.kernel.org>
CC: <samuel.ortiz@intel.com>, <vipimeht@qca.qualcomm.com>,
	<vwei@qca.qualcomm.com>, <skchen@qca.qualcomm.com>,
	<surajs@qca.qualcomm.com>, Benny Chuang <bchuang@qca.qualcomm.com>
Subject: [PATCH 2/2] Qualcomm Atheros: Add AR3001 firmware for MeeGo created new folder named 30101coex Signed-off-by: Benny Chuang <bchuang@qca.qualcomm.com>
Date: Fri, 24 Jun 2011 13:45:20 +0800
Message-ID: <1308894320-8089-1-git-send-email-bchuang@qca.qualcomm.com> (sfid-20110624_074537_082634_C10CEA2E)
In-Reply-To: <bchuang@qca.qualcomm.com>
References: <bchuang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 WHENCE                                |    5 +++++
 ar3k/30101coex/PS_ASIC.pst            |  Bin 0 -> 2166 bytes
 ar3k/30101coex/PS_ASIC_aclHighPri.pst |  Bin 0 -> 2166 bytes
 ar3k/30101coex/PS_ASIC_aclLowPri.pst  |  Bin 0 -> 2166 bytes
 ar3k/30101coex/RamPatch.txt           |  Bin 0 -> 17570 bytes
 ar3k/30101coex/ar3kbdaddr.pst         |  Bin 0 -> 13 bytes
 6 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 ar3k/30101coex/PS_ASIC.pst
 create mode 100644 ar3k/30101coex/PS_ASIC_aclHighPri.pst
 create mode 100644 ar3k/30101coex/PS_ASIC_aclLowPri.pst
 create mode 100644 ar3k/30101coex/RamPatch.txt
 create mode 100644 ar3k/30101coex/ar3kbdaddr.pst

diff --git a/WHENCE b/WHENCE
index 1824015..6ce0104 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1658,6 +1658,11 @@ File: ar3k/1020200/RamPatch.txt
 File: ar3k/30101/ar3kbdaddr.pst
 File: ar3k/30101/PS_ASIC.pst
 File: ar3k/30101/RamPatch.txt
+File: ar3k/30101coex/PS_ASIC_aclLowPri.pst
+File: ar3k/30101coex/PS_ASIC_aclHighPri.pst
+File: ar3k/30101coex/ar3kbdaddr.pst
+File: ar3k/30101coex/PS_ASIC.pst
+File: ar3k/30101coex/RamPatch.txt
 File: ar3k/30000/ar3kbdaddr.pst
 File: ar3k/30000/PS_ASIC.pst
 File: ar3k/30000/RamPatch.txt
diff --git a/ar3k/30101coex/PS_ASIC.pst b/ar3k/30101coex/PS_ASIC.pst
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
index 0000000000000000000000000000000000000000..24931ef63826225bbb2405560834bd822ce01b6b
GIT binary patch
literal 17570
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
az^a0FTxE-%9Lg@gO+K|Drd1yC;r{{4f>(Y3

literal 0
HcmV?d00001

diff --git a/ar3k/30101coex/ar3kbdaddr.pst b/ar3k/30101coex/ar3kbdaddr.pst
new file mode 100644
index 0000000000000000000000000000000000000000..0a9efba5c33d518879e37080bf24a2dd64baa8ea
GIT binary patch
literal 13
UcmXpsGBYqSG*2@yHZb4<022!WnE(I)

literal 0
HcmV?d00001

-- 
1.6.3.3

