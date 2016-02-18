Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30468 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425347AbcBRLgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 06:36:13 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V2 20/24] staging: wilc1000: wilc_wlan.c: removes unnecessary log messages
Date: Thu, 18 Feb 2016 20:30:20 +0900
Message-ID: <1455795024-26978-20-git-send-email-leo.kim@atmel.com> (sfid-20160218_123617_483733_670AFFB5)
In-Reply-To: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
References: <1455795024-26978-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 50f85ac..0cd3ed8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1028,7 +1028,6 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 			ret = -EIO;
 			goto _fail_;
 		}
-		PRINT_D(INIT_DBG, "Offset = %d\n", offset);
 	} while (offset < buffer_size);
 
 _fail_:
@@ -1461,8 +1460,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	wilc = vif->wilc;
 
-	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
-
 	wilc->quit = 0;
 
 	if (!wilc->hif_func->hif_init(wilc, false)) {
-- 
1.9.1

