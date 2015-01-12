Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34683 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbALTmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:42:09 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 6/8] ath10k:  fix spelling in htt code comment.
Date: Mon, 12 Jan 2015 11:41:47 -0800
Message-Id: <1421091709-19891-6-git-send-email-greearb@candelatech.com> (sfid-20150112_204216_113928_84A25D1B)
In-Reply-To: <1421091709-19891-1-git-send-email-greearb@candelatech.com>
References: <1421091709-19891-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Fix spelling error.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fdd665c..a3ca25c 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -130,7 +130,7 @@ static void ath10k_htt_rx_msdu_buff_replenish(struct ath10k_htt *htt)
 	 * automatically balances load wrt to CPU power.
 	 *
 	 * This probably comes at a cost of lower maximum throughput but
-	 * improves the avarage and stability. */
+	 * improves the average and stability. */
 	spin_lock_bh(&htt->rx_ring.lock);
 	num_deficit = htt->rx_ring.fill_level - htt->rx_ring.fill_cnt;
 	num_to_fill = min(ATH10K_HTT_MAX_NUM_REFILL, num_deficit);
-- 
1.7.11.7

