Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbbCLNGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/49] iwlwifi: mvm: fix identation
Date: Thu, 12 Mar 2015 15:04:16 +0200
Message-Id: <1426165474-25586-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140739_424246_1B2C6F55)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mvm->fw->dbg_dest_tlv really needs to be under the right
parenthesis.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index f94b322..80121e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -872,8 +872,8 @@ static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 
 	/* start recording again if the firmware is not crashed */
 	WARN_ON_ONCE((!test_bit(STATUS_FW_ERROR, &mvm->trans->status)) &&
-		      mvm->fw->dbg_dest_tlv &&
-		      iwl_mvm_start_fw_dbg_conf(mvm, mvm->fw_dbg_conf));
+		     mvm->fw->dbg_dest_tlv &&
+		     iwl_mvm_start_fw_dbg_conf(mvm, mvm->fw_dbg_conf));
 
 	mutex_unlock(&mvm->mutex);
 
-- 
1.9.1

