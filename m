Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36389 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3LaCrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 21:47:10 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/5] ath9k: Add version/revision macros for QCA9531
Date: Tue, 31 Dec 2013 08:11:58 +0530
Message-Id: <1388457722-29643-1-git-send-email-sujith@msujith.org> (sfid-20131231_034714_900935_ECAE7ED5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c9a8b77..b1fd3fa 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -813,6 +813,9 @@
 #define AR_SREV_REVISION_9565_101       1
 #define AR_SREV_REVISION_9565_11        2
 #define AR_SREV_VERSION_9550		0x400
+#define AR_SREV_VERSION_9531            0x500
+#define AR_SREV_REVISION_9531_10        0
+#define AR_SREV_REVISION_9531_11        1
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -946,11 +949,19 @@
 #define AR_SREV_9580(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
 	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9580_10))
-
 #define AR_SREV_9580_10(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
 	((_ah)->hw_version.macRev == AR_SREV_REVISION_9580_10))
 
+#define AR_SREV_9531(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531))
+#define AR_SREV_9531_10(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_10))
+#define AR_SREV_9531_11(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9531) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9531_11))
+
 /* NOTE: When adding chips newer than Peacock, add chip check here */
 #define AR_SREV_9580_10_OR_LATER(_ah) \
 	(AR_SREV_9580(_ah))
-- 
1.8.5.2

