Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab2EJJRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:18 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:18 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 76/78] wl18xx: increase tx_ba_win_size to 64
Date: Thu, 10 May 2012 12:14:21 +0300
Message-Id: <1336641263-5761-77-git-send-email-arik@wizery.com> (sfid-20120510_111733_884927_AB8D7EFC)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Now the firmware can support TX block ack sessions with 64 frames.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 27cd9b8..5053c05 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -408,7 +408,7 @@ static struct wlcore_conf wl18xx_conf = {
 	},
 	.ht = {
 		.rx_ba_win_size = 10,
-		.tx_ba_win_size = 10,
+		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
 		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
 	},
-- 
1.7.9.5

