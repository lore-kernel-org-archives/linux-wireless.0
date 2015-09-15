Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35744 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbbIONwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 09:52:03 -0400
From: Aparna Karuthodi <kdasaparna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, Aparna Karuthodi <kdasaparna@gmail.com>
Subject: [PATCH] staging: wilc1000: Removed curly braces
Date: Tue, 15 Sep 2015 19:24:00 +0530
Message-Id: <1442325240-3659-1-git-send-email-kdasaparna@gmail.com> (sfid-20150915_155226_591127_4BB459B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed the curly braces of a single statement if block to remove a
coding style warning detected by checkpatch.
The warning is given below:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Aparna Karuthodi <kdasaparna@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 0c964c6..5241699 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1944,9 +1944,8 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 	gstrConfigPktInfo.bRespRequired = bRespRequired;
 
 	s32Error = SendRawPacket(gps8ConfigPacket, s32ConfigPacketLen);
-	if (s32Error != WILC_SUCCESS) {
+	if (s32Error != WILC_SUCCESS)
 		goto End_ConfigPkt;
-	}
 
 	WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
 
-- 
1.7.9.5

