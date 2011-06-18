Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab1FRQFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/25] iwlagn: code alignment
Date: Sat, 18 Jun 2011 08:34:29 -0700
Message-Id: <1308411271-26093-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180543_262406_A964D2B9)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code alignment, no functional changes.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 406eb2f..56a22de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -80,10 +80,10 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX)
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
-			EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
-			EEPROM_RF_CFG_DASH_MSK(radio_cfg));
+		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
+			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
 	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-- 
1.7.0.4

