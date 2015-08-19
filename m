Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36418 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbHSG7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:25 -0400
Received: by pawq9 with SMTP id q9so54082585paw.3
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:24 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/13] staging: wilc1000: wilc_msgqueue.c: remove multiple blank lines
Date: Wed, 19 Aug 2015 15:58:58 +0900
Message-Id: <1439967548-25876-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_085927_901058_F47AAB57)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes multiple blank lines.
CHECK: Please don't use multiple blank lines

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 7718c481..e7c4a9a 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -76,7 +76,6 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
 	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
 
-
 	/* add it to the message queue */
 	if (pHandle->pstrMessageList == NULL) {
 		pHandle->pstrMessageList  = pstrMessage;
@@ -107,8 +106,6 @@ WILC_ErrNo WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
 	return s32RetStatus;
 }
 
-
-
 /*!
  *  @author		syounan
  *  @date		1 Sep 2010
-- 
1.9.1

