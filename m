Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:41757 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbcCOJvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:51:10 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/7] staging: wilc1000: wilc_spi.c: removes debug print log
Date: Tue, 15 Mar 2016 18:48:09 +0900
Message-ID: <1458035294-13001-2-git-send-email-leo.kim@atmel.com> (sfid-20160315_105114_381318_E8522D50)
In-Reply-To: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
References: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches removes unnecessary debug print logs.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index d41b8b6..4268e2f 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -196,9 +196,6 @@ static int wilc_spi_tx(struct wilc *wilc, u8 *b, u32 len)
 		dev_err(&spi->dev,
 			"can't write data with the following length: %d\n",
 			len);
-		dev_err(&spi->dev,
-			"FAILED due to NULL buffer or ZERO length check the following length: %d\n",
-			len);
 		ret = -EINVAL;
 	}
 
-- 
1.9.1

