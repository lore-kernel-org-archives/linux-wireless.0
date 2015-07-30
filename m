Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58065 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbbG3JLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 05:11:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 4/5] staging: wilc1000: remove errors on required space
Date: Thu, 30 Jul 2015 18:10:13 +0900
Message-ID: <1438247414-19708-5-git-send-email-tony.cho@atmel.com> (sfid-20150730_111106_642951_775A5B3D)
In-Reply-To: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
References: <1438247414-19708-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the errors reported by checkpatch.pl, which is the
space required before the open parenthesis '('.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2: This patch is not different with the first one. This patch includes
warnings on no space required before the open parenthesis in the
function, sdio_clear_int_ext. The 9th patch fixed the same problem in
the function,  not sdio_clear_int_ext but sdio_sync.
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 44421d0..ee1cbd1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -778,7 +778,7 @@ static int sdio_clear_int_ext(uint32_t val)
 {
 	int ret;
 
-	if(g_sdio.has_thrpt_enh3) {
+	if (g_sdio.has_thrpt_enh3) {
 		uint32_t reg;
 		reg = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
 
-- 
1.9.1

