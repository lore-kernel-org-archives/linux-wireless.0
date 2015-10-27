Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:34791 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950AbbJ0TDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 15:03:24 -0400
From: Punit Vara <punitvara@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Punit Vara <punitvara@gmail.com>
Subject: [RESEND PATCH 01/10] net: wireless: ath: Remove unnecessary semicolon
Date: Wed, 28 Oct 2015 00:32:36 +0530
Message-Id: <1445972565-14963-1-git-send-email-punitvara@gmail.com> (sfid-20151027_200730_852013_94A5F4FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the htt_rx.c that removes unneeded semicolon which is
reported by coccicheck.

Here semicolon just create empty statement so please remote it.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1b7a043..002a633 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2077,7 +2077,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
 				skb->data, skb->len);
 		break;
-	};
+	}
 
 	/* Free the indication buffer */
 	dev_kfree_skb_any(skb);
-- 
2.5.3

