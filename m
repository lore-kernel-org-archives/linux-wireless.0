Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbYICDbB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:01 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/39] iwlwifi: remove obsolete 4965 forward declarations
Date: Wed,  3 Sep 2008 11:26:24 +0800
Message-Id: <1220412419-15404-5-git-send-email-yi.zhu@intel.com> (sfid-20080903_053106_123623_395EFFCC)
In-Reply-To: <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes unused forward declarations functions.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f46e9cd..0711b35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -637,12 +637,6 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 
 struct iwl_priv;
 
-/*
- * Forward declare iwl-4965.c functions for iwl-base.c
- */
-extern void iwl4965_rf_kill_ct_config(struct iwl_priv *priv);
-int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
-					u8 tid, int txq_id);
 
 /* Structures, enum, and defines specific to the 4965 */
 
-- 
1.5.3.6

