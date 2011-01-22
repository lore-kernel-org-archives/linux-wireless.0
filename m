Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab1AVASV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:21 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/14] iwlagn: add 2000 series EEPROM version
Date: Fri, 21 Jan 2011 16:06:38 -0800
Message-Id: <1295654809-5790-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding EEPROM version for 2000 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 4f4cd4f..98aa8af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -259,6 +259,15 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_6030_TX_POWER_VERSION    (6)
 #define EEPROM_6030_EEPROM_VERSION	(0x709)
 
+/* 2x00 Specific */
+#define EEPROM_2000_TX_POWER_VERSION    (6)
+#define EEPROM_2000_EEPROM_VERSION	(0x805)
+
+/* 6x35 Specific */
+#define EEPROM_6035_TX_POWER_VERSION    (6)
+#define EEPROM_6035_EEPROM_VERSION	(0x753)
+
+
 /* OTP */
 /* lower blocks contain EEPROM image and calibration data */
 #define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
@@ -268,6 +277,7 @@ struct iwl_eeprom_enhanced_txpwr {
 #define OTP_MAX_LL_ITEMS_1000		(3)	/* OTP blocks for 1000 */
 #define OTP_MAX_LL_ITEMS_6x00		(4)	/* OTP blocks for 6x00 */
 #define OTP_MAX_LL_ITEMS_6x50		(7)	/* OTP blocks for 6x50 */
+#define OTP_MAX_LL_ITEMS_2x00		(4)	/* OTP blocks for 2x00 */
 
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
-- 
1.7.0.4

