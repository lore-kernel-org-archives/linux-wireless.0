Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37901 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1HHPs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 11:48:57 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_htc: minor clean-up
Date: Mon, 8 Aug 2011 21:18:49 +0530
Message-ID: <1312818529-8801-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110808_174903_119181_2CBB5BA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 5bc0220..da55967 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -521,8 +521,6 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 
 int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv,
 				u8 enable_coex);
-void ath9k_htc_station_work(struct work_struct *work);
-void ath9k_htc_aggr_work(struct work_struct *work);
 void ath9k_htc_ani_work(struct work_struct *work);
 void ath9k_htc_start_ani(struct ath9k_htc_priv *priv);
 void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
@@ -542,7 +540,6 @@ int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv);
 void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot);
 void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
 void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);
-void ath9k_htc_tx_failed(struct ath9k_htc_priv *priv);
 void ath9k_tx_failed_tasklet(unsigned long data);
 void ath9k_htc_tx_cleanup_timer(unsigned long data);
 
-- 
1.7.0.4

