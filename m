Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35760 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751545AbdF1UNu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:13:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:02 +0300
Message-Id: <20170628201330.9432-4-luca@coelho.fi> (sfid-20170628_221359_056962_C31E483B)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 03/31] iwlwifi: mvm: remove some CamelCase from firmware API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
index edde49202786..3463d1c577e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
@@ -164,7 +164,7 @@ struct iwl_proto_offload_cmd_v2 {
 	u8 solicited_node_ipv6_addr[16];
 	u8 target_ipv6_addr[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2][16];
 	u8 ndp_mac_addr[ETH_ALEN];
-	u8 numValidIPv6Addresses;
+	u8 num_valid_ipv6_addrs;
 	u8 reserved2[3];
 } __packed; /* PROT_OFFLOAD_CONFIG_CMD_DB_S_VER_2 */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index b84e8ddbbbc9..7588b93f835a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -1748,8 +1748,8 @@ enum iwl_mvm_marker_id {
  * @metadata: additional meta data that will be written to the unsiffer log
  */
 struct iwl_mvm_marker {
-	u8 dwLen;
-	u8 markerId;
+	u8 dw_len;
+	u8 marker_id;
 	__le16 reserved;
 	__le64 timestamp;
 	__le32 metadata[0];
-- 
2.11.0
