Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:60097 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdAMVWn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:22:43 -0500
Date: Fri, 13 Jan 2017 22:22:35 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 08/40] rt2x00: allow to build rt2800soc module for RT3883
Message-ID: <20170113212230.GA3405@makrotopia.org> (sfid-20170113_222245_910004_3E5082D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/Kconfig b/drivers/net/wireless/ralink/rt2x00/Kconfig
index de62f5dcb62f..3f2651dcbf37 100644
--- a/drivers/net/wireless/ralink/rt2x00/Kconfig
+++ b/drivers/net/wireless/ralink/rt2x00/Kconfig
@@ -201,7 +201,7 @@ endif
 
 config RT2800SOC
 	tristate "Ralink WiSoC support"
-	depends on SOC_RT288X || SOC_RT305X
+	depends on SOC_RT288X || SOC_RT305X || SOC_RT3883
 	select RT2X00_LIB_SOC
 	select RT2X00_LIB_MMIO
 	select RT2X00_LIB_CRYPTO
-- 
2.11.0
