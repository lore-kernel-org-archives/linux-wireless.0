Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56489 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCIG5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:24 -0500
Subject: [PATCH 3/6] ath6kl: remove spaces before semicolon
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:23 +0200
Message-ID: <20140309065723.10793.31242.stgit@x230> (sfid-20140309_075727_063711_B4A79956)
In-Reply-To: <20140309065606.10793.67068.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning:

CHECK: space prohibited before semicolon

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/target.h |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index a580a62..d5eeeae 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -289,7 +289,7 @@ struct host_interest {
 	u32 hi_hp_rx_traffic_ratio;                    /* 0xd8 */
 
 	/* test applications flags */
-	u32 hi_test_apps_related    ;                  /* 0xdc */
+	u32 hi_test_apps_related;                      /* 0xdc */
 	/* location of test script */
 	u32 hi_ota_testscript;                         /* 0xe0 */
 	/* location of CAL data */
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index e9c28a7..40432fe 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -361,7 +361,7 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	u32 map_no = 0;
 	u16 htc_tag = ATH6KL_DATA_PKT_TAG;
-	u8 ac = 99 ; /* initialize to unmapped ac */
+	u8 ac = 99; /* initialize to unmapped ac */
 	bool chk_adhoc_ps_mapping = false;
 	int ret;
 	struct wmi_tx_meta_v2 meta_v2;
@@ -1214,7 +1214,7 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
 		return is_queued;
 
 	spin_lock_bh(&rxtid->lock);
-	for (idx = 0 ; idx < rxtid->hold_q_sz; idx++) {
+	for (idx = 0; idx < rxtid->hold_q_sz; idx++) {
 		if (rxtid->hold_q[idx].skb) {
 			/*
 			 * There is a frame in the queue and no

