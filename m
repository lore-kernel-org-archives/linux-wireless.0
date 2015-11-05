Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27019 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030300AbbKEFg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:29 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 31/38] staging: wilc1000: fixes missing a blank line after declarations
Date: Thu, 5 Nov 2015 14:36:32 +0900
Message-ID: <1446701799-24870-31-git-send-email-glen.lee@atmel.com> (sfid-20151105_063801_008156_DDFB48D5)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
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
index 003165d..c529a15 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -542,6 +542,7 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 
 	return 0;
 }
+
 static int linux_wlan_firmware_download(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
@@ -880,6 +881,7 @@ static int wlan_deinit_locks(struct net_device *dev)
 
 	return 0;
 }
+
 void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
-- 
1.9.1

