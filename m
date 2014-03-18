Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50336 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282AbaCROqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:45 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so5423902eek.20
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/35] iwlwifi: mvm: remove spurious blank line
Date: Tue, 18 Mar 2014 16:45:37 +0200
Message-Id: <1395153939-23897-33-git-send-email-egrumbach@gmail.com> (sfid-20140318_154701_014414_ED81ED9F)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove a spurious blank line in the quota code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 7ec62ef..35e86e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -262,7 +262,6 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 			 * binding.
 			 */
 			cmd.quotas[idx].quota = cpu_to_le32(QUOTA_LOWLAT_MIN);
-
 		else
 			cmd.quotas[idx].quota =
 				cpu_to_le32(quota * data.n_interfaces[i]);
-- 
1.8.3.2

