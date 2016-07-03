Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60786 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbcGCTtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:42 +0300
Message-Id: <1467575332-32112-3-git-send-email-luca@coelho.fi> (sfid-20160703_214917_462503_E7D6FFC5)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 03/13] iwlwifi: mvm: fix comment indentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Somehow we ended up without leading spaces here, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 28 +++++++++++-----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 1ca8e49..bb8ff40 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -435,26 +435,26 @@ struct iwl_rxq_sync_notification {
 } __packed; /* MULTI_QUEUE_DRV_SYNC_HDR_CMD_API_S_VER_1 */
 
 /**
-* Internal message identifier
-*
-* @IWL_MVM_RXQ_EMPTY: empty sync notification
-* @IWL_MVM_RXQ_NOTIF_DEL_BA: notify RSS queues of delBA
-*/
+ * Internal message identifier
+ *
+ * @IWL_MVM_RXQ_EMPTY: empty sync notification
+ * @IWL_MVM_RXQ_NOTIF_DEL_BA: notify RSS queues of delBA
+ */
 enum iwl_mvm_rxq_notif_type {
 	IWL_MVM_RXQ_EMPTY,
 	IWL_MVM_RXQ_NOTIF_DEL_BA,
 };
 
 /**
-* struct iwl_mvm_internal_rxq_notif - Internal representation of the data sent
-* in &iwl_rxq_sync_cmd. Should be DWORD aligned.
-* FW is agnostic to the payload, so there are no endianity requirements.
-*
-* @type: value from &iwl_mvm_rxq_notif_type
-* @sync: ctrl path is waiting for all notifications to be received
-* @cookie: internal cookie to identify old notifications
-* @data: payload
-*/
+ * struct iwl_mvm_internal_rxq_notif - Internal representation of the data sent
+ * in &iwl_rxq_sync_cmd. Should be DWORD aligned.
+ * FW is agnostic to the payload, so there are no endianity requirements.
+ *
+ * @type: value from &iwl_mvm_rxq_notif_type
+ * @sync: ctrl path is waiting for all notifications to be received
+ * @cookie: internal cookie to identify old notifications
+ * @data: payload
+ */
 struct iwl_mvm_internal_rxq_notif {
 	u16 type;
 	u16 sync;
-- 
2.8.1

