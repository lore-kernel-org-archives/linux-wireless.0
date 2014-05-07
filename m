Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44038 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaEGTxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:37 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so1475456wgh.26
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:36 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/23] iwlwifi: mvm: rs - s/CPTCFG/CONFIG
Date: Wed,  7 May 2014 22:52:40 +0300
Message-Id: <1399492380-12050-3-git-send-email-egrumbach@gmail.com> (sfid-20140507_215401_969262_4360DC0C)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

My bad - I forgot to update this when sending the patch
upstream.

Fixes: 87d5e4155c00 ("iwlwifi: mvm: rs: reinit rs if no tx for a long time")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 9f52c5b..e1c8388 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1010,7 +1010,7 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 		return;
 	}
 
-#ifdef CPTCFG_MAC80211_DEBUGFS
+#ifdef CONFIG_MAC80211_DEBUGFS
 	/* Disable last tx check if we are debugging with fixed rate */
 	if (lq_sta->dbg_fixed_rate) {
 		IWL_DEBUG_RATE(mvm, "Fixed rate. avoid rate scaling\n");
-- 
1.8.3.2

