Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47520 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1COOZX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 10:25:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 07:25:00 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/4] ath9k_htc: Fix LED pin for AR9287 HTC device
Date: Tue, 15 Mar 2011 19:55:35 +0530
Message-ID: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index d160a8e..57dfb3c 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -325,7 +325,7 @@ struct ath9k_debug {
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
 #define ATH_LED_PIN_DEF             1
-#define ATH_LED_PIN_9287            8
+#define ATH_LED_PIN_9287            10
 #define ATH_LED_PIN_9271            15
 #define ATH_LED_PIN_7010            12
 #define ATH_LED_ON_DURATION_IDLE    350	/* in msecs */
-- 
1.7.4.1

