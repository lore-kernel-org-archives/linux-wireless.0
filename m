Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbcFWNOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 09:14:23 -0400
From: Colin King <colin.king@canonical.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix spelling mistake: "interupts" -> "interrupts"
Date: Thu, 23 Jun 2016 14:14:07 +0100
Message-Id: <1466687647-23151-1-git-send-email-colin.king@canonical.com> (sfid-20160623_151443_380277_873E5154)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dev_err messages

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 +-
 drivers/staging/wilc1000/wilc_spi.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a839a79..39b73fb2 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -1006,7 +1006,7 @@ static int sdio_sync_ext(struct wilc *wilc, int nint)
 	u32 reg;
 
 	if (nint > MAX_NUM_INT) {
-		dev_err(&func->dev, "Too many interupts (%d)...\n", nint);
+		dev_err(&func->dev, "Too many interrupts (%d)...\n", nint);
 		return 0;
 	}
 	if (nint > MAX_NUN_INT_THRPT_ENH2) {
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 4268e2f..22cf4b7 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1082,7 +1082,7 @@ static int wilc_spi_sync_ext(struct wilc *wilc, int nint)
 	int ret, i;
 
 	if (nint > MAX_NUM_INT) {
-		dev_err(&spi->dev, "Too many interupts (%d)...\n", nint);
+		dev_err(&spi->dev, "Too many interrupts (%d)...\n", nint);
 		return 0;
 	}
 
-- 
2.8.1

