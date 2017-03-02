Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35013 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdCBSMW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 13:12:22 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so13804298wmu.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 10:11:00 -0800 (PST)
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Staging:wilc1000:wilc_spi: Fixed alignment to match parenthesis
Date: Thu,  2 Mar 2017 19:05:28 +0200
Message-Id: <1488474328-15992-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_191328_468753_DB150169)
In-Reply-To: <1488474268-15876-1-git-send-email-geo.emmnl@gmail.com>
References: <1488474268-15876-1-git-send-email-geo.emmnl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed alignment to match parenthesis.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 6bd4047..b48cb1c8 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -408,7 +408,7 @@ static int spi_cmd_complete(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz,

 	if (len2 > ARRAY_SIZE(wb)) {
 		dev_err(&spi->dev, "spi buffer size too small (%d) (%zu)\n",
-			 len2, ARRAY_SIZE(wb));
+			len2, ARRAY_SIZE(wb));
 		return N_FAIL;
 	}
 	/* zero spi write buffers. */
--
2.1.4
