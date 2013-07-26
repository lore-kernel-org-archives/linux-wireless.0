Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab3GZI32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/30] iwlwifi: mvm: remove obsolete flag in TX command API
Date: Fri, 26 Jul 2013 10:28:43 +0200
Message-Id: <1374827327-3464-27-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_350736_BB6F0D93)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This API isn't valid any more. It wasn't used anyway.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index 700cce7..d606197 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -91,7 +91,6 @@
  * @TX_CMD_FLG_RESP_TO_DRV: zero this if the response should go only to FW
  * @TX_CMD_FLG_CCMP_AGG: this frame uses CCMP for aggregation acceleration
  * @TX_CMD_FLG_TKIP_MIC_DONE: FW already performed TKIP MIC calculation
- * @TX_CMD_FLG_CTS_ONLY: send CTS only, no data after that
  * @TX_CMD_FLG_DUR: disable duration overwriting used in PS-Poll Assoc-id
  * @TX_CMD_FLG_FW_DROP: FW should mark frame to be dropped
  * @TX_CMD_FLG_EXEC_PAPD: execute PAPD
@@ -120,7 +119,6 @@ enum iwl_tx_flags {
 	TX_CMD_FLG_RESP_TO_DRV		= BIT(21),
 	TX_CMD_FLG_CCMP_AGG		= BIT(22),
 	TX_CMD_FLG_TKIP_MIC_DONE	= BIT(23),
-	TX_CMD_FLG_CTS_ONLY		= BIT(24),
 	TX_CMD_FLG_DUR			= BIT(25),
 	TX_CMD_FLG_FW_DROP		= BIT(26),
 	TX_CMD_FLG_EXEC_PAPD		= BIT(27),
-- 
1.8.0

