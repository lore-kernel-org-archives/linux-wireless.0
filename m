Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35079 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdFFXUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Jun 2017 19:20:45 -0400
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: johannes.berg@intel.com
Cc: Seraphime Kirkovski <kirkseraph@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org (open list:INTEL WIRELESS WIFI LINK
        (iwlwifi)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: wireless: intel: iwlwifi: dvm: remove unused defines
Date: Wed,  7 Jun 2017 01:20:27 +0200
Message-Id: <20170606232031.28893-1-kirkseraph@gmail.com> (sfid-20170607_012118_364231_CCF83B2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those constants have been unused for quite some time now.

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
---
 I've compile-tested it.

 drivers/net/wireless/intel/iwlwifi/dvm/commands.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index 2ab2773655a8..37d2ba5ae852 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -1446,13 +1446,6 @@ struct agg_tx_status {
  *   or rate table color was changed during frame retries
  * refer tlc rate info
  */
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
2.11.0
