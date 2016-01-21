Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35722 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbcAUBV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 20:21:58 -0500
Received: by mail-pa0-f66.google.com with SMTP id gi1so1023052pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 17:21:58 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 26/27] staging: wilc1000: fix logical continuations
Date: Thu, 21 Jan 2016 10:20:29 +0900
Message-Id: <1453339230-1377-26-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_023656_753946_E4EA09C0)
In-Reply-To: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
References: <1453339230-1377-1-git-send-email-chaehyun.lim@gmail.com>
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
2.6.4

