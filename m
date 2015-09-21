Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34429 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:59:12 -0400
Received: by padhy16 with SMTP id hy16so116247613pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:59:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/16] staging: wilc1000: host_int_init: remove commented code
Date: Mon, 21 Sep 2015 21:58:23 +0900
Message-Id: <1442840306-9657-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145916_234020_B8EBD025)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes commented code in host_int_init function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 43062c5..ce7bb0f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6431,7 +6431,6 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	down(&(pstrWFIDrv->gtOsCfgValuesSem));
 
 	pstrWFIDrv->enuHostIFstate = HOST_IF_IDLE;
-	/* gWFiDrvHandle->bPendingConnRequest = false; */
 
 	/*Initialize CFG WIDS Defualt Values*/
 
-- 
2.5.1

