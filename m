Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56322 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3FFX41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 19:56:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix merge conflict
Date: Fri,  7 Jun 2013 05:23:38 +0530
Message-Id: <1370562818-16530-1-git-send-email-sujith@msujith.org> (sfid-20130607_015633_695923_BA37DB8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The option config option ATH9K_MAC_DEBUG has been removed
in the commit, "ath9k: Remove MAC_DEBUG".

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 3c2cbc9..760ab3f 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -84,14 +84,6 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
-config ATH9K_MAC_DEBUG
-	bool "Atheros MAC statistics"
-	depends on ATH9K_DEBUGFS
-	default y
-	---help---
-	  This option enables collection of statistics for Rx/Tx status
-	  data and some other MAC related statistics
-
 config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
-- 
1.8.3

