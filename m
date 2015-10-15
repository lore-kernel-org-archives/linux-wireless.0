Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9678 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbJOKla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 06:41:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH 1/5] ath10k: QCA988X hw2.0: add board.bin
Date: Thu, 15 Oct 2015 13:40:40 +0300
Message-ID: <1444905644-16296-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20151015_124135_470356_BAA6A631)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 40d14143b787 ("ath10k: add firmware 10.2.4.45 as firmware-4.bin") I
forgot to commit board.bin file and that's why it was not included in the
commit even I had added an entry to WHENCE. Add that now.

At the same time also add Version field for firmware-4.bin.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 WHENCE                         |    1 +
 ath10k/QCA988X/hw2.0/board.bin |  Bin 0 -> 2116 bytes
 2 files changed, 1 insertion(+)
 create mode 100644 ath10k/QCA988X/hw2.0/board.bin

diff --git a/WHENCE b/WHENCE
index e3a3d89d387c..801b34b6fcf2 100644
--- a/WHENCE
+++ b/WHENCE
@@ -2390,6 +2390,7 @@ Driver: ath10k - Qualcomm Atheros support for QCA988x family of chips
 
 File: ath10k/QCA988X/hw2.0/board.bin
 File: ath10k/QCA988X/hw2.0/firmware-4.bin
+Version: 10.2.4.45
 
 Licence: Redistributable. See LICENSE.QualcommAtheros_ath10k for details
 
diff --git a/ath10k/QCA988X/hw2.0/board.bin b/ath10k/QCA988X/hw2.0/board.bin
new file mode 100644
index 0000000000000000000000000000000000000000..8f8bd6b99ace2fcfd5a63c072856c215a86a3f59
GIT binary patch
literal 2116
zcmZ?axNpG3!obWfWD>@}ki}r{$-v>l!@<D7AP>aGKnwyMf(*V876yq+977=~0{jdL
zObiTyf{Y9Sj3CIsAV7+Cx~S!11i3LZlof89Ae=RP7-tz6911!YG4KeqFjNA`8iqoc
z=YCWG`Hc)^K(dk{A4RmDp%^Gy#*l*~3S*K-7py7hT*CmvN^l@2qof4EA|fL1&Um@3
zaXI4Uf{QIAB=qh~7Q-6016d5X*n&c$;!-k>POk1=K88l7=2kWg3<afg7r}5<{p1-S
zHiTZYqo8#88W66k2dP2O*u-sWY;353i48+xpeKceMTEqJMTNzfMS(0~Awf}LAYWJn
zgfY$WiHOPQ*|PT}pHL=4ECZiV9z!}z5iq{_gmM`Yfn+&D0g7lILlRK5lA#Diw2&bU
zC|bi%iXz&?Pz@B#0qTGPu(=h$vWHK|kHG;&w3s0oDC)srg(8~G5CIf*W-vh#g)zyc
zeL^yN7VN|%<z%G9uwelKfitTz7`oUNWH3;|=HcOa_ihctIj#q57zP7dKukhXTGqkM
z!_(W>z|6wZ+LnRACnlk1%Z|NgVYFXdTHm^D`;P}DO<J_+@c;kl;@~tiVZ#;}?H2~r
zFm2g7kox~XfG!Tx52Fd0Ut?1P%tt^HPJ{ClFl#{ox;RKB1VL!9Dj*XEVDeyo4M=GX
zgoM)|-3Wk?hlrD#=3x2+1cgOKL?onCl#~=zl$Df}RTP!flz~`DSwTioUY?LV%$$Lu
E0as;$_y7O^

literal 0
HcmV?d00001

-- 
1.7.9.5

