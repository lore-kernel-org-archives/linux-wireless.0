Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40986 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752270AbdG1O0T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Seraphime Kirkovski <kirkseraph@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:23 +0300
Message-Id: <20170728142337.19183-11-luca@coelho.fi> (sfid-20170728_162622_791860_694AEE5E)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 10/24] iwlwifi: dvm: remove unused defines
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Seraphime Kirkovski <kirkseraph@gmail.com>

Those constants have been unused for quite some time now.

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index 2ab2773655a8..ede47e3c5971 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -1437,22 +1437,6 @@ struct agg_tx_status {
 	__le16 sequence;
 } __packed;
 
-/*
- * definitions for initial rate index field
- * bits [3:0] initial rate index
- * bits [6:4] rate table color, used for the initial rate
- * bit-7 invalid rate indication
- *   i.e. rate was not chosen from rate table
- *   or rate table color was changed during frame retries
- * refer tlc rate info
- */
-
-#define IWL50_TX_RES_INIT_RATE_INDEX_POS	0
-#define IWL50_TX_RES_INIT_RATE_INDEX_MSK	0x0f
-#define IWL50_TX_RES_RATE_TABLE_COLOR_POS	4
-#define IWL50_TX_RES_RATE_TABLE_COLOR_MSK	0x70
-#define IWL50_TX_RES_INV_RATE_INDEX_MSK	0x80
-
 /* refer to ra_tid */
 #define IWLAGN_TX_RES_TID_POS	0
 #define IWLAGN_TX_RES_TID_MSK	0x0f
-- 
2.13.2
