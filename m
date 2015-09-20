Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36586 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbITGwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:23 -0400
Received: by padhk3 with SMTP id hk3so87325987pad.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:22 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/18] staging: wilc1000: remove braces for single statement blocks
Date: Sun, 20 Sep 2015 15:51:22 +0900
Message-Id: <1442731885-4344-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091653_819030_1EB57F0F)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes braces for single if statement blocks found by
checkpatch.pl
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 34df5da..fce7dac 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3626,9 +3626,9 @@ int WILC_WFI_InitHostInt(struct net_device *net)
 
 	sema_init(&(priv->hSemScanReq), 1);
 	s32Error = host_int_init(&priv->hWILCWFIDrv);
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Error while initializing hostinterface\n");
-	}
+
 	return s32Error;
 }
 
@@ -3666,9 +3666,9 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
 	}
 	#endif
 
-	if (s32Error) {
+	if (s32Error)
 		PRINT_ER("Error while deintializing host interface\n");
-	}
+
 	return s32Error;
 }
 
-- 
2.5.1

