Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62564 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965577Ab3E2Kc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 06:32:29 -0400
Received: by mail-pd0-f174.google.com with SMTP id 3so6955456pdj.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 May 2013 03:32:28 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, coelho@ti.com,
	linville@tuxdriver.com, sachin.kamat@linaro.org
Subject: [PATCH 2/2] net: wireless: wl1251: Fix commenting style
Date: Wed, 29 May 2013 15:48:23 +0530
Message-Id: <1369822703-27769-2-git-send-email-sachin.kamat@linaro.org> (sfid-20130529_123238_009479_92249C90)
In-Reply-To: <1369822703-27769-1-git-send-email-sachin.kamat@linaro.org>
References: <1369822703-27769-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the commenting style consistent with networking block comment
style as suggested by checkpatch.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/net/wireless/ti/wl1251/spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index dfd0877..c7dc6fe 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -93,8 +93,7 @@ static void wl1251_spi_wake(struct wl1251 *wl)
 	memset(&t, 0, sizeof(t));
 	spi_message_init(&m);
 
-	/*
-	 * Set WSPI_INIT_COMMAND
+	/* Set WSPI_INIT_COMMAND
 	 * the data is being send from the MSB to LSB
 	 */
 	cmd[2] = 0xff;
@@ -262,7 +261,8 @@ static int wl1251_spi_probe(struct spi_device *spi)
 	wl->if_ops = &wl1251_spi_ops;
 
 	/* This is the only SPI value that we need to set here, the rest
-	 * comes from the board-peripherals file */
+	 * comes from the board-peripherals file
+	 */
 	spi->bits_per_word = 32;
 
 	ret = spi_setup(spi);
-- 
1.7.9.5

