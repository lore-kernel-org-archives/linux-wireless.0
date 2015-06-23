Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36416 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbbFWAS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 20:18:28 -0400
Received: by paceq1 with SMTP id eq1so119640619pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 17:18:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: wilc_wfi_netdevice.c: remove unused codes
Date: Tue, 23 Jun 2015 09:17:45 +0900
Message-Id: <1435018667-12507-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150623_021837_443381_81401171)
In-Reply-To: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1435018667-12507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove if statement that has no any codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index 478cd2b..d5facb4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -906,9 +906,6 @@ int WILC_WFI_InitModule(void)
 	priv[0] = netdev_priv(WILC_WFI_devs[0]);
 	priv[1] = netdev_priv(WILC_WFI_devs[1]);
 
-	if (priv[1]->dev->ieee80211_ptr->wiphy->interface_modes && BIT(NL80211_IFTYPE_MONITOR))	{
-
-	}
 	priv[0]->bCfgScanning = false;
 	priv[0]->u32RcvdChCount = 0;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
