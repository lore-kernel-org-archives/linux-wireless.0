Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43151 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932858AbdCaL6G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 07:58:06 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Remove obselete Copy Engine comments
Date: Fri, 31 Mar 2017 17:30:44 +0530
Message-ID: <1490961644-375-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170331_135831_344513_E3FDB19F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Remove obselete Copy Engine comments referring to the function
ath10k_ce_sendlist_send as this function was removed long time back
by the commit 2e761b5a5222 ("ath10k: remove ce_sendlist_send").

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 4045657..9ac0a73 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -261,8 +261,7 @@ static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
 }
 
 /*
- * Guts of ath10k_ce_send, used by both ath10k_ce_send and
- * ath10k_ce_sendlist_send.
+ * Guts of ath10k_ce_send.
  * The caller takes responsibility for any needed locking.
  */
 int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
-- 
1.9.1
