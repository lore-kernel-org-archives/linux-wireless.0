Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab0KYBi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/12] iwlwifi: remove unused define
Date: Wed, 24 Nov 2010 17:32:37 -0800
Message-Id: <1290648768-10075-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

was not used, remove it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index e87be1e..583916d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -410,7 +410,6 @@ struct iwl_eeprom_calib_info {
 #define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
 #define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 #define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
-#define EEPROM_3945_M_VERSION               (2*0x4A)	/* 1  bytes */
 #define EEPROM_NUM_MAC_ADDRESS              (2*0x4C)	/* 2  bytes */
 
 /* The following masks are to be applied on EEPROM_RADIO_CONFIG */
-- 
1.7.0.4

