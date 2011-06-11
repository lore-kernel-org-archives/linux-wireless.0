Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604Ab1FKOzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/18] iwlagn: group similar defines together
Date: Sat, 11 Jun 2011 07:25:49 -0700
Message-Id: <1307802352-16398-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165557_973496_EF05B2DB)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes, just group similar defines together

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 3dcb0a0..19058a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -162,10 +162,6 @@ struct iwl_eeprom_enhanced_txpwr {
 	s8 mimo3_max;
 } __packed;
 
-/* 5000 Specific */
-#define EEPROM_5000_TX_POWER_VERSION    (4)
-#define EEPROM_5000_EEPROM_VERSION	(0x11A)
-
 /* calibration */
 #define EEPROM_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
 #define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
@@ -203,6 +199,10 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_6000_REG_BAND_24_HT40_CHANNELS  ((0x80)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
 
+/* 5000 Specific */
+#define EEPROM_5000_TX_POWER_VERSION    (4)
+#define EEPROM_5000_EEPROM_VERSION	(0x11A)
+
 /* 5050 Specific */
 #define EEPROM_5050_TX_POWER_VERSION    (4)
 #define EEPROM_5050_EEPROM_VERSION	(0x21E)
-- 
1.7.0.4

