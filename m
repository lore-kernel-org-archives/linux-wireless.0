Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34881 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbdBBRxt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 12:53:49 -0500
Received: by mail-lf0-f41.google.com with SMTP id n124so12685754lfd.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 09:53:48 -0800 (PST)
From: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
To: kvalo@qca.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH] ath10k: remove unneeded semicolon
Date: Thu,  2 Feb 2017 18:53:42 +0100
Message-Id: <20170202175342.26338-1-ext.waldemar.rymarkiewicz@tieto.com> (sfid-20170202_185354_006828_AB7014DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove redundant semicolon after switch statement.

Signed-off-by: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 12e67c46ea0a..ae1b64584eb2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2493,7 +2493,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
 				skb->data, skb->len);
 		break;
-	};
+	}
 	return true;
 }
 EXPORT_SYMBOL(ath10k_htt_t2h_msg_handler);
-- 
2.11.0
