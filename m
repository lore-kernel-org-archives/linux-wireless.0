Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33375 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbJ0LlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 07:41:08 -0400
Received: by pabla5 with SMTP id la5so27620602pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 04:41:08 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 8/8] staging: wilc1000: remove multiple blank lines
Date: Tue, 27 Oct 2015 20:40:39 +0900
Message-Id: <1445946039-10390-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151027_124112_563820_422B0444)
In-Reply-To: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
References: <1445946039-10390-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes multiple blank lines found by checkpatch.

CHECK: Please don't use multiple blank lines
FILE: drivers/staging/wilc1000/host_interface.c:3175:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 50362c4..5a23738 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3172,7 +3172,6 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
-- 
2.6.1

