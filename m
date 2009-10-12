Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59071 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbZJLMOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:14:24 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 14/16] wl1271: Update boot time configuration for the new firmware
Date: Mon, 12 Oct 2009 15:08:55 +0300
Message-Id: <1255349337-9776-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Update the magic values of the wl1271 boot time config according to the new
reference driver.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index f9315f6..e45af07 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -202,7 +202,7 @@ static int wl1271_init_general_parms(struct wl1271 *wl)
 	gen_parms->clk_valid_on_wakeup = 0;
 	gen_parms->dc2dcmode = 0;
 	gen_parms->single_dual_band = 0;
-	gen_parms->tx_bip_fem_autodetect = 1;
+	gen_parms->tx_bip_fem_autodetect = 0;
 	gen_parms->tx_bip_fem_manufacturer = 1;
 	gen_parms->settings = 1;
 
-- 
1.5.6.5

