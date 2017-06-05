Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59440 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFEUnz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:15 +0300
Message-Id: <20170605204218.30151-23-luca@coelho.fi> (sfid-20170605_224359_133568_0D8840B2)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: mvm: remove SCAN_GROUP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware no longer uses this command group, so remove it from
the driver as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index cfadc5fb0e1d..cc6af9bd4e10 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -571,7 +571,6 @@ enum iwl_debug_cmds {
  *	&enum iwl_phy_ops_subcmd_ids
  * @DATA_PATH_GROUP: data path group, uses command IDs from
  *	&enum iwl_data_path_subcmd_ids
- * @SCAN_GROUP: scan group, uses command IDs from &enum iwl_scan_subcmd_ids
  * @NAN_GROUP: NAN group, uses command IDs from &enum iwl_nan_subcmd_ids
  * @TOF_GROUP: TOF group, uses command IDs from &enum iwl_tof_subcmd_ids
  * @PROT_OFFLOAD_GROUP: protocol offload group, uses command IDs from
-- 
2.11.0
