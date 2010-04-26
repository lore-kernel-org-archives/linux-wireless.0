Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34501 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0DZUK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ar9170: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:18 -0400
Message-Id: <1272312558-22566-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ar9170/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index fed6695..cfc6a35 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -926,7 +926,6 @@ static void ar9170_rx_phy_status(struct ar9170 *ar,
 
 	/* TODO: we could do something with phy_errors */
 	status->signal = ar->noise[0] + phy->rssi_combined;
-	status->noise = ar->noise[0];
 }
 
 static struct sk_buff *ar9170_rx_copy_data(u8 *buf, int len)
-- 
1.6.6.1

