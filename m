Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:39948 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbcBRHaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:30:09 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/24] staging: wilc1000: wilc_wlan.c: removes PRINT_ER
Date: Thu, 18 Feb 2016 16:27:12 +0900
Message-ID: <1455780455-21365-1-git-send-email-leo.kim@atmel.com> (sfid-20160218_083025_174165_20C41F48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches removes PRINT_ER that is unnecessary debug logs.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ef65e8e..50f85ac 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1480,7 +1480,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->tx_buffer) {
 		ret = -ENOBUFS;
-		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
 
@@ -1489,7 +1488,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->rx_buffer) {
 		ret = -ENOBUFS;
-		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
 	}
 
-- 
1.9.1

