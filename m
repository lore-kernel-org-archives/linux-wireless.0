Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11446 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbLUFQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:47 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 17/46] staging: wilc1000: linux_wlan_spi.c: add a blank
Date: Mon, 21 Dec 2015 14:18:21 +0900
Message-ID: <1450675130-17866-18-git-send-email-glen.lee@atmel.com> (sfid-20151221_063100_870596_C41313F0)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes checkpatch warning: missing a blank like after declarations.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 6fcf7b3..190243a 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -79,6 +79,7 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 			.delay_usecs = 0,
 		};
 		char *r_buffer = kzalloc(len, GFP_KERNEL);
+
 		if (!r_buffer)
 			return -ENOMEM;
 
@@ -127,6 +128,7 @@ int wilc_spi_read(struct wilc *wilc, u8 *rb, u32 rlen)
 
 		};
 		char *t_buffer = kzalloc(rlen, GFP_KERNEL);
+
 		if (!t_buffer)
 			return -ENOMEM;
 
-- 
1.9.1

