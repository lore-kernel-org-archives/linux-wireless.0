Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48955 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbbKWJpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 04:45:41 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/10] staging: wilc1000: linux_wlan_spi.c: fix NULL comparison style
Date: Mon, 23 Nov 2015 18:48:08 +0900
Message-ID: <1448272088-13973-10-git-send-email-glen.lee@atmel.com> (sfid-20151123_104543_422906_537DB1F0)
In-Reply-To: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
References: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes checkpatch CHECK:comparison to NULL could be written "b".

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 190243a..6111405 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -72,7 +72,7 @@ int wilc_spi_write(struct wilc *wilc, u8 *b, u32 len)
 	int ret;
 	struct spi_message msg;
 
-	if (len > 0 && b != NULL) {
+	if (len > 0 && b) {
 		struct spi_transfer tr = {
 			.tx_buf = b,
 			.len = len,
-- 
1.9.1

