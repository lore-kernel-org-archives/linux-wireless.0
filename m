Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36239 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaHEUvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 16:51:21 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k: fix typo in error message.
Date: Tue,  5 Aug 2014 13:51:18 -0700
Message-Id: <1407271878-15230-1-git-send-email-greearb@candelatech.com> (sfid-20140805_225123_903244_132FFF34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e67137a..b2e7303 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2004,7 +2004,7 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 			     ar->fw_features)) {
 			if (skb_queue_len(&ar->wmi_mgmt_tx_queue) >=
 			    ATH10K_MAX_NUM_MGMT_PENDING) {
-				ath10k_warn("reached WMI management tranmist queue limit\n");
+				ath10k_warn("reached WMI management transmit queue limit\n");
 				ret = -EBUSY;
 				goto exit;
 			}
-- 
1.7.11.7

