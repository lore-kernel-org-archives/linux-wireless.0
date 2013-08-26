Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53525 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3HZH5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:57:31 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix DEBUG_FS dependency for ath9k
Date: Mon, 26 Aug 2013 13:23:43 +0530
Message-Id: <1377503623-1366-1-git-send-email-sujith@msujith.org> (sfid-20130826_095734_661405_32C0442E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index c91bc61..7944c25 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -56,7 +56,7 @@ config ATH9K_AHB
 
 config ATH9K_DEBUGFS
 	bool "Atheros ath9k debugging"
-	depends on ATH9K
+	depends on ATH9K && DEBUG_FS
 	select MAC80211_DEBUGFS
 	select RELAY
 	---help---
-- 
1.8.3.4

