Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37746 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab3LFLEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:04:01 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/16] ath9k: Remove AR9330 v1.0 macro as it's not supported
Date: Fri,  6 Dec 2013 16:28:51 +0530
Message-Id: <1386327534-31105-14-git-send-email-sujith@msujith.org> (sfid-20131206_120417_622799_BF73FAF5)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 259a4b3..9ad0073 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -883,9 +883,6 @@
 
 #define AR_SREV_9330(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9330))
-#define AR_SREV_9330_10(_ah) \
-	(AR_SREV_9330((_ah)) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9330_10))
 #define AR_SREV_9330_11(_ah) \
 	(AR_SREV_9330((_ah)) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9330_11))
-- 
1.8.4.2

