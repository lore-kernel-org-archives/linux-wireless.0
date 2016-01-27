Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14270 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcA0C5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 21:57:23 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/13] staging: wilc1000: fixes add spaces required around
Date: Wed, 27 Jan 2016 11:50:27 +0900
Message-ID: <1453863037-31073-3-git-send-email-glen.lee@atmel.com> (sfid-20160127_035725_417950_7AA845DF)
In-Reply-To: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
References: <1453863037-31073-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for spaces required around that '=' or '||' or '('.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9552469..a3b4939 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -993,7 +993,7 @@ int wilc_mac_open(struct net_device *ndev)
 	vif = netdev_priv(ndev);
 	wl = vif->wilc;
 
-	if (!wl|| !wl->dev) {
+	if (!wl || !wl->dev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
@@ -1074,7 +1074,7 @@ int wilc_mac_open(struct net_device *ndev)
 
 static struct net_device_stats *mac_stats(struct net_device *dev)
 {
-	struct wilc_vif *vif= netdev_priv(dev);
+	struct wilc_vif *vif = netdev_priv(dev);
 
 	return &vif->netstats;
 }
-- 
1.9.1

