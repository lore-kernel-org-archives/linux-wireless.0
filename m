Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758582Ab1FKOzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:41 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/18] iwlagn: Band capabilities in EEPROM
Date: Sat, 11 Jun 2011 07:25:41 -0700
Message-Id: <1307802352-16398-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165551_697916_FF8AF07B)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add define for band capabilities in EEPROM

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index c960c6f..5086318 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -110,12 +110,13 @@ enum {
 };
 
 /* SKU Capabilities */
-/* 5000 and up */
 #define EEPROM_SKU_CAP_BAND_POS				(4)
 #define EEPROM_SKU_CAP_BAND_SELECTION	                \
 		(3 << EEPROM_SKU_CAP_BAND_POS)
+#define EEPROM_SKU_CAP_BAND_24GHZ			(1 << 4)
+#define EEPROM_SKU_CAP_BAND_52GHZ			(1 << 5)
 #define EEPROM_SKU_CAP_11N_ENABLE	                (1 << 6)
-#define EEPROM_SKU_CAP_AMT_ENABLE	                (1 << 7)
+#define EEPROM_SKU_CAP_AMT_ENABLE			(1 << 7)
 #define EEPROM_SKU_CAP_IPAN_ENABLE	                (1 << 8)
 
 /* *regulatory* channel data format in eeprom, one for each channel.
-- 
1.7.0.4

