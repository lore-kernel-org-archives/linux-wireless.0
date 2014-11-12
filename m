Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54636 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaKLVMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:12:03 -0500
Received: by mail-wg0-f53.google.com with SMTP id b13so15247021wgh.40
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:12:01 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6655: rf.c Removed unneeded comments
Date: Wed, 12 Nov 2014 21:11:14 +0000
Message-Id: <1415826675-8446-7-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221209_421715_7329F095)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Type and function that are not present comments

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 134 --------------------------------------------
 1 file changed, 134 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 87d97da..0b16ebf 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -39,8 +39,6 @@
 #include "rf.h"
 #include "baseband.h"
 
-/*---------------------  Static Definitions -------------------------*/
-
 #define BY_AL2230_REG_LEN     23 //24bit
 #define CB_AL2230_INIT_SEQ    15
 #define SWITCH_CHANNEL_DELAY_AL2230 200 //us
@@ -51,10 +49,6 @@
 #define SWITCH_CHANNEL_DELAY_AL7230 200 //us
 #define AL7230_PWR_IDX_LEN    64
 
-/*---------------------  Static Classes  ----------------------------*/
-
-/*---------------------  Static Variables  --------------------------*/
-
 static const unsigned long dwAL2230InitTable[CB_AL2230_INIT_SEQ] = {
 	0x03F79000+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW, //
 	0x03333100+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW, //
@@ -410,8 +404,6 @@ static const unsigned long dwAL7230ChannelTable2[CB_MAX_CHANNEL] = {
 	0x77D78400+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW  // channel = 165, Tf = 5825MHz (56)
 };
 
-/*---------------------  Static Functions  --------------------------*/
-
 /*
  * Description: AIROHA IFRF chip init function
  *
@@ -498,64 +490,6 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
 }
 
 /*
- * Description: Select channel with UW2452 chip
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      uChannel    - Channel number
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
- * Description: UW2452 IFRF chip init function
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
- * Description: VT3226 IFRF chip init function
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
- * Description: Select channel with VT3226 chip
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      uChannel    - Channel number
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
-/*
  * Description: Write to IF/RF, by embedded programming
  *
  * Parameters:
@@ -590,33 +524,6 @@ bool IFRFbWriteEmbedded(struct vnt_private *priv, unsigned long dwData)
 }
 
 /*
- * Description: RFMD RF2959 IFRF chip init function
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
- * Description: Select channel with RFMD 2959 chip
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      uChannel    - Channel number
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
  * Description: AIROHA IFRF chip init function
  *
  * Parameters:
@@ -693,47 +600,6 @@ static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byCha
 }
 
 /*
- * Description: UW2451 IFRF chip init function
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
- * Description: Select channel with UW2451 chip
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      uChannel    - Channel number
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
- * Description: Set sleep mode to UW2451 chip
- *
- * Parameters:
- *  In:
- *      dwIoBase    - I/O base address
- *      uChannel    - Channel number
- *  Out:
- *      none
- *
- * Return Value: true if succeeded; false if failed.
- *
- */
-
-/*
  * Description: RF init function
  *
  * Parameters:
-- 
2.1.0

