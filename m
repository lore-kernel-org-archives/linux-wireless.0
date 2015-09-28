Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:32950 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbbI1SOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 14:14:31 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 2/2] drivers: staging: wilc1000: wilc_msgqueue.c: Remove code that no effect
Date: Mon, 28 Sep 2015 23:43:56 +0530
Message-Id: <1443464037-3591-2-git-send-email-csgorentla@gmail.com> (sfid-20150928_201509_433801_220887D3)
In-Reply-To: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index a01ada4..1a411d3 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -133,11 +133,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
 	down(&pHandle->hSem);
 
 	/* other non-timeout scenarios */
-	if (result) {
-		PRINT_ER("Non-timeout\n");
-		return result;
-	}
-
 	if (pHandle->bExiting) {
 		PRINT_ER("pHandle fail\n");
 		return -EFAULT;
-- 
2.1.4

