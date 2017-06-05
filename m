Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59410 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751321AbdFEUna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:12 +0300
Message-Id: <20170605204218.30151-20-luca@coelho.fi> (sfid-20170605_224335_791711_D50D3399)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 19/25] iwlwifi: mvm: link queue cmd docs to A000 command structs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Document which structures are used with the command for
the A000 hardware flavour.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 23edac4a7009..bf0523d8ca9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -232,7 +232,9 @@ enum iwl_legacy_cmds {
 
 	/* scheduler config */
 	/**
-	 * @SCD_QUEUE_CFG: &struct iwl_scd_txq_cfg_cmd
+	 * @SCD_QUEUE_CFG: &struct iwl_scd_txq_cfg_cmd for older hardware,
+	 *	&struct iwl_tx_queue_cfg_cmd with &struct iwl_tx_queue_cfg_rsp
+	 *	for newer (A000) hardware.
 	 */
 	SCD_QUEUE_CFG = 0x1d,
 
-- 
2.11.0
