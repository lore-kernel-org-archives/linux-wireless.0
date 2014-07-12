Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44061 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaGLTNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 15:13:17 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so1705819wgh.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 12:13:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6656: baseband.c rename abyVT3184_AGC to vnt_vt3184_agc
Date: Sat, 12 Jul 2014 20:12:43 +0100
Message-Id: <1405192365-3134-2-git-send-email-tvboxspy@gmail.com> (sfid-20140712_211329_773089_63E6247D)
In-Reply-To: <1405192365-3134-1-git-send-email-tvboxspy@gmail.com>
References: <1405192365-3134-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index f066f4c..f3640a5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -40,7 +40,7 @@
 #include "rf.h"
 #include "usbpipe.h"
 
-static u8 abyVT3184_AGC[] = {
+static u8 vnt_vt3184_agc[] = {
 	0x00, 0x00, 0x02, 0x02, 0x04, 0x04, 0x06, 0x06,
 	0x08, 0x08, 0x0a, 0x0a, 0x0c, 0x0c, 0x0e, 0x0e, /* 0x0f */
 	0x10, 0x10, 0x12, 0x12, 0x14, 0x14, 0x16, 0x16,
@@ -405,8 +405,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->byBBRxConf = abyVT3184_AL2230[10];
 		length = sizeof(abyVT3184_AL2230);
 		addr = abyVT3184_AL2230;
-		agc = abyVT3184_AGC;
-		length_agc = sizeof(abyVT3184_AGC);
+		agc = vnt_vt3184_agc;
+		length_agc = sizeof(vnt_vt3184_agc);
 
 		priv->abyBBVGA[0] = 0x1C;
 		priv->abyBBVGA[1] = 0x10;
@@ -420,8 +420,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->byBBRxConf = abyVT3184_AL2230[10];
 		length = sizeof(abyVT3184_AL2230);
 		addr = abyVT3184_AL2230;
-		agc = abyVT3184_AGC;
-		length_agc = sizeof(abyVT3184_AGC);
+		agc = vnt_vt3184_agc;
+		length_agc = sizeof(vnt_vt3184_agc);
 
 		addr[0xd7] = 0x06;
 
@@ -438,8 +438,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->byBBRxConf = abyVT3184_VT3226D0[10];
 		length = sizeof(abyVT3184_VT3226D0);
 		addr = abyVT3184_VT3226D0;
-		agc = abyVT3184_AGC;
-		length_agc = sizeof(abyVT3184_AGC);
+		agc = vnt_vt3184_agc;
+		length_agc = sizeof(vnt_vt3184_agc);
 
 		priv->abyBBVGA[0] = 0x20;
 		priv->abyBBVGA[1] = 0x10;
@@ -455,8 +455,8 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->byBBRxConf = abyVT3184_VT3226D0[10];
 		length = sizeof(abyVT3184_VT3226D0);
 		addr = abyVT3184_VT3226D0;
-		agc = abyVT3184_AGC;
-		length_agc = sizeof(abyVT3184_AGC);
+		agc = vnt_vt3184_agc;
+		length_agc = sizeof(vnt_vt3184_agc);
 
 		priv->abyBBVGA[0] = 0x20;
 		priv->abyBBVGA[1] = 0x10;
-- 
1.9.1

