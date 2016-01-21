Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34975 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865AbcAULbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 06:31:45 -0500
Received: by mail-pf0-f195.google.com with SMTP id 65so1704127pff.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 03:31:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 00/27] rename variables in wilc1000 driver
Date: Thu, 21 Jan 2016 20:30:30 +0900
Message-Id: <1453375857-20645-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160121_123148_793558_C24A0D42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

V2:
A 18/27 patch of series has a wrong name as tail_msg, which is should be
changed to pstrTailMsg. I fixed it in V2.

Chaehyun Lim (27):
  staging: wilc1000: rename struct __Message_struct
  staging: wilc1000: rename pvBuffer in struct message
  staging: wilc1000: rename u32Length in struct message
  staging: wilc1000: rename pstrNext in struct message
  staging: wilc1000: rename struct WILC_MsgQueueHandle
  staging: wilc1000: rename hSem in struct message_queue
  staging: wilc1000: rename strCriticalSection in struct message_queue
  staging: wilc1000: rename bExiting in struct message_queue
  staging: wilc1000: rename u32ReceiversCount in struct message_queue
  staging: wilc1000: rename pstrMessageList in struct message_queue
  staging: wilc1000: rename pHandle in wilc_mq_create
  staging: wilc1000: rename pHandle in wilc_mq_destroy
  staging: wilc1000: rename pstrMessge in wilc_mq_destroy
  staging: wilc1000: rename pHandle in wilc_mq_send
  staging: wilc1000: rename pvSendBuffer in wilc_mq_send
  staging: wilc1000: rename u32SendBufferSize in wilc_mq_send
  staging: wilc1000: rename pstrMessage in wilc_mq_send
  staging: wilc1000: rename pstrTailMsg in wilc_mq_send
  staging: wilc1000: fix return error code
  staging: wilc1000: rename pHandle in wilc_mq_recv
  staging: wilc1000: rename pvRecvBuffer in wilc_mq_recv
  staging: wilc1000: rename u32RecvBufferSize in wilc_mq_recv
  staging: wilc1000: rename pu32ReceivedLength in wilc_mq_recv
  staging: wilc1000: rename pstrMessage in wilc_mq_recv
  staging: wilc1000: fix coding style of kmalloc usage
  staging: wilc1000: fix logical continuations
  staging: wilc1000: remove over-commenting

 drivers/staging/wilc1000/host_interface.c |   2 +-
 drivers/staging/wilc1000/wilc_msgqueue.c  | 135 +++++++++++++++---------------
 drivers/staging/wilc1000/wilc_msgqueue.h  | 107 +++++------------------
 3 files changed, 87 insertions(+), 157 deletions(-)

-- 
2.7.0

