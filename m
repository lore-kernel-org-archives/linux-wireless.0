Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34394 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753394AbdFVVWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:21:01 +0300
Message-Id: <20170622212101.16422-26-luca@coelho.fi> (sfid-20170622_232218_313081_FAC9DB6A)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: mvm: better link scan notification results length
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Show the name of the member (scanned_channels) that provides the
length with some better markup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index d27c67b67015..f8e92026bdc6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -769,7 +769,7 @@ struct iwl_scan_offload_profiles_query {
  * @last_channel: last channel that was scanned
  * @start_tsf: TSF timer in usecs of the scan start time for the mac specified
  *	in &struct iwl_scan_req_umac.
- * @results: array of scan results, only "scanned_channels" of them are valid
+ * @results: array of scan results, length in @scanned_channels
  */
 struct iwl_umac_scan_iter_complete_notif {
 	__le32 uid;
-- 
2.11.0
