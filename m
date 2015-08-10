Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35824 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbbHJCdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:33:32 -0400
Received: by pdrg1 with SMTP id g1so65850022pdr.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:33:31 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/11] staging: wilc1000: remove commented code
Date: Mon, 10 Aug 2015 11:33:12 +0900
Message-Id: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043347_405463_63FF4356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove commented code that is not used.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 -
 drivers/staging/wilc1000/host_interface.c   | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 72ff7d4..a88b796 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1332,7 +1332,6 @@ void ProcessStrWid(char *pcPacket, s32 *ps32PktLen,
 
 	if (g_oper_mode == SET_CFG) {
 		/* Message Length */
-		/* u16MsgLen = WILC_strlen(pu8val); */
 		u16MsgLen = (u16)s32ValueSize;
 
 		/* Length */
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cc549c2..31790a3d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5159,9 +5159,7 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(WILC_WFIDrvHandle hWFIDrv, u8 *pu8PassP
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID strWID;
-	/* tstrWILC_WFIDrv * pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv; */
 
-	/* u8 u8Psklength = WILC_strlen(pu8PassPhrase); */
 	/*validating psk length*/
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
 		strWID.u16WIDid	= (u16)WID_11I_PSK;
-- 
1.9.1

