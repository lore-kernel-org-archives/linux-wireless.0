Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42496 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752158AbdHETnl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:43:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:18 +0300
Message-Id: <20170805194331.17426-7-luca@coelho.fi> (sfid-20170805_214403_979792_AB08C62C)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 06/19] iwlwifi: fix a few instances of misaligned kerneldoc parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There are a few places where we don't have a space between the * and
the @ in the parameter description.  Also, in one case, the @ had
trailing space before the parameter name.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 95dbed609f3e..2909d1ed89cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -421,7 +421,7 @@ enum iwl_tx_status {
  *	occur if tx failed for this frame when it was a member of a previous
  *	aggregation block). If rate scaling is used, retry count indicates the
  *	rate table entry used for all frames in the new agg.
- *@ AGG_TX_STATE_SEQ_NUM_MSK: Command ID and sequence number of Tx command for
+ * @AGG_TX_STATE_SEQ_NUM_MSK: Command ID and sequence number of Tx command for
  *	this frame
  *
  * TODO: complete documentation
-- 
2.13.2
