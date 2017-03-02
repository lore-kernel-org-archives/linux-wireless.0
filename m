Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33844 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbdCBRQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 12:16:13 -0500
Received: by mail-wr0-f195.google.com with SMTP id u48so10375057wrc.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 09:15:27 -0800 (PST)
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Staging:wilc1000:wilc_spi: Added blank line after function and modified comment style
Date: Thu,  2 Mar 2017 19:07:04 +0200
Message-Id: <1488474424-16210-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_183054_348250_1D7EF718)
In-Reply-To: <1488474379-16101-1-git-send-email-geo.emmnl@gmail.com>
References: <1488474379-16101-1-git-send-email-geo.emmnl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added blank line after function and modified comment style.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 4f38922..33c2f7c 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1128,11 +1128,8 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)

 	return 1;
 }
-/********************************************
- *
- *      Global spi HIF function table
- *
- ********************************************/
+
+/* Global spi HIF function table */
 static const struct wilc_hif_func wilc_hif_spi = {
 	.hif_init = wilc_spi_init,
 	.hif_deinit = _wilc_spi_deinit,
--
2.1.4
