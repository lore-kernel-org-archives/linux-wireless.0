Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53060 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaEQIxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:18 -0400
Received: by mail-wi0-f174.google.com with SMTP id r20so2004616wiv.7
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/22] staging: vt6656: vnt_private remove dead variables.
Date: Sat, 17 May 2014 09:50:36 +0100
Message-Id: <1400316639-4430-19-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112149_185335_66EC92E5)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dwAotoRateTxOkCnt
dwAotoRateTxFailCnt
dwErrorRateThreshold
dwTPTable

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 73bce9e..f3072dd 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -538,10 +538,6 @@ struct vnt_private {
 	u8 byTopOFDMBasicRate;
 	u8 byTopCCKBasicRate;
 
-	u32 dwAotoRateTxOkCnt;
-	u32 dwAotoRateTxFailCnt;
-	u32 dwErrorRateThreshold[13];
-	u32 dwTPTable[MAX_RATE];
 	u8 abyEEPROM[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
 
 	u8 byMinChannel;
-- 
1.9.1

