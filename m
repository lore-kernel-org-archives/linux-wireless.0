Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:59504 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab3GEOqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 10:46:11 -0400
Subject: [PATCH] ath10k: remove unneeded semicolon
To: ath9k-devel@lists.ath9k.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: fengguang.wu@intel.com, linux-wireless@vger.kernel.org
Date: Fri, 05 Jul 2013 17:46:06 +0300
Message-ID: <20130705144606.3535.79884.stgit@localhost6.localdomain6> (sfid-20130705_164614_510792_49B79FE2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coccinelly found:

drivers/net/wireless/ath/ath10k/htt_rx.c:1163:2-3: Unneeded semicolon

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index de058d7..ad28866 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1160,7 +1160,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "htt event: ",
 				skb->data, skb->len);
 		break;
-	};
+	}
 
 	/* Free the indication buffer */
 	dev_kfree_skb_any(skb);

