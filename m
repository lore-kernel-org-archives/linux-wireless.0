Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1FRQFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/25] iwlagn: add offset define for subsystem id
Date: Sat, 18 Jun 2011 08:34:28 -0700
Message-Id: <1308411271-26093-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180551_433568_17C6A5C6)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add offset define for subsystem id in EEPROM

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 19058a6..c1a17f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -268,6 +268,7 @@ extern const u8 iwl_eeprom_band_1[14];
 
 /* General */
 #define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
+#define EEPROM_SUBSYSTEM_ID		    (2*0x0A)	/* 2 bytes */
 #define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
 #define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
 #define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
-- 
1.7.0.4

