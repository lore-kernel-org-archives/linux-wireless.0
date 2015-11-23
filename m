Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35466 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbbKWNlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 08:41:03 -0500
Received: by pacej9 with SMTP id ej9so191560082pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2015 05:41:01 -0800 (PST)
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rdunlap@infradead.org, chris.park@atmel.com, austin.shin@atmel.com,
	johnny.kim@atmel.com, linux-wireless@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: Fix typo in wilc_msgqueue.h
Date: Mon, 23 Nov 2015 22:41:17 +0900
Message-Id: <1448286080-14787-1-git-send-email-standby24x7@gmail.com> (sfid-20151123_144112_024889_AC2B716F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix some spelling typo in wilc_msgqueue.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index d231c33..d7e0328 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -35,7 +35,7 @@ typedef struct __MessageQueue_struct {
  *                              any other message queue having the same name in the system
  *  @param[in,out]	pHandle handle to the message queue object
  *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating sucess/failure
+ *  @return		Error code indicating success/failure
  *  @author		syounan
  *  @date		30 Aug 2010
  *  @version		1.0
@@ -44,7 +44,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle);
 
 /*!
  *  @brief		Sends a message
- *  @details		Sends a message, this API will block unil the message is
+ *  @details		Sends a message, this API will block until the message is
  *                              actually sent or until it is timedout (as long as the feature
  *                              CONFIG_WILC_MSG_QUEUE_TIMEOUT is enabled and pstrAttrs->u32Timeout
  *                              is not set to WILC_OS_INFINITY), zero timeout is a valid value
@@ -52,7 +52,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle);
  *  @param[in]	pvSendBuffer pointer to the data to send
  *  @param[in]	u32SendBufferSize the size of the data to send
  *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating sucess/failure
+ *  @return		Error code indicating success/failure
  *  @author		syounan
  *  @date		30 Aug 2010
  *  @version		1.0
@@ -62,7 +62,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 /*!
  *  @brief		Receives a message
- *  @details		Receives a message, this API will block unil a message is
+ *  @details		Receives a message, this API will block until a message is
  *                              received or until it is timedout (as long as the feature
  *                              CONFIG_WILC_MSG_QUEUE_TIMEOUT is enabled and pstrAttrs->u32Timeout
  *                              is not set to WILC_OS_INFINITY), zero timeout is a valid value
@@ -71,7 +71,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
  *  @param[in]	u32RecvBufferSize the size of the receive buffer
  *  @param[out]	pu32ReceivedLength the length of received data
  *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating sucess/failure
+ *  @return		Error code indicating success/failure
  *  @author		syounan
  *  @date		30 Aug 2010
  *  @version		1.0
@@ -84,7 +84,7 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
  *  @brief		Destroys an existing  Message queue
  *  @param[in]	pHandle handle to the message queue object
  *  @param[in]	pstrAttrs Optional attributes, NULL for default
- *  @return		Error code indicating sucess/failure
+ *  @return		Error code indicating success/failure
  *  @author		syounan
  *  @date		30 Aug 2010
  *  @version		1.0
-- 
2.6.3.379.g0c83680

