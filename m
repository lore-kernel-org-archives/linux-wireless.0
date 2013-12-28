Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58054 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3L1EWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:20 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] ath9k: Remove unused functions
Date: Sat, 28 Dec 2013 09:47:09 +0530
Message-Id: <1388204235-14682-1-git-send-email-sujith@msujith.org> (sfid-20131228_052244_985352_2210EBB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fc4bb48..77fb523 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -37,18 +37,6 @@ MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
-static int __init ath9k_init(void)
-{
-	return 0;
-}
-module_init(ath9k_init);
-
-static void __exit ath9k_exit(void)
-{
-	return;
-}
-module_exit(ath9k_exit);
-
 /* Private hardware callbacks */
 
 static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
-- 
1.8.5.2

