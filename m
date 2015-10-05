Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35686 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbJEKfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:14 -0400
Received: by pacfv12 with SMTP id fv12so177126788pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/20] staging: wilc1000: remove multiple blank lines
Date: Mon,  5 Oct 2015 19:34:46 +0900
Message-Id: <1444041304-7727-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123523_417432_9BA73944)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes multiple blank lines found by checkpatch

CHECK: Please don't use multiple blank lines
FILE: drivers/staging/wilc1000/host_interface.c:5343:
FILE: drivers/staging/wilc1000/host_interface.c:5372:
FILE: drivers/staging/wilc1000/host_interface.c:5389:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 038923d..f8206a2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5340,7 +5340,6 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 	return 0;
 }
 
-
 int host_int_wait_msg_queue_idle(void)
 {
 	int result = 0;
@@ -5369,7 +5368,6 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 	struct host_if_msg msg;
 
-
 	/* prepare the set driver handler message */
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
@@ -5386,8 +5384,6 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	return s32Error;
 }
 
-
-
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = 0;
-- 
2.6.0

