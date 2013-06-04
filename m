Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42487 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3FDKOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:14:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath9k: Remove unused ANI macros
Date: Tue,  4 Jun 2013 15:41:35 +0530
Message-Id: <1370340695-29003-6-git-send-email-sujith@msujith.org> (sfid-20130604_121434_716269_61595F59)
In-Reply-To: <1370340695-29003-1-git-send-email-sujith@msujith.org>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 1088472..b75aea2 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -21,17 +21,10 @@
 
 /* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_HIGH          3500
-
-/* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_LOW           400
-
-/* units are errors per second */
 #define ATH9K_ANI_CCK_TRIG_HIGH           600
-
-/* units are errors per second */
 #define ATH9K_ANI_CCK_TRIG_LOW            300
 
-#define ATH9K_ANI_NOISE_IMMUNE_LVL        4
 #define ATH9K_ANI_SPUR_IMMUNE_LVL         3
 #define ATH9K_ANI_FIRSTEP_LVL             2
 
@@ -43,10 +36,6 @@
 /* in ms */
 #define ATH9K_ANI_POLLINTERVAL            1000
 
-#define HAL_NOISE_IMMUNE_MAX              4
-#define HAL_SPUR_IMMUNE_MAX               7
-#define HAL_FIRST_STEP_MAX                2
-
 #define ATH9K_SIG_FIRSTEP_SETTING_MIN     0
 #define ATH9K_SIG_FIRSTEP_SETTING_MAX     20
 #define ATH9K_SIG_SPUR_IMM_SETTING_MIN    0
-- 
1.8.3

