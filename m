Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33982 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752680AbdCBSNW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 13:13:22 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Staging:wilc1000:wilc_spi: Fixed spelling error
Date: Thu,  2 Mar 2017 19:06:19 +0200
Message-Id: <1488474379-16101-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_191400_069218_5075E616)
In-Reply-To: <1488474328-15992-1-git-send-email-geo.emmnl@gmail.com>
References: <1488474328-15992-1-git-send-email-geo.emmnl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed spelling error. 'unkmown' to 'unknown'.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index b48cb1c8..4f38922 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -963,12 +963,12 @@ static int wilc_spi_read_int(struct wilc *wilc, u32 *int_status)
 				}

 				{
-					u32 unkmown_mask;
+					u32 unknown_mask;

-					unkmown_mask = ~((1ul << g_spi.nint) - 1);
+					unknown_mask = ~((1ul << g_spi.nint) - 1);

-					if ((tmp >> IRG_FLAGS_OFFSET) & unkmown_mask) {
-						dev_err(&spi->dev, "Unexpected interrupt (2): j=%d, tmp=%x, mask=%x\n", j, tmp, unkmown_mask);
+					if ((tmp >> IRG_FLAGS_OFFSET) & unknown_mask) {
+						dev_err(&spi->dev, "Unexpected interrupt (2): j=%d, tmp=%x, mask=%x\n", j, tmp, unknown_mask);
 						happended = 1;
 					}
 				}
--
2.1.4
