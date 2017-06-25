Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34952 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751244AbdFYLMl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:52 +0300
Message-Id: <20170625111158.1792-21-luca@coelho.fi> (sfid-20170625_131302_396934_8930F0F4)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 20/26] iwlwifi: mvm: document assoc_beacon_arrive_time
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Document the assoc_beacon_arrive_time element in the iwl_mac_data_sta
struct.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
index aa5aaf7c940d..1d970bf0d735 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
@@ -199,6 +199,7 @@ struct iwl_mac_data_ibss {
  * @dtim_reciprocal: 2^32 / dtim_interval , applicable only when associated
  * @listen_interval: in beacon intervals, applicable only when associated
  * @assoc_id: unique ID assigned by the AP during association
+ * @assoc_beacon_arrive_time: TSF of first beacon after association
  */
 struct iwl_mac_data_sta {
 	__le32 is_assoc;
-- 
2.11.0
