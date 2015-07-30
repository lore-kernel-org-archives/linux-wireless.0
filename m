Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58046 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbbG3JKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 05:10:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 3/5] staging: wilc1000: remove warnings on missing blank line
Date: Thu, 30 Jul 2015 18:10:12 +0900
Message-ID: <1438247414-19708-4-git-send-email-tony.cho@atmel.com> (sfid-20150730_111057_314916_9E601DEE)
In-Reply-To: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl on missing
a blank line after declarations.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2: This patch doesn't have a difference with the first one. However,
it's resent becasue not accepted with the 9th patch.
---
 drivers/staging/wilc1000/wilc_sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ee1cbd1..50be2a1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -780,6 +780,7 @@ static int sdio_clear_int_ext(uint32_t val)
 
 	if (g_sdio.has_thrpt_enh3) {
 		uint32_t reg;
+
 		reg = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
 
 		/* select VMM table 0 */
-- 
1.9.1

