Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8299 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbbJSJ0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 05:26:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 3/6] staging: wilc1000: move variable FALSE_FRMWR_CHANNEL
Date: Mon, 19 Oct 2015 18:26:10 +0900
Message-ID: <1445246773-22253-4-git-send-email-tony.cho@atmel.com> (sfid-20151019_112650_915796_C4A16AFA)
In-Reply-To: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
References: <1445246773-22253-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch moves the variable 'FALSE_FRMWR_CHANNEL' to where local definitions
are.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c61042e..948b986 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -60,6 +60,7 @@ extern u8 g_wilc_initialized;
 #define BA_SESSION_DEFAULT_BUFFER_SIZE          16
 #define BA_SESSION_DEFAULT_TIMEOUT              1000
 #define BLOCK_ACK_REQ_SIZE                      0x14
+#define FALSE_FRMWR_CHANNEL			100
 
 struct cfg_param_attr {
 	struct cfg_param_val cfg_attr_info;
@@ -2623,7 +2624,6 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	return result;
 }
 
-#define FALSE_FRMWR_CHANNEL 100
 static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
-- 
1.9.1

