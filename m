Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45808 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdL1THq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 14:07:46 -0500
Received: by mail-lf0-f68.google.com with SMTP id f13so46136829lff.12
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 11:07:45 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 2/3] ath10k: remove unused prototype
Date: Thu, 28 Dec 2017 20:06:44 +0100
Message-Id: <20171228190645.25773-3-erik.stromdahl@gmail.com> (sfid-20171228_200751_144651_56BA81E6)
In-Reply-To: <20171228190645.25773-1-erik.stromdahl@gmail.com>
References: <20171228190645.25773-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function does not exist and thus, the prototype can be removed.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 783640032216..360c71b106d7 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1933,7 +1933,6 @@ void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
 int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
-int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
 int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu);
-- 
2.15.1
