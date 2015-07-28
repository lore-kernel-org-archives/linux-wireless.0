Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48100 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbG1Ita (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:49:30 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/21] staging: wilc1000: remove errors on required space
Date: Tue, 28 Jul 2015 17:47:32 +0900
Message-ID: <1438073261-28315-14-git-send-email-tony.cho@atmel.com> (sfid-20150728_104938_497938_4CD486D8)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the errors reported by checkpatch.pl, which is the
space required before the open parenthesis '('.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ee5578b..1621f91 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -475,7 +475,7 @@ static int sdio_sync(void)
 	/**
 	 *      Disable power sequencer
 	 **/
-	if(!sdio_read_reg(WILC_MISC, &reg)) {
+	if (!sdio_read_reg(WILC_MISC, &reg)) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed read misc reg...\n");
 		return 0;
 	}
@@ -781,7 +781,7 @@ static int sdio_clear_int_ext(uint32_t val)
 {
 	int ret;
 
-	if(g_sdio.has_thrpt_enh3) {
+	if (g_sdio.has_thrpt_enh3) {
 		uint32_t reg;
 		reg = val & ((1 << MAX_NUN_INT_THRPT_ENH2) - 1);
 
-- 
1.9.1

