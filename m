Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34829 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbJBMph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:37 -0400
Received: by pacfv12 with SMTP id fv12so108316842pac.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:37 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/10] staging: wilc1000: remove blank lines before close brace
Date: Fri,  2 Oct 2015 21:44:56 +0900
Message-Id: <1443789896-7082-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144540_789890_D8BCBFCF)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank lines before close brace '}'

CHECK: Blank lines aren't necessary before a close brace '}'
drivers/staging/wilc1000/host_interface.c:5366:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 79014ab..e9b58c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5362,7 +5362,6 @@ int host_int_wait_msg_queue_idle(void)
 	down(&hWaitResponse);
 
 	return result;
-
 }
 
 s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
-- 
2.6.0

