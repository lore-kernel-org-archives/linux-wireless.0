Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45190 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaGLTNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 15:13:20 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so2442501wgh.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 12:13:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6656: baseband.c rename abyVT3184_VT3226D0 to vnt_vt3184_vt3226d0
Date: Sat, 12 Jul 2014 20:12:45 +0100
Message-Id: <1405192365-3134-4-git-send-email-tvboxspy@gmail.com> (sfid-20140712_211331_004561_5B0F9920)
In-Reply-To: <1405192365-3134-1-git-send-email-tvboxspy@gmail.com>
References: <1405192365-3134-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 586afe5..c1675d5 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -87,7 +87,7 @@ static u8 vnt_vt3184_al2230[] = {
 };
 
 //{{RobertYu:20060515, new BB setting for VT3226D0
-static u8 abyVT3184_VT3226D0[] = {
+static u8 vnt_vt3184_vt3226d0[] = {
 	0x31, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00,
 	0x70, 0x45, 0x2a, 0x76, 0x00, 0x00, 0x80, 0x00, /* 0x0f */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -435,9 +435,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 		priv->ldBmThreshold[3] = 0;
 	} else if ((priv->byRFType == RF_VT3226) ||
 			(priv->byRFType == RF_VT3226D0)) {
-		priv->byBBRxConf = abyVT3184_VT3226D0[10];
-		length = sizeof(abyVT3184_VT3226D0);
-		addr = abyVT3184_VT3226D0;
+		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
+		length = sizeof(vnt_vt3184_vt3226d0);
+		addr = vnt_vt3184_vt3226d0;
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
@@ -452,9 +452,9 @@ int BBbVT3184Init(struct vnt_private *priv)
 		/* Fix VT3226 DFC system timing issue */
 		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
 	} else if ((priv->byRFType == RF_VT3342A0)) {
-		priv->byBBRxConf = abyVT3184_VT3226D0[10];
-		length = sizeof(abyVT3184_VT3226D0);
-		addr = abyVT3184_VT3226D0;
+		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
+		length = sizeof(vnt_vt3184_vt3226d0);
+		addr = vnt_vt3184_vt3226d0;
 		agc = vnt_vt3184_agc;
 		length_agc = sizeof(vnt_vt3184_agc);
 
-- 
1.9.1

