Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34562 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbcAULdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:33:05 -0500
Received: by mail-pf0-f194.google.com with SMTP id 65so1708873pfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:33:05 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 26/27] staging: wilc1000: fix logical continuations
Date: Thu, 21 Jan 2016 20:30:56 +0900
Message-Id: <1453375857-20645-27-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123322_516044_7E7CBFDA)
In-Reply-To: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes logical continuations found by checkpatch
CHECK: Logical continuations should be on the previous line

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index c7a60f4..4493ca9 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -115,8 +115,7 @@ int wilc_mq_recv(struct message_queue *mq,
 	struct message *msg;
 	unsigned long flags;
 
-	if ((!mq) || (recv_buf_size == 0)
-	    || (!recv_buf) || (!recv_len)) {
+	if ((!mq) || (recv_buf_size == 0) || (!recv_buf) || (!recv_len)) {
 		PRINT_ER("mq or recv_buf is null\n");
 		return -EINVAL;
 	}
-- 
2.7.0

