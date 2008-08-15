Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYHOCEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:46 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/15] iwlwifi: remove obsolete 4965 forward declarations
Date: Fri, 15 Aug 2008 10:01:09 +0800
Message-Id: <1218765680-8378-5-git-send-email-yi.zhu@intel.com> (sfid-20080815_040451_398341_D5167A51)
In-Reply-To: <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
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

