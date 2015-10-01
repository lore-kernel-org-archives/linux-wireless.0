Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33082 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbbJANoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:24 -0400
Received: by pacex6 with SMTP id ex6so75448073pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:23 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/12] staging: wilc1000: remove #if 1 and #endif
Date: Thu,  1 Oct 2015 22:43:52 +0900
Message-Id: <1443707039-18433-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154427_155745_7EC3C7D5)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes #if 1 and #endif, which is encapsulated
some codes.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 755a817..d781003 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3415,7 +3415,6 @@ int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 	struct wilc_priv *priv;
 
 	priv = wiphy_priv(wiphy);
-#if 1
 	switch (changed) {
 
 	case WILC_WFI_RX_PKT:
@@ -3438,7 +3437,6 @@ int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 	default:
 		break;
 	}
-#endif
 	return 0;
 }
 
-- 
2.6.0

