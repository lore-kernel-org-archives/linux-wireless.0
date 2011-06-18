Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1FRQFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/25] iwlagn: remove incorrect define
Date: Sat, 18 Jun 2011 08:34:31 -0700
Message-Id: <1308411271-26093-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180542_205228_D6E04B0A)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused and incorrect EEPROM define

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index c6f370f..804f910 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -275,7 +275,6 @@ extern const u8 iwl_eeprom_band_1[14];
 #define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
 #define EEPROM_SKU_CAP                      (2*0x45)	/* 2  bytes */
 #define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
-#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 #define EEPROM_RADIO_CONFIG                 (2*0x48)	/* 2  bytes */
 #define EEPROM_NUM_MAC_ADDRESS              (2*0x4C)	/* 2  bytes */
 
-- 
1.7.0.4

