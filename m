Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2FYIZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 04:25:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20456.8254.776584.527413@gargle.gargle.HOWL> (sfid-20120625_102545_350923_1496BA57)
Date: Mon, 25 Jun 2012 13:54:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k_htc: Change default listen interval to 1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 25213d5..cac6ff4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -718,7 +718,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 
 	hw->queues = 4;
 	hw->channel_change_time = 5000;
-	hw->max_listen_interval = 10;
+	hw->max_listen_interval = 1;
 
 	hw->vif_data_size = sizeof(struct ath9k_htc_vif);
 	hw->sta_data_size = sizeof(struct ath9k_htc_sta);
-- 
1.7.11

