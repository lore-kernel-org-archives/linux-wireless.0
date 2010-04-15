Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260Ab0DOVjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 04/97] ath9k_hw: fix a missing hex prefix for a register mask
Date: Thu, 15 Apr 2010 17:38:09 -0400
Message-Id: <1271367582-992-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

This is not a stable code fix as this register is not used anywhere.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/reg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 68d55a2..c1e58da 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1544,7 +1544,7 @@ enum {
 #define AR_TSFOOR_THRESHOLD       0x813c
 #define AR_TSFOOR_THRESHOLD_VAL   0x0000FFFF
 
-#define AR_PHY_ERR_EIFS_MASK   8144
+#define AR_PHY_ERR_EIFS_MASK   0x8144
 
 #define AR_PHY_ERR_3           0x8168
 #define AR_PHY_ERR_3_COUNT     0x00FFFFFF
-- 
1.6.3.3

