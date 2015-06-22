Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36212 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbbFVEIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 00:08:42 -0400
Received: by pdcu2 with SMTP id u2so3524567pdc.3
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 21:08:41 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: wilc_wfi_netdevice.c: move statement after declarations
Date: Mon, 22 Jun 2015 13:08:15 +0900
Message-Id: <1434946095-26157-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150622_060850_637316_BC93BAE8)
In-Reply-To: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
References: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning found by checkpatch.pl
WARNING: Missing a blank line after declarations

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index 31a796b..170ca65 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -886,9 +886,10 @@ int WILC_WFI_InitModule(void)
 	int result, i, ret = -ENOMEM;
 	struct WILC_WFI_priv *priv[2], *netpriv;
 	struct wireless_dev *wdev;
-	WILC_WFI_Interrupt = use_napi ? WILC_WFI_NapiInterrupt : WILC_WFI_RegularInterrupt;
 	char buf[IFNAMSIZ];
 
+	WILC_WFI_Interrupt = use_napi ? WILC_WFI_NapiInterrupt : WILC_WFI_RegularInterrupt;
+
 	for (i = 0; i < 2; i++)	{
 
 		/* Allocate the net devices */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
