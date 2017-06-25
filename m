Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34852 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751208AbdFYLMI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:36 +0300
Message-Id: <20170625111158.1792-5-luca@coelho.fi> (sfid-20170625_131218_134037_E331C17B)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 04/26] iwlwifi: mvm: docs: fix enum link, provide TX response link
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix the enum link by adding the missing & and provide the link
to the TX response documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index c30e0e95b0b0..a5a8616dad6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -488,7 +488,7 @@ enum iwl_tx_agg_status {
 
 /**
  * struct agg_tx_status - per packet TX aggregation status
- * @status: enum iwl_tx_agg_status
+ * @status: See &enum iwl_tx_agg_status
  * @sequence: Sequence # for this frame's Tx cmd (not SSN!)
  */
 struct agg_tx_status {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index cc6af9bd4e10..7a52fb6b4924 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -216,7 +216,8 @@ enum iwl_legacy_cmds {
 	FW_GET_ITEM_CMD = 0x1a,
 
 	/**
-	 * @TX_CMD: uses &struct iwl_tx_cmd or &struct iwl_tx_cmd_gen2
+	 * @TX_CMD: uses &struct iwl_tx_cmd or &struct iwl_tx_cmd_gen2,
+	 *	response in &struct iwl_mvm_tx_resp
 	 */
 	TX_CMD = 0x1c,
 
-- 
2.11.0
