Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:33476
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2LZG61 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 01:58:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ath9k_hw: Remove AR9485 1.0 macro
Date: Wed, 26 Dec 2012 12:27:38 +0530
Message-Id: <1356505059-18149-1-git-send-email-sujith@msujith.org> (sfid-20121226_075836_534780_D6F44136)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index ad3c82c..0ac205e 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -884,9 +884,6 @@
 
 #define AR_SREV_9485(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
-#define AR_SREV_9485_10(_ah) \
-	(AR_SREV_9485(_ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9485_10))
 #define AR_SREV_9485_11(_ah) \
 	(AR_SREV_9485(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9485_11))
-- 
1.8.0.2

