Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36345 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbcEDPB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 11:01:59 -0400
Received: by mail-wm0-f49.google.com with SMTP id n129so192770839wmn.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2016 08:01:58 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Shiang Tu <shiang_tu@ralinktech.com>,
	=?UTF-8?q?Hua=20Shao=20=28=E9=82=B5=E5=8D=8E=29?=
	<hua.shao@mediatek.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, linux-firmware@kernel.org
Subject: [PATCH 1/2] linux-firmware: update rt2860.bin, rt2800pci driver
Date: Wed,  4 May 2016 16:59:59 +0200
Message-Id: <1462374000-17149-1-git-send-email-xose.vazquez@gmail.com> (sfid-20160504_170207_598363_8A166C82)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2860.bin: from 34 to 0.40

Cc: Shiang Tu <shiang_tu@ralinktech.com>
Cc: Hua Shao (邵华) <hua.shao@mediatek.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: linux-firmware@kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 WHENCE     |   7 +++++--
 rt2860.bin | Bin 8192 -> 8192 bytes
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/WHENCE b/WHENCE
index b93f333..3feac35 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1370,12 +1370,15 @@ Downloaded from http://www.mediatek.com/en/downloads/
 Driver: rt2800pci - Ralink RT2860, RT2890, RT3090, RT3290, RT5390 wireless MACs
 
 File: rt2860.bin
+Version: 40
+
 File: rt3290.bin
+Version: 37
 
 Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
 
-Binary file supplied by Shiang Tu <shiang_tu@ralinktech.com>. Firmware Version 34
-rt3290.bin is a specific firmware support the RT3290 chip. Firmware Version 37
+Binary file supplied originally by Shiang Tu <shiang_tu@ralinktech.com>, latest
+from http://www.mediatek.com/en/downloads1/downloads/
 
 --------------------------------------------------------------------------
 
diff --git a/rt2860.bin b/rt2860.bin
index 85030fc2d9d91295f647e6d40557c65b6859d2b7..888c20c9f9f8174efec11db3eb666731cbacb4ec 100644
GIT binary patch
delta 2029
zcmah}U2Gdw7WTb&@}D*{<MD57$GCQrn6eosX^=`9T$*51s*N4&hOX3hXrdy19tLVl
zfD}AXB6t9Gl3O930MT8feW<(=5kJy)7fpAy54%V!_XT#f((K~dYFkAaK?i9mjX8JX
z(7+3pX6E`kf8ROxoTFv6Yz&hK#;+!t@Wbc;`!um9*81L9iDgi7B|kc!%+`@MWtA3*
z!dWGiTf$n`a`I3eYr~gHwWNp_w79PFrjyfE!E~lYKBcw0z)a(|E3b39>TTFMhfVof
zM|DvoQ`%Q6f2~mz+lx|kD3&B5{w-ZXQ|Jr&do)OSJkmL2t~EuG4AC5(Y{LN&8}v2&
zKo^;cX%6E|n>afBT($Ad=eH{_ox<p9S^9<Za${U|&LuW<GD&sfIoloFP{@GxZQ_GN
z<PW`7%nxCH6!T+Px{jqA*!L0keS8JH;qYH@WEuw~?4Om}+T**3h+a!1bWSqk*9eyW
zr>mmr9Md_@6!Ag+UoyXz;oscPzcImI&kE>}5X=iF3c{H=;mjk#nWFGsNoXDupIQ{>
z9v9C)>wWO7_sOz!Leiwq&PlJVcs$G@)M^q-U(!$cuzvv#aZF^=y@YGWprr8M%21n6
z-Iuv~0p(o^sMnmv_C<4=vlG^j;Noq7i?>>Ew!<nZ%!1~H{h@S%g-SM8b6Z9&skcDi
z7SiHYAP8{>{)g~zb)n9=W;dJcB2U3vFiYuKT@BjosH-6x?v@dieWWgdZqRhnIvzGb
zHDqpXoP@J2=eSy0<E%8e!9yE1s6m^^m*!ndC~jG^8_*hC0-zX{!(9EehJD8A${4AP
z4>X+7mNu)@f5qodI~l$0*JZ)JSZ=~Y?E0*ZcA3*zyWz-{$>z3ib)uXF`F?0RWKJX7
z2pa*nrYzMSs87cdsU5?3fl-3Uw3QAEbJ;uCe^^(?ta(V5XBmx|SKhgLfy<sXli%6&
zX=!hKUAwZaF~&6bmWIrflbowW*0oRR6VmY1y3Tt{o!@8c{7AXFUAZ6V>;gJnj1C*6
zXIq4h)Z1FQ(7#K5v_P*(6OUyeTL^ViA*PerPSq`AB4Lfsj49pLxNltT_Kj)nTLpAc
zf_-nr!|YvtH#N$J<fwDbR9>jQDEcQhiks8;HakYFQTn2908P-heS@iqjcKw4?=WiE
zZKKxcS|@>vu^v&w^tvxxO(bLq@(w|VKqZ3a?9X?CAzAVwQlVpz8UOblqqc;q9|MEx
zC&1|Zyfv@v($yqucOCD8o37UqIv-iLFK)o4c0(N_rt_%I$H4e&`a6GO-$DN~9)FYb
z-|F=LllL#j{l8KCAHM7H1kmzBhnJ5$uzd8Sm0N6wu?Qf#>DOS%R0GN5;Z-p(Vfc)i
z!9fV4#s<E)TjA<Kt<(DD%q(<9u<oMoHC99Am~EXZ_Br=hgQ`~!wppj*R*xJC0Vp^B
zC<_3$RR(*Ze+TJzfs}VpCGt_hIJ$**F#Ln@;37KVPD*jpwhsTP*e5By$xV2O>NWCO
zUp=q&SP#noAy+kYWi>D7+G=SWew_^w`{Wiols<TODqZmIf`mff!f=^#jx;rVvw1#E
zozMs=7<oDv9y**i3YzzhJAgIL0C2}>Zh7r>{q=yq@XAm8t%mQ}UC<8f@IpTeNAE3Y
zeLElx|H$dqyj!`o9-eK5;tktM7jMkWIB9xU|DHg~s96O`IU*@fB{9T|4AqZUN{F89
zA1H+{>pW)`zqTs{1OhAX$}1_RrHdZ3NK~;J7eNhovZYrk;5%wKvWLO)m!LhMbN8By
z31&V(>-~GtI{klt24(2okzrWvuorl{^15ci_S8j=tySw$*=%R~#2JC@Ta84kDO4%p
zhEveGtUO$9iZ}%;rT7d4m~s44s+JX_2d&f^!FA$xkc@V_A_KuDcZGA3@{pvY+&rTP
z+{K+0^c~B*+AZSs${eng$Tk6M#HCb>-LhG#Mr96o5Dex;NGE#0Wxv~|_eU2XtM{WZ
abddfzI*AfAGw?T>9k|?jX2{U5?)x5!c^4)C

delta 2386
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

-- 
2.5.5

