Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40623 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424740AbcBRHc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:32:59 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 18/24] staging: wilc1000: linux_wlan.c: removes unnecessary log messages
Date: Thu, 18 Feb 2016 16:27:29 +0900
Message-ID: <1455780455-21365-18-git-send-email-leo.kim@atmel.com> (sfid-20160218_083302_758362_E0764661)
In-Reply-To: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
References: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a731b46..660bf63 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -226,7 +226,6 @@ static void deinit_irq(struct net_device *dev)
 
 void wilc_dbg(u8 *buff)
 {
-	PRINT_D(INIT_DBG, "%d\n", *buff);
 }
 
 int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
-- 
1.9.1

