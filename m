Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:41826 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbcCOJv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:51:27 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/7] staging: wilc1000: changes an ambiguous debug messages
Date: Tue, 15 Mar 2016 18:48:12 +0900
Message-ID: <1458035294-13001-5-git-send-email-leo.kim@atmel.com> (sfid-20160315_105129_846079_A5E09826)
In-Reply-To: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
References: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches changes an ambiguous debug messages.
The device types are both SDIO or SPI.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1a5de2e..e949f21 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -907,7 +907,7 @@ int wilc_mac_open(struct net_device *ndev)
 	wl = vif->wilc;
 
 	if (!wl || !wl->dev) {
-		netdev_err(ndev, "wilc1000: SPI device not ready\n");
+		netdev_err(ndev, "device not ready\n");
 		return -ENODEV;
 	}
 
-- 
1.9.1

