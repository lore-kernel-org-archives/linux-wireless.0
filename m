Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50532 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753677AbdDKMh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:37:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:20 +0300
Message-Id: <20170411123742.12214-4-luca@coelho.fi> (sfid-20170411_143806_136314_64478D17)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: mvm: add DQA_ENABLE_CMD to the command list
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow to print the name of the commands in the
logs when we sent it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4cd72d4cdc47..f4f957fe71d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -452,6 +452,7 @@ static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
  * Access is done through binary search
  */
 static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
+	HCMD_NAME(DQA_ENABLE_CMD),
 	HCMD_NAME(UPDATE_MU_GROUPS_CMD),
 	HCMD_NAME(TRIGGER_RX_QUEUES_NOTIF_CMD),
 	HCMD_NAME(STA_PM_NOTIF),
-- 
2.11.0
