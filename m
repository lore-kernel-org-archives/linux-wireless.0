Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbbJYMBp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/16] iwlwifi: mvm: clean up some whitespace in scan code
Date: Sun, 25 Oct 2015 14:01:12 +0200
Message-Id: <1445774476-24792-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130148_307789_2F610932)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index ed15b50..a8e11cc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -474,7 +474,7 @@ iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
 	int ret;
 
 	if (WARN_ON(req->n_match_sets > IWL_SCAN_MAX_PROFILES))
-			return -EIO;
+		return -EIO;
 
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_SHORT_BL)
 		blacklist_len = IWL_SCAN_SHORT_BLACKLIST_LEN;
@@ -842,7 +842,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 * plan with one iteration.
 	 */
 	if (!cmd->schedule[i - 1].iterations)
-			cmd->schedule[i - 1].iterations = 0xff;
+		cmd->schedule[i - 1].iterations = 0xff;
 
 	if (iwl_mvm_scan_use_ebs(mvm, vif)) {
 		cmd->channel_opt[0].flags =
@@ -908,7 +908,6 @@ static __le32 iwl_mvm_scan_config_rates(struct iwl_mvm *mvm)
 
 int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 {
-
 	struct iwl_scan_config *scan_config;
 	struct ieee80211_supported_band *band;
 	int num_channels =
-- 
2.1.4

