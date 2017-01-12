Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:48399 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752571AbdALDpQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 22:45:16 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 7/7] staging:wilc1000:wilc_sdio.c Deleted un-needed blank lines
Date: Wed, 11 Jan 2017 21:38:38 -0600
Message-Id: <1484192328-16825-7-git-send-email-scott@matheina.com> (sfid-20170112_044537_189752_B365D00F)
In-Reply-To: <1484192328-16825-1-git-send-email-scott@matheina.com>
References: <1484192328-16825-1-git-send-email-scott@matheina.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch CHECK:
Blank lines aren't necessary before a close brace '}'
Please don't use multiple blank lines

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index e48cebe..cd6b8ba 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -81,7 +81,6 @@ static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
 	return ret;
 }
 
-
 static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 {
 	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
@@ -915,7 +914,6 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 					__LINE__);
 				goto _fail_;
 			}
-
 		}
 	} else {
 		if (g_sdio.irq_gpio) {
@@ -945,7 +943,6 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 								__LINE__);
 							goto _fail_;
 						}
-
 					}
 					if (!ret)
 						break;
-- 
2.7.4
