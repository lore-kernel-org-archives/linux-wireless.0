Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2IEO1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:27:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>
Subject: [PATCH] iwlwifi: remove radio_config from eeprom_data
Date: Wed,  5 Sep 2012 16:28:08 +0200
Message-Id: <1346855288-23984-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_162734_684032_83A95730)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

No one uses it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Amit Beka <amit.beka@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index 9c07c67..a5e4257 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -85,8 +85,6 @@ struct iwl_eeprom_data {
 	int n_hw_addrs;
 	u8 hw_addr[ETH_ALEN];
 
-	u16 radio_config;
-
 	u8 calib_version;
 	__le16 calib_voltage;
 
-- 
1.7.10.4

