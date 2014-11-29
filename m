Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61039 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaK2ACk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 19:02:40 -0500
Received: by mail-wg0-f41.google.com with SMTP id y19so9910801wgg.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 16:02:39 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: remove unused typedef struct tagSSromReg
Date: Sat, 29 Nov 2014 00:02:00 +0000
Message-Id: <1417219323-3988-3-git-send-email-tvboxspy@gmail.com> (sfid-20141129_010245_702651_56F5CA00)
In-Reply-To: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
References: <1417219323-3988-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/srom.h | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/staging/vt6655/srom.h b/drivers/staging/vt6655/srom.h
index cab638b..7d3e3ef 100644
--- a/drivers/staging/vt6655/srom.h
+++ b/drivers/staging/vt6655/srom.h
@@ -89,40 +89,6 @@
 
 /*---------------------  Export Types  ------------------------------*/
 
-// AT24C02 eeprom contents
-//      2048 bits = 256 bytes = 128 words
-//
-typedef struct tagSSromReg {
-	unsigned char abyPAR[6];                  // 0x00 (unsigned short)
-
-	unsigned short wSUB_VID;                   // 0x03 (unsigned short)
-	unsigned short wSUB_SID;
-
-	unsigned char byBCFG0;                    // 0x05 (unsigned short)
-	unsigned char byBCFG1;
-
-	unsigned char byFCR0;                     // 0x06 (unsigned short)
-	unsigned char byFCR1;
-	unsigned char byPMC0;                     // 0x07 (unsigned short)
-	unsigned char byPMC1;
-	unsigned char byMAXLAT;                   // 0x08 (unsigned short)
-	unsigned char byMINGNT;
-	unsigned char byCFG0;                     // 0x09 (unsigned short)
-	unsigned char byCFG1;
-	unsigned short wCISPTR;                    // 0x0A (unsigned short)
-	unsigned short wRsv0;                      // 0x0B (unsigned short)
-	unsigned short wRsv1;                      // 0x0C (unsigned short)
-	unsigned char byBBPAIR;                   // 0x0D (unsigned short)
-	unsigned char byRFTYPE;
-	unsigned char byMinChannel;               // 0x0E (unsigned short)
-	unsigned char byMaxChannel;
-	unsigned char bySignature;                // 0x0F (unsigned short)
-	unsigned char byCheckSum;
-
-	unsigned char abyReserved0[96];           // 0x10 (unsigned short)
-	unsigned char abyCIS[128];                // 0x80 (unsigned short)
-} SSromReg, *PSSromReg;
-
 /*---------------------  Export Macros ------------------------------*/
 
 /*---------------------  Export Classes  ----------------------------*/
-- 
2.1.0

