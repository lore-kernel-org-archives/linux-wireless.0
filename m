Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34566 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbFVEIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 00:08:36 -0400
Received: by pabvl15 with SMTP id vl15so78923420pab.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 21:08:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: wilc_wfi_netdevice.c: remove braces for single statement block
Date: Mon, 22 Jun 2015 13:08:13 +0900
Message-Id: <1434946095-26157-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150622_060849_491218_01CEBBDF)
In-Reply-To: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
References: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning found by checkpatch.pl
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index 9da7674..039e21f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -931,10 +931,8 @@ int WILC_WFI_InitModule(void)
 	/* ret = host_int_init(&priv[0]->hWILCWFIDrv); */
 	/*copy handle to the other driver*/
 	/* priv[1]->hWILCWFIDrv = priv[0]->hWILCWFIDrv; */
-	if (ret) {
+	if (ret)
 		PRINT_ER("Error Init Driver\n");
-	}
-
 
 out:
 	if (ret)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
