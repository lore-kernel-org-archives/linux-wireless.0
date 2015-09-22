Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35546 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbbIVJfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:44 -0400
Received: by pacfv12 with SMTP id fv12so4731811pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:43 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 13/16] staging: wilc1000: host_int_init: remove commented code
Date: Tue, 22 Sep 2015 18:34:58 +0900
Message-Id: <1442914501-2315-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_114654_187941_2240BF8B)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes commented code in host_int_init function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

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

