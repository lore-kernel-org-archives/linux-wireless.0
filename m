Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6070 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbbJOE0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:26:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/40] staging: wilc1000: remove unused variable gWFiDrvHandle
Date: Thu, 15 Oct 2015 13:24:51 +0900
Message-ID: <1444883121-31757-10-git-send-email-tony.cho@atmel.com> (sfid-20151015_062642_829051_2CEAF65D)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused the variable gWFiDrvHandle.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 320073e..ad7c102 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -237,7 +237,6 @@ enum scan_conn_timer {
 
 static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
-struct host_if_drv *gWFiDrvHandle;
 bool g_obtainingIP;
 u8 P2P_LISTEN_STATE;
 static struct task_struct *HostIFthreadHandler;
-- 
1.9.1

