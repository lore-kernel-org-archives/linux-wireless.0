Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9625 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbcBDJYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:24:31 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 16/70] staging: wilc1000: fixes missing a blank line after declarations
Date: Thu, 4 Feb 2016 18:15:33 +0900
Message-ID: <1454577387-509-17-git-send-email-glen.lee@atmel.com> (sfid-20160204_104503_714992_ECA00CB8)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warnings reported by checkpatch.pl
for Missing a blank line after declarations.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 06c79dd..5992478 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -853,6 +853,7 @@ static void wlan_deinitialize_threads(struct net_device *dev)
 {
 	struct wilc_vif *vif;
 	struct wilc *wl;
+
 	vif = netdev_priv(dev);
 	wl = vif->wilc;
 
@@ -1472,6 +1473,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 		{
 			struct wireless_dev *wdev;
+
 			wdev = wilc_create_wiphy(ndev, dev);
 
 			if (dev)
-- 
1.9.1

