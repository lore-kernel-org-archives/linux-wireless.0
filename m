Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36568 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbFVNxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 09:53:16 -0400
From: Sunil Shahu <shshahu@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: host_interface: add spaces around '='
Date: Mon, 22 Jun 2015 19:23:01 +0530
Message-Id: <1434981181-9822-1-git-send-email-shshahu@gmail.com> (sfid-20150622_155321_622753_17997BD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix coding style error by placing spaces around '=' as suggested by
checkpatch.pl script.

Signed-off-by: Sunil Shahu <shshahu@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
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
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
