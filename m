Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbZIKRiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/13] iwlwifi: remove un-supported eeprom parameters
Date: Fri, 11 Sep 2009 10:38:09 -0700
Message-Id: <1252690699-25796-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove few of the parameters not used and no longer valid in EEPROM.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 6b68db7..90e2b4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -370,12 +370,10 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
 #define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
 #define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
-#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
 #define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
 #define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 #define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
 #define EEPROM_3945_M_VERSION               (2*0x4A)	/* 1  bytes */
-#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
 
 /* The following masks are to be applied on EEPROM_RADIO_CONFIG */
 #define EEPROM_RF_CFG_TYPE_MSK(x)   (x & 0x3)         /* bits 0-1   */
-- 
1.5.6.3

