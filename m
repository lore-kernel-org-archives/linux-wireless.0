Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33937 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbIPSlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 14:41:21 -0400
From: Aparna Karuthodi <kdasaparna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com,
	Aparna Karuthodi <kdasaparna@gmail.com>
Subject: [PATCH] staging: wilc1000: Added spaces
Date: Thu, 17 Sep 2015 00:12:50 +0530
Message-Id: <1442428970-9091-1-git-send-email-kdasaparna@gmail.com> (sfid-20150916_204137_780246_12321739)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added spaces around '=' to remove coding style errors detected by
checkpatch.The errors are given below:
drivers/staging/wilc1000/host_interface.c:7951: ERROR: spaces required
around that '=' (ctx:VxV)
drivers/staging/wilc1000/host_interface.c:7952: ERROR: spaces required
around that '=' (ctx:VxW)

Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6b10bbb..d1fe73d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -7945,8 +7945,8 @@ s32 host_int_get_ipaddress(WILC_WFIDrvHandle hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
 
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
-	strHostIFmsg.drvHandler=hWFIDrv;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx= idx;
+	strHostIFmsg.drvHandler = hWFIDrv;
+	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
 	if (s32Error) {
-- 
1.7.9.5

