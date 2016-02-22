Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29567 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbcBVEOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:14:52 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V3 01/24] staging: wilc1000: wilc_wlan.c: removes PRINT_ER
Date: Mon, 22 Feb 2016 13:11:46 +0900
Message-ID: <1456114329-7036-2-git-send-email-leo.kim@atmel.com> (sfid-20160222_051455_767066_B537F6C0)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
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
index 391173b..c6d206d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1468,7 +1468,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->tx_buffer) {
 		ret = -ENOBUFS;
-		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
 
@@ -1477,7 +1476,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->rx_buffer) {
 		ret = -ENOBUFS;
-		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
 	}
 
-- 
1.9.1

