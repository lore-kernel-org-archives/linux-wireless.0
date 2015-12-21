Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11360 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbLUFQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:23 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 13/46] staging: wilc1000: linux_wlan_sdio.c: remove braces
Date: Mon, 21 Dec 2015 14:18:17 +0900
Message-ID: <1450675130-17866-14-git-send-email-glen.lee@atmel.com> (sfid-20151221_063105_358310_77BCFC28)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes checkpatch warning braces{} are not necessary for single
statment blocks.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 78e6808..64fb81b 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -159,9 +159,8 @@ void wilc_sdio_disable_interrupt(struct wilc *dev)
 
 	sdio_claim_host(func);
 	ret = sdio_release_irq(func);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&func->dev, "can't release sdio_irq, err(%d)\n", ret);
-	}
 	sdio_release_host(func);
 
 	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
-- 
1.9.1

