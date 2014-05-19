Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41013 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbaESTe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:29 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4788496wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/20] staging: vt6656: clean up BBvSetAntennaMode.
Date: Mon, 19 May 2014 20:33:03 +0100
Message-Id: <1400527992-3061-11-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213444_121748_F8FEB6EC)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

white space clean up.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 0bdc814..5e2ffab 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -869,25 +869,21 @@ void BBvCalculateParameter(struct vnt_private *priv, u32 frame_length,
  */
 void BBvSetAntennaMode(struct vnt_private *pDevice, u8 byAntennaMode)
 {
-    switch (byAntennaMode) {
-        case ANT_TXA:
-        case ANT_TXB:
-            break;
-        case ANT_RXA:
-            pDevice->byBBRxConf &= 0xFC;
-            break;
-        case ANT_RXB:
-            pDevice->byBBRxConf &= 0xFE;
-            pDevice->byBBRxConf |= 0x02;
-            break;
-    }
+	switch (byAntennaMode) {
+	case ANT_TXA:
+	case ANT_TXB:
+		break;
+	case ANT_RXA:
+		pDevice->byBBRxConf &= 0xFC;
+		break;
+	case ANT_RXB:
+		pDevice->byBBRxConf &= 0xFE;
+		pDevice->byBBRxConf |= 0x02;
+		break;
+	}
 
-    CONTROLnsRequestOut(pDevice,
-                    MESSAGE_TYPE_SET_ANTMD,
-                    (u16) byAntennaMode,
-                    0,
-                    0,
-                    NULL);
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_SET_ANTMD,
+		(u16)byAntennaMode, 0, 0, NULL);
 }
 
 /*
-- 
1.9.1

