Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0FLEeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/24] ath9k_hw: move clock definitions from hw.c to hw.h
Date: Sat, 12 Jun 2010 00:33:39 -0400
Message-Id: <1276317242-15540-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These will be used by the ANI code next.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 -----
 drivers/net/wireless/ath/ath9k/hw.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2adc7e7..5f46861 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -23,11 +23,6 @@
 #include "rc.h"
 #include "ar9003_mac.h"
 
-#define ATH9K_CLOCK_RATE_CCK		22
-#define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
-#define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
-#define ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM 44
-
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 
 MODULE_AUTHOR("Atheros Communications");
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 88bf2fc..3a28cdc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -938,4 +938,9 @@ void ar9003_hw_attach_ops(struct ath_hw *ah);
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
 
+#define ATH9K_CLOCK_RATE_CCK		22
+#define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
+#define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
+#define ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM 44
+
 #endif
-- 
1.6.3.3

