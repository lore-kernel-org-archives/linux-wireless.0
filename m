Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26963 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030300AbbKEFgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:12 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 28/38] staging: wilc1000: fixes braces {} should be used on all arms of this statement
Date: Thu, 5 Nov 2015 14:36:29 +0900
Message-ID: <1446701799-24870-28-git-send-email-glen.lee@atmel.com> (sfid-20151105_063755_158342_AE21CC91)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for braces {} should be used on all arms of this statement.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2fac99d..893c741 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -477,12 +477,11 @@ int linux_wlan_get_firmware(struct net_device *dev)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	if (nic->iftype == AP_MODE)
+	if (nic->iftype == AP_MODE) {
 		firmware = AP_FIRMWARE;
-	else if (nic->iftype == STATION_MODE)
+	} else if (nic->iftype == STATION_MODE) {
 		firmware = STA_FIRMWARE;
-
-	else {
+	} else {
 		PRINT_D(INIT_DBG, "Get P2P_CONCURRENCY_FIRMWARE\n");
 		firmware = P2P_CONCURRENCY_FIRMWARE;
 	}
-- 
1.9.1

