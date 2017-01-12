Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:38043 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752382AbdALDpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 22:45:15 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 6/7] staging:wilc1000:wilc_sdio.c Aligns code match open parenthesis
Date: Wed, 11 Jan 2017 21:38:37 -0600
Message-Id: <1484192328-16825-6-git-send-email-scott@matheina.com> (sfid-20170112_044529_878989_404CD4A2)
In-Reply-To: <1484192328-16825-1-git-send-email-scott@matheina.com>
References: <1484192328-16825-1-git-send-email-scott@matheina.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch CHECK: Alignment should match open parenthesis

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 3ad7cec..e48cebe 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -127,7 +127,7 @@ static int linux_sdio_probe(struct sdio_func *func,
 
 	dev_dbg(&func->dev, "Initializing netdev\n");
 	ret = wilc_netdev_init(&wilc, &func->dev, HIF_SDIO, gpio,
-			     &wilc_hif_sdio);
+			       &wilc_hif_sdio);
 	if (ret) {
 		dev_err(&func->dev, "Couldn't initialize netdev\n");
 		return ret;
-- 
2.7.4
