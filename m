Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934498Ab1IOTcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/27] iwlagn: remove unused function declarations
Date: Thu, 15 Sep 2011 11:46:47 -0700
Message-Id: <1316112414-6341-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213231_489448_E7064E51)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwl_suspend and iwl_resume don't exist.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8272a94..40186a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -420,11 +420,6 @@ enum iwl_rxon_context_id {
 	NUM_IWL_RXON_CTX
 };
 
-#ifdef CONFIG_PM
-int iwl_suspend(struct iwl_priv *priv);
-int iwl_resume(struct iwl_priv *priv);
-#endif /* !CONFIG_PM */
-
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg);
 void __devexit iwl_remove(struct iwl_priv * priv);
-- 
1.7.0.4

