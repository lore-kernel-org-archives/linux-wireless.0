Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36748 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbbILOCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 10:02:18 -0400
Received: by padhk3 with SMTP id hk3so100470346pad.3
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 07:02:17 -0700 (PDT)
Message-ID: <1442066532.7214.1.camel@ingics.com> (sfid-20150912_160239_908892_9352F08C)
Subject: [PATCH] staging: wilc1000: Add terminating entry for wilc_sdio_ids
From: Axel Lin <axel.lin@ingics.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Date: Sat, 12 Sep 2015 22:02:12 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdio_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 37f31f4..5f0e6cd 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -40,6 +40,7 @@ static unsigned int sdio_default_speed;
 
 static const struct sdio_device_id wilc_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_WILC, SDIO_DEVICE_ID_WILC) },
+	{ },
 };
 
 
-- 
2.1.0



