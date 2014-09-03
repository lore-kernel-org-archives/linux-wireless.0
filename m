Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44761 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaICT5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:06 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so10515750wib.16
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/36] iwlwifi: mvm: fix comment typo
Date: Wed,  3 Sep 2014 22:56:12 +0300
Message-Id: <1409774184-24665-24-git-send-email-egrumbach@gmail.com> (sfid-20140903_215757_877722_8F6C5A7E)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e3be34f..166d17c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -495,7 +495,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		goto out_free;
 
 	/*
-	 * Even if nvm exists in the nvm_file driver should read agin the nvm
+	 * Even if nvm exists in the nvm_file driver should read again the nvm
 	 * from the nic because there might be entries that exist in the OTP
 	 * and not in the file.
 	 * for nics with no_power_up_nic_in_init: rely completley on nvm_file
-- 
1.9.1

