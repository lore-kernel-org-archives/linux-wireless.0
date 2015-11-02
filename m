Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7856 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbKBIvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:51:20 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 31/38] staging: wilc1000: fixes missing a blank line after declarations
Date: Mon, 2 Nov 2015 17:51:14 +0900
Message-ID: <1446454281-22484-31-git-send-email-glen.lee@atmel.com> (sfid-20151102_101657_277427_C5FA8546)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
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
index aaa938f..98c3cd0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -547,6 +547,7 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 
 	return ret;
 }
+
 static int linux_wlan_firmware_download(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
@@ -885,6 +886,7 @@ static int wlan_deinit_locks(struct net_device *dev)
 
 	return 0;
 }
+
 void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
-- 
1.9.1

