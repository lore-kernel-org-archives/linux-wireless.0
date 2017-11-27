Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([31.24.148.19]:38454 "EHLO
        chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932336AbdK0SFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 13:05:49 -0500
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: kvalo@qca.qualcomm.com
Cc: ath9k-devel@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbd@nbd.name
Subject: [PATCH 1/3] ath9k: remove stray backslash in Makefile
Date: Mon, 27 Nov 2017 18:56:21 +0100
Message-Id: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net> (sfid-20171127_190702_501814_FF5CD925)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
 drivers/net/wireless/ath/ath9k/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 36a40ffdce15..90e4a341076c 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -59,7 +59,7 @@ obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
 ath9k_common-y:=	common.o \
 			common-init.o \
-			common-beacon.o \
+			common-beacon.o
 
 ath9k_common-$(CONFIG_ATH9K_COMMON_DEBUG) += common-debug.o \
 					     common-spectral.o
-- 
2.15.0
