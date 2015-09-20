Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35352 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbbITGvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:52 -0400
Received: by pacfv12 with SMTP id fv12so89097414pac.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:51 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/18] staging: wilc1000: remove blank line before a close brace '{'
Date: Sun, 20 Sep 2015 15:51:12 +0900
Message-Id: <1442731885-4344-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085211_363053_AC79B1F0)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line before a close brace '{' found by checkpatch.pl
CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8107420..fbe8643 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3713,5 +3713,4 @@ void wilc_free_wiphy(struct net_device *net)
 	PRINT_D(INIT_DBG, "Freeing wiphy\n");
 	wiphy_free(net->ieee80211_ptr->wiphy);
 	kfree(net->ieee80211_ptr);
-
 }
-- 
2.5.1

