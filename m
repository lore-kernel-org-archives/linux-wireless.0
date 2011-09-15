Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934528Ab1IOTcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/27] iwlagn: beautify the code - remove uneeded line break
Date: Thu, 15 Sep 2011 11:46:35 -0700
Message-Id: <1316112414-6341-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213324_329121_CC216736)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Two lines could be concatenated without exceeding the 80 char limit.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index d4f6281..498e006 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -308,10 +308,8 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	txq->q.n_window = slots_num;
 
-	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num,
-			    GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num,
-			   GFP_KERNEL);
+	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num, GFP_KERNEL);
+	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num, GFP_KERNEL);
 
 	if (!txq->meta || !txq->cmd)
 		goto error;
-- 
1.7.0.4

