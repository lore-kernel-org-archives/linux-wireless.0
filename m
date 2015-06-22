Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36545 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbbFVEIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 00:08:30 -0400
Received: by paceq1 with SMTP id eq1so100527804pac.3
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 21:08:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: wilc_wfi_netdevice.c: remove prohibited space before semicolon
Date: Mon, 22 Jun 2015 13:08:11 +0900
Message-Id: <1434946095-26157-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150622_060848_353728_B66E3A22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning found by checkpatch.pl
WARNING: space prohibited before semicolon

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.c b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
index ab66ce4..01542f4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.c
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.c
@@ -31,7 +31,7 @@ module_param(timeout, int, 0);
 /*
  * Do we run in NAPI mode?
  */
-static int use_napi ;
+static int use_napi;
 module_param(use_napi, int, 0);
 
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
