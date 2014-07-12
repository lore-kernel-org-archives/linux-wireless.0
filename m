Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47955 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaGLTNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 15:13:18 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so2457108wgh.5
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 12:13:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6656: baseband.c remame abyVT3184_AL2230 to vnt_vt3184_al2230
Date: Sat, 12 Jul 2014 20:12:44 +0100
Message-Id: <1405192365-3134-3-git-send-email-tvboxspy@gmail.com> (sfid-20140712_211330_378184_0D596BF7)
In-Reply-To: <1405192365-3134-1-git-send-email-tvboxspy@gmail.com>
References: <1405192365-3134-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index f3640a5..586afe5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -51,7 +51,7 @@ static u8 vnt_vt3184_agc[] = {
 	0x38, 0x38, 0x3a, 0x3a, 0x3c, 0x3c, 0x3e, 0x3e  /* 0x3f */
 };
 
-static u8 abyVT3184_AL2230[] = {
+static u8 vnt_vt3184_al2230[] = {
 	0x31, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00,
 	0x70, 0x45, 0x2a, 0x76, 0x00, 0x00, 0x80, 0x00, /* 0x0f */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -402,9 +402,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 
 	if ((priv->byRFType == RF_AL2230) ||
 				(priv->byRFType == RF_AL2230S)) {
-		priv->byBBRxConf = abyVT3184_AL2230[10];
-		length = sizeof(abyVT3184_AL2230);
-		addr = abyVT3184_AL2230;
+		priv->byBBRxConf = vnt_vt3184_al2230[10];
+		length = sizeof(vnt_vt3184_al2230);
+		addr = vnt_vt3184_al2230;
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
@@ -417,9 +417,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 	} else if (priv->byRFType == RF_AIROHA7230) {
-		priv->byBBRxConf = abyVT3184_AL2230[10];
-		length = sizeof(abyVT3184_AL2230);
-		addr = abyVT3184_AL2230;
+		priv->byBBRxConf = vnt_vt3184_al2230[10];
+		length = sizeof(vnt_vt3184_al2230);
+		addr = vnt_vt3184_al2230;
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
-- 
1.9.1

