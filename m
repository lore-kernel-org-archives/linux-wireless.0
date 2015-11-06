Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37233 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 45/73] staging: wilc1000: fixes braces {} should be used on all arms of this statement
Date: Fri, 6 Nov 2015 11:13:06 +0900
Message-ID: <1446776014-28094-45-git-send-email-glen.lee@atmel.com> (sfid-20151106_033806_117357_0801D083)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the error reported by checkpatch.pl
for braces {} should be used on all arms of this statement

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 458eef2b..3b097c1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1104,9 +1104,9 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		if (LINUX_RX_SIZE - offset < size)
 			offset = 0;
 
-		if (p->rx_buffer)
+		if (p->rx_buffer) {
 			buffer = &p->rx_buffer[offset];
-		else {
+		} else {
 			wilc_debug(N_ERR, "[wilc isr]: fail Rx Buffer is NULL...drop the packets (%d)\n", size);
 			goto _end_;
 		}
-- 
1.9.1

