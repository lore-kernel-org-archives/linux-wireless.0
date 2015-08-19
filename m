Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32792 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbHSG72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:28 -0400
Received: by pabyb7 with SMTP id yb7so150982694pab.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/13] staging: wilc1000: wilc_msgqueue.c: remove blank line before a close brace
Date: Wed, 19 Aug 2015 15:58:59 +0900
Message-Id: <1439967548-25876-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085930_711404_F07A106F)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line before a close brace "}"
CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index e7c4a9a..8cb74d1 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -173,7 +173,6 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 		kfree(pstrMessage);
 
 		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
-
 	}
 
 	WILC_CATCH(s32RetStatus)
-- 
1.9.1

