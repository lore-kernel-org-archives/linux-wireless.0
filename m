Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35275 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbFVEId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 00:08:33 -0400
Received: by pacyo7 with SMTP id yo7so21834626pac.2
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 21:08:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: wilc_wfi_netdevice.c: remove prohibited space
Date: Mon, 22 Jun 2015 13:08:12 +0900
Message-Id: <1434946095-26157-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150622_060848_927064_1C0FE8F0)
In-Reply-To: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
References: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning found by checkpatch.pl
WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index 01542f4..9da7674 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -71,7 +71,7 @@ void WILC_WFI_SetupPool(struct net_device *dev)
 
 	priv->ppool = NULL;
 	for (i = 0; i < pool_size; i++) {
-		pkt = kmalloc (sizeof (struct WILC_WFI_packet), GFP_KERNEL);
+		pkt = kmalloc(sizeof(struct WILC_WFI_packet), GFP_KERNEL);
 		if (pkt == NULL) {
 			PRINT_D(RX_DBG, "Ran out of memory allocating packet pool\n");
 			return;
@@ -99,7 +99,7 @@ void WILC_WFI_TearDownPool(struct net_device *dev)
 
 	while ((pkt = priv->ppool)) {
 		priv->ppool = pkt->next;
-		kfree (pkt);
+		kfree(pkt);
 		/* FIXME - in-flight packets ? */
 	}
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
