Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58025 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbbG3JKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 05:10:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 2/5] staging: wilc1000: remove unnecessary blank lines
Date: Thu, 30 Jul 2015 18:10:11 +0900
Message-ID: <1438247414-19708-3-git-send-email-tony.cho@atmel.com> (sfid-20150730_111050_441871_06A327FD)
In-Reply-To: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the following warnings reported by checkpatch.pl.
- Blank lines aren't necessary after an open brace '{'
- Blank lines aren't necessary before a close brace '}'

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2: This patch doesn't have a difference with the first one but resent
because it's rejected with the 9th patch.
---
 drivers/staging/wilc1000/wilc_sdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 50be2a1..42c5ad8 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -679,7 +679,6 @@ static void sdio_set_default_speed(void)
 
 static int sdio_read_size(uint32_t *size)
 {
-
 	uint32_t tmp;
 	sdio_cmd52_t cmd;
 
@@ -806,7 +805,6 @@ static int sdio_clear_int_ext(uint32_t val)
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 				goto _fail_;
 			}
-
 		}
 	} else {
 		/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
@@ -910,7 +908,6 @@ static int sdio_clear_int_ext(uint32_t val)
 				g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0xf8 data (%d) ...\n", __LINE__);
 				goto _fail_;
 			}
-
 		}
 	} else {
 		uint32_t vmm_ctl;
-- 
1.9.1

