Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53705 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2I0Kik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:40 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>
Subject: [PATCH 04/31] wl18xx: increase rx_ba_win_size to 32
Date: Thu, 27 Sep 2012 13:37:42 +0300
Message-Id: <1348742289-6587-5-git-send-email-luca@coelho.fi> (sfid-20120927_124036_537453_35E0ED81)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

The new FWs support a bigger BA window.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 3c274eb..181cd94 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -415,7 +415,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.snr_threshold			= 0,
 	},
 	.ht = {
-		.rx_ba_win_size = 10,
+		.rx_ba_win_size = 32,
 		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
 		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
-- 
1.7.10.4

