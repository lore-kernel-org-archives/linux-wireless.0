Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34386 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753394AbdFVVWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:58 +0300
Message-Id: <20170622212101.16422-23-luca@coelho.fi> (sfid-20170622_232216_601717_778972C2)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: mvm: document status bits
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index a4bee9c740e0..0b5e92c1483e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1081,6 +1081,18 @@ struct iwl_mvm {
 #define IWL_MAC80211_GET_MVM(_hw)			\
 	IWL_OP_MODE_GET_MVM((struct iwl_op_mode *)((_hw)->priv))
 
+/**
+ * enum iwl_mvm_status - MVM status bits
+ * @IWL_MVM_STATUS_HW_RFKILL: HW RF-kill is asserted
+ * @IWL_MVM_STATUS_HW_CTKILL: CT-kill is active
+ * @IWL_MVM_STATUS_ROC_RUNNING: remain-on-channel is running
+ * @IWL_MVM_STATUS_IN_HW_RESTART: HW restart is active
+ * @IWL_MVM_STATUS_IN_D0I3: NIC is in D0i3
+ * @IWL_MVM_STATUS_ROC_AUX_RUNNING: AUX remain-on-channel is running
+ * @IWL_MVM_STATUS_D3_RECONFIG: D3 reconfiguration is being done
+ * @IWL_MVM_STATUS_DUMPING_FW_LOG: FW log is being dumped
+ * @IWL_MVM_STATUS_FIRMWARE_RUNNING: firmware is running
+ */
 enum iwl_mvm_status {
 	IWL_MVM_STATUS_HW_RFKILL,
 	IWL_MVM_STATUS_HW_CTKILL,
-- 
2.11.0
