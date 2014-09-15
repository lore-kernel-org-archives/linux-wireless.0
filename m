Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46270 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaIOFNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:30 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so3272337wgg.30
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:29 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/28] iwlwifi: mvm: remove unused static inline function
Date: Mon, 15 Sep 2014 08:12:49 +0300
Message-Id: <1410757980-2138-17-git-send-email-egrumbach@gmail.com> (sfid-20140915_073114_441316_A58606E5)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index eb31648..9eb8524 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -828,12 +828,6 @@ static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
 	iwl_trans_txq_enable_cfg(trans, queue, 0, &cfg);
 }
 
-static inline void
-iwl_trans_txq_enable_no_scd(struct iwl_trans *trans, int queue, u16 ssn)
-{
-	iwl_trans_txq_enable_cfg(trans, queue, ssn, NULL);
-}
-
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
 						u32 txq_bm)
 {
-- 
1.9.1

