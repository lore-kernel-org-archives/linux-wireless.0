Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6564 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbJOE3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:29:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 37/40] staging: wilc1000: move variable FALSE_FRMWR_CHANNEL
Date: Thu, 15 Oct 2015 13:25:18 +0900
Message-ID: <1444883121-31757-37-git-send-email-tony.cho@atmel.com> (sfid-20151015_062946_806313_9A67AA98)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch move variable 'FALSE_FRMWR_CHANNEL' to local define position.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ce8cfef..2d771f5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -60,6 +60,7 @@ extern u8 g_wilc_initialized;
 #define BA_SESSION_DEFAULT_BUFFER_SIZE          16
 #define BA_SESSION_DEFAULT_TIMEOUT              1000
 #define BLOCK_ACK_REQ_SIZE                      0x14
+#define FALSE_FRMWR_CHANNEL			100
 
 struct cfg_param_attr {
 	struct cfg_param_val cfg_attr_info;
@@ -2655,7 +2656,6 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	return result;
 }
 
-#define FALSE_FRMWR_CHANNEL 100
 static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
-- 
1.9.1

