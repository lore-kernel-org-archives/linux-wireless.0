Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbbBCHOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:46 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/19] iwlwifi: mvm: remove space padding after sysassert description
Date: Tue,  3 Feb 2015 09:14:22 +0200
Message-Id: <1422947678-16917-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081450_520770_13FD6019)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's really no reason to pad out the field with spaces at the
end of the line - they're practically invisible there anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 4eb3cad..02f434d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -432,7 +432,7 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 			mvm->status, table.valid);
 	}
 
-	IWL_ERR(mvm, "0x%08X | %-28s\n", table.error_id,
+	IWL_ERR(mvm, "0x%08X | %s\n", table.error_id,
 		desc_lookup(table.error_id));
 	IWL_ERR(mvm, "0x%08X | umac branchlink1\n", table.blink1);
 	IWL_ERR(mvm, "0x%08X | umac branchlink2\n", table.blink2);
-- 
1.9.1

