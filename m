Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33141 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbJEKfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:36 -0400
Received: by pacex6 with SMTP id ex6so173827784pac.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/20] staging: wilc1000: delete multiple blank lines
Date: Mon,  5 Oct 2015 19:34:53 +0900
Message-Id: <1444041304-7727-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123538_910125_EE3C4B0F)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch deletes multiple blank lines found by checkpatch

CHECK: Please don't use multiple blank lines
FILE: drivers/staging/wilc1000/host_interface.c:5393:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 998c644..edd8b81 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5390,7 +5390,6 @@ int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 mode)
 
 	struct host_if_msg msg;
 
-
 	/* prepare the set driver handler message */
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-- 
2.6.0

