Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37134 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1DDRTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 13:19:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wey-yi.w.guy@intel.com,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: [PATCH] iwlwifi: accept EEPROM version 0x423 for iwl6000
Date: Mon,  4 Apr 2011 13:18:44 -0400
Message-Id: <1301937524-6860-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of these devices have appeared "in the wild", and apparently
the Windows driver is perfectly happy to support this EEPROM version.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 98aa8af..20b6646 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -241,7 +241,7 @@ struct iwl_eeprom_enhanced_txpwr {
 
 /* 6x00 Specific */
 #define EEPROM_6000_TX_POWER_VERSION    (4)
-#define EEPROM_6000_EEPROM_VERSION	(0x434)
+#define EEPROM_6000_EEPROM_VERSION	(0x423)
 
 /* 6x50 Specific */
 #define EEPROM_6050_TX_POWER_VERSION    (4)
-- 
1.7.4

