Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59426 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFEUnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:13 +0300
Message-Id: <20170605204218.30151-21-luca@coelho.fi> (sfid-20170605_224344_558051_34AE4CAF)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: mvm: document structures used for BEACON_TEMPLATE_CMD
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index bf0523d8ca9a..19cb0ee120c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -328,6 +328,12 @@ enum iwl_legacy_cmds {
 	SET_CALIB_DEFAULT_CMD = 0x8e,
 
 	BEACON_NOTIFICATION = 0x90,
+	/**
+	 * @BEACON_TEMPLATE_CMD:
+	 *	Uses one of &struct iwl_mac_beacon_cmd_v6,
+	 *	&struct iwl_mac_beacon_cmd_v7 or &struct iwl_mac_beacon_cmd
+	 *	depending on the device version.
+	 */
 	BEACON_TEMPLATE_CMD = 0x91,
 	/**
 	 * @TX_ANT_CONFIGURATION_CMD: &struct iwl_tx_ant_cfg_cmd
-- 
2.11.0
