Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36445 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbbFWASb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 20:18:31 -0400
Received: by paceq1 with SMTP id eq1so119641283pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 17:18:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/4] staging: wilc1000: wilc_wfi_netdevice.c: remove unused variable
Date: Tue, 23 Jun 2015 09:17:46 +0900
Message-Id: <1435018667-12507-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150623_021838_054668_7251A057)
In-Reply-To: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove variable that is defined but never used.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index d5facb4..c2e92c0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -873,7 +873,6 @@ int WILC_WFI_InitModule(void)
 	int result, i, ret = -ENOMEM;
 	struct WILC_WFI_priv *priv[2], *netpriv;
 	struct wireless_dev *wdev;
-	char buf[IFNAMSIZ];
 
 	WILC_WFI_Interrupt = use_napi ? WILC_WFI_NapiInterrupt : WILC_WFI_RegularInterrupt;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
