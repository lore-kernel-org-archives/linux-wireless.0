Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35006 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbHSG7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:22 -0400
Received: by pacgr6 with SMTP id gr6so150830870pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:22 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/13] staging: wilc1000: wilc_msgqueue.c: remove blank line after open brace
Date: Wed, 19 Aug 2015 15:58:57 +0900
Message-Id: <1439967548-25876-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085925_697156_30E0C1E1)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a blank line for open brace "{"
CHECK: Blank lines aren't necessary after an open brace '{'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index fcf3a29..7718c481 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -26,7 +26,6 @@ WILC_ErrNo WILC_MsgQueueCreate(WILC_MsgQueueHandle *pHandle)
  */
 WILC_ErrNo WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
 {
-
 	pHandle->bExiting = true;
 
 	/* Release any waiting receiver thread. */
@@ -120,7 +119,6 @@ WILC_ErrNo WILC_MsgQueueRecv(WILC_MsgQueueHandle *pHandle,
 			     void *pvRecvBuffer, u32 u32RecvBufferSize,
 			     u32 *pu32ReceivedLength)
 {
-
 	Message *pstrMessage;
 	WILC_ErrNo s32RetStatus = WILC_SUCCESS;
 	unsigned long flags;
-- 
1.9.1

