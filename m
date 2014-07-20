Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63049 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaGTOev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:51 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so2872757wib.11
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/25] staging: vt6656: struct vnt_private replace byBBPreEDRSSI with bb_pre_ed_rssi
Date: Sun, 20 Jul 2014 15:33:27 +0100
Message-Id: <1405866815-2687-17-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_935283_3CB64912)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 128 +++++++++++++++++++-------------------
 drivers/staging/vt6656/device.h   |   2 +-
 drivers/staging/vt6656/dpc.c      |   4 +-
 3 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index dd449a3..e15e842 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -580,69 +580,69 @@ void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 			break;
 		}
 
-		if (priv->byBBPreEDRSSI <= 45) {
+		if (priv->bb_pre_ed_rssi <= 45) {
 			ed_inx = 20;
 			cr_201 = 0xff;
-		} else if (priv->byBBPreEDRSSI <= 46) {
+		} else if (priv->bb_pre_ed_rssi <= 46) {
 			ed_inx = 19;
 			cr_201 = 0x1a;
-		} else if (priv->byBBPreEDRSSI <= 47) {
+		} else if (priv->bb_pre_ed_rssi <= 47) {
 			ed_inx = 18;
 			cr_201 = 0x15;
-		} else if (priv->byBBPreEDRSSI <= 49) {
+		} else if (priv->bb_pre_ed_rssi <= 49) {
 			ed_inx = 17;
 			cr_201 = 0xe;
-		} else if (priv->byBBPreEDRSSI <= 51) {
+		} else if (priv->bb_pre_ed_rssi <= 51) {
 			ed_inx = 16;
 			cr_201 = 0x9;
-		} else if (priv->byBBPreEDRSSI <= 53) {
+		} else if (priv->bb_pre_ed_rssi <= 53) {
 			ed_inx = 15;
 			cr_201 = 0x6;
-		} else if (priv->byBBPreEDRSSI <= 55) {
+		} else if (priv->bb_pre_ed_rssi <= 55) {
 			ed_inx = 14;
 			cr_201 = 0x3;
-		} else if (priv->byBBPreEDRSSI <= 56) {
+		} else if (priv->bb_pre_ed_rssi <= 56) {
 			ed_inx = 13;
 			cr_201 = 0x2;
 			cr_206 = 0xa0;
-		} else if (priv->byBBPreEDRSSI <= 57) {
+		} else if (priv->bb_pre_ed_rssi <= 57) {
 			ed_inx = 12;
 			cr_201 = 0x2;
 			cr_206 = 0x20;
-		} else if (priv->byBBPreEDRSSI <= 58) {
+		} else if (priv->bb_pre_ed_rssi <= 58) {
 			ed_inx = 11;
 			cr_201 = 0x1;
 			cr_206 = 0xa0;
-		} else if (priv->byBBPreEDRSSI <= 59) {
+		} else if (priv->bb_pre_ed_rssi <= 59) {
 			ed_inx = 10;
 			cr_201 = 0x1;
 			cr_206 = 0x54;
-		} else if (priv->byBBPreEDRSSI <= 60) {
+		} else if (priv->bb_pre_ed_rssi <= 60) {
 			ed_inx = 9;
 			cr_201 = 0x1;
 			cr_206 = 0x18;
-		} else if (priv->byBBPreEDRSSI <= 61) {
+		} else if (priv->bb_pre_ed_rssi <= 61) {
 			ed_inx = 8;
 			cr_206 = 0xe3;
-		} else if (priv->byBBPreEDRSSI <= 62) {
+		} else if (priv->bb_pre_ed_rssi <= 62) {
 			ed_inx = 7;
 			cr_206 = 0xb9;
-		} else if (priv->byBBPreEDRSSI <= 63) {
+		} else if (priv->bb_pre_ed_rssi <= 63) {
 			ed_inx = 6;
 			cr_206 = 0x93;
-		} else if (priv->byBBPreEDRSSI <= 64) {
+		} else if (priv->bb_pre_ed_rssi <= 64) {
 			ed_inx = 5;
 			cr_206 = 0x79;
-		} else if (priv->byBBPreEDRSSI <= 65) {
+		} else if (priv->bb_pre_ed_rssi <= 65) {
 			ed_inx = 4;
 			cr_206 = 0x62;
-		} else if (priv->byBBPreEDRSSI <= 66) {
+		} else if (priv->bb_pre_ed_rssi <= 66) {
 			ed_inx = 3;
 			cr_206 = 0x51;
-		} else if (priv->byBBPreEDRSSI <= 67) {
+		} else if (priv->bb_pre_ed_rssi <= 67) {
 			ed_inx = 2;
 			cr_206 = 0x43;
-		} else if (priv->byBBPreEDRSSI <= 68) {
+		} else if (priv->bb_pre_ed_rssi <= 68) {
 			ed_inx = 1;
 			cr_206 = 0x36;
 		} else {
@@ -659,75 +659,75 @@ void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 			break;
 		}
 
-		if (priv->byBBPreEDRSSI <= 41) {
+		if (priv->bb_pre_ed_rssi <= 41) {
 			ed_inx = 22;
 			cr_201 = 0xff;
-		} else if (priv->byBBPreEDRSSI <= 42) {
+		} else if (priv->bb_pre_ed_rssi <= 42) {
 			ed_inx = 21;
 			cr_201 = 0x36;
-		} else if (priv->byBBPreEDRSSI <= 43) {
+		} else if (priv->bb_pre_ed_rssi <= 43) {
 			ed_inx = 20;
 			cr_201 = 0x26;
-		} else if (priv->byBBPreEDRSSI <= 45) {
+		} else if (priv->bb_pre_ed_rssi <= 45) {
 			ed_inx = 19;
 			cr_201 = 0x18;
-		} else if (priv->byBBPreEDRSSI <= 47) {
+		} else if (priv->bb_pre_ed_rssi <= 47) {
 			ed_inx = 18;
 			cr_201 = 0x11;
-		} else if (priv->byBBPreEDRSSI <= 49) {
+		} else if (priv->bb_pre_ed_rssi <= 49) {
 			ed_inx = 17;
 			cr_201 = 0xa;
-		} else if (priv->byBBPreEDRSSI <= 51) {
+		} else if (priv->bb_pre_ed_rssi <= 51) {
 			ed_inx = 16;
 			cr_201 = 0x7;
-		} else if (priv->byBBPreEDRSSI <= 53) {
+		} else if (priv->bb_pre_ed_rssi <= 53) {
 			ed_inx = 15;
 			cr_201 = 0x4;
-		} else if (priv->byBBPreEDRSSI <= 55) {
+		} else if (priv->bb_pre_ed_rssi <= 55) {
 			ed_inx = 14;
 			cr_201 = 0x2;
 			cr_206 = 0xc0;
-		} else if (priv->byBBPreEDRSSI <= 56) {
+		} else if (priv->bb_pre_ed_rssi <= 56) {
 			ed_inx = 13;
 			cr_201 = 0x2;
 			cr_206 = 0x30;
-		} else if (priv->byBBPreEDRSSI <= 57) {
+		} else if (priv->bb_pre_ed_rssi <= 57) {
 			ed_inx = 12;
 			cr_201 = 0x1;
 			cr_206 = 0xb0;
-		} else if (priv->byBBPreEDRSSI <= 58) {
+		} else if (priv->bb_pre_ed_rssi <= 58) {
 			ed_inx = 11;
 			cr_201 = 0x1;
 			cr_206 = 0x70;
-		} else if (priv->byBBPreEDRSSI <= 59) {
+		} else if (priv->bb_pre_ed_rssi <= 59) {
 			ed_inx = 10;
 			cr_201 = 0x1;
 			cr_206 = 0x30;
-		} else if (priv->byBBPreEDRSSI <= 60) {
+		} else if (priv->bb_pre_ed_rssi <= 60) {
 			ed_inx = 9;
 			cr_206 = 0xea;
-		} else if (priv->byBBPreEDRSSI <= 61) {
+		} else if (priv->bb_pre_ed_rssi <= 61) {
 			ed_inx = 8;
 			cr_206 = 0xc0;
-		} else if (priv->byBBPreEDRSSI <= 62) {
+		} else if (priv->bb_pre_ed_rssi <= 62) {
 			ed_inx = 7;
 			cr_206 = 0x9c;
-		} else if (priv->byBBPreEDRSSI <= 63) {
+		} else if (priv->bb_pre_ed_rssi <= 63) {
 			ed_inx = 6;
 			cr_206 = 0x80;
-		} else if (priv->byBBPreEDRSSI <= 64) {
+		} else if (priv->bb_pre_ed_rssi <= 64) {
 			ed_inx = 5;
 			cr_206 = 0x68;
-		} else if (priv->byBBPreEDRSSI <= 65) {
+		} else if (priv->bb_pre_ed_rssi <= 65) {
 			ed_inx = 4;
 			cr_206 = 0x52;
-		} else if (priv->byBBPreEDRSSI <= 66) {
+		} else if (priv->bb_pre_ed_rssi <= 66) {
 			ed_inx = 3;
 			cr_206 = 0x43;
-		} else if (priv->byBBPreEDRSSI <= 67) {
+		} else if (priv->bb_pre_ed_rssi <= 67) {
 			ed_inx = 2;
 			cr_206 = 0x36;
-		} else if (priv->byBBPreEDRSSI <= 68) {
+		} else if (priv->bb_pre_ed_rssi <= 68) {
 			ed_inx = 1;
 			cr_206 = 0x2d;
 		} else {
@@ -743,69 +743,69 @@ void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 			break;
 		}
 
-		if (priv->byBBPreEDRSSI <= 41) {
+		if (priv->bb_pre_ed_rssi <= 41) {
 			ed_inx = 20;
 			cr_201 = 0xff;
-		} else if (priv->byBBPreEDRSSI <= 42) {
+		} else if (priv->bb_pre_ed_rssi <= 42) {
 			ed_inx = 19;
 			cr_201 = 0x36;
-		} else if (priv->byBBPreEDRSSI <= 43) {
+		} else if (priv->bb_pre_ed_rssi <= 43) {
 			ed_inx = 18;
 			cr_201 = 0x26;
-		} else if (priv->byBBPreEDRSSI <= 45) {
+		} else if (priv->bb_pre_ed_rssi <= 45) {
 			ed_inx = 17;
 			cr_201 = 0x18;
-		} else if (priv->byBBPreEDRSSI <= 47) {
+		} else if (priv->bb_pre_ed_rssi <= 47) {
 			ed_inx = 16;
 			cr_201 = 0x11;
-		} else if (priv->byBBPreEDRSSI <= 49) {
+		} else if (priv->bb_pre_ed_rssi <= 49) {
 			ed_inx = 15;
 			cr_201 = 0xa;
-		} else if (priv->byBBPreEDRSSI <= 51) {
+		} else if (priv->bb_pre_ed_rssi <= 51) {
 			ed_inx = 14;
 			cr_201 = 0x7;
-		} else if (priv->byBBPreEDRSSI <= 53) {
+		} else if (priv->bb_pre_ed_rssi <= 53) {
 			ed_inx = 13;
 			cr_201 = 0x4;
-		} else if (priv->byBBPreEDRSSI <= 55) {
+		} else if (priv->bb_pre_ed_rssi <= 55) {
 			ed_inx = 12;
 			cr_201 = 0x2;
 			cr_206 = 0xc0;
-		} else if (priv->byBBPreEDRSSI <= 56) {
+		} else if (priv->bb_pre_ed_rssi <= 56) {
 			ed_inx = 11;
 			cr_201 = 0x2;
 			cr_206 = 0x30;
-		} else if (priv->byBBPreEDRSSI <= 57) {
+		} else if (priv->bb_pre_ed_rssi <= 57) {
 			ed_inx = 10;
 			cr_201 = 0x1;
 			cr_206 = 0xb0;
-		} else if (priv->byBBPreEDRSSI <= 58) {
+		} else if (priv->bb_pre_ed_rssi <= 58) {
 			ed_inx = 9;
 			cr_201 = 0x1;
 			cr_206 = 0x70;
-		} else if (priv->byBBPreEDRSSI <= 59) {
+		} else if (priv->bb_pre_ed_rssi <= 59) {
 			ed_inx = 8;
 			cr_201 = 0x1;
 			cr_206 = 0x30;
-		} else if (priv->byBBPreEDRSSI <= 60) {
+		} else if (priv->bb_pre_ed_rssi <= 60) {
 			ed_inx = 7;
 			cr_206 = 0xea;
-		} else if (priv->byBBPreEDRSSI <= 61) {
+		} else if (priv->bb_pre_ed_rssi <= 61) {
 			ed_inx = 6;
 			cr_206 = 0xc0;
-		} else if (priv->byBBPreEDRSSI <= 62) {
+		} else if (priv->bb_pre_ed_rssi <= 62) {
 			ed_inx = 5;
 			cr_206 = 0x9c;
-		} else if (priv->byBBPreEDRSSI <= 63) {
+		} else if (priv->bb_pre_ed_rssi <= 63) {
 			ed_inx = 4;
 			cr_206 = 0x80;
-		} else if (priv->byBBPreEDRSSI <= 64) {
+		} else if (priv->bb_pre_ed_rssi <= 64) {
 			ed_inx = 3;
 			cr_206 = 0x68;
-		} else if (priv->byBBPreEDRSSI <= 65) {
+		} else if (priv->bb_pre_ed_rssi <= 65) {
 			ed_inx = 2;
 			cr_206 = 0x52;
-		} else if (priv->byBBPreEDRSSI <= 66) {
+		} else if (priv->bb_pre_ed_rssi <= 66) {
 			ed_inx = 1;
 			cr_206 = 0x43;
 		} else {
@@ -821,8 +821,8 @@ void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 
 	priv->byBBPreEDIndex = ed_inx;
 
-	dev_dbg(&priv->usb->dev, "%s byBBPreEDRSSI %d\n",
-					__func__, priv->byBBPreEDRSSI);
+	dev_dbg(&priv->usb->dev, "%s bb_pre_ed_rssi %d\n",
+					__func__, priv->bb_pre_ed_rssi);
 
 	if (!cr_201 && !cr_206)
 		return;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 24ebbd0..e97283b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -385,7 +385,7 @@ struct vnt_private {
 	/* For Update BaseBand VGA Gain Offset */
 	u8 bb_vga[BB_VGA_LEVEL];
 
-	u8 byBBPreEDRSSI;
+	u8 bb_pre_ed_rssi;
 	u8 byBBPreEDIndex;
 
 	/* command timer */
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 3bf2782..f5fbb5f 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -152,8 +152,8 @@ int vnt_rx_data(struct vnt_private *priv, struct vnt_rcb *ptr_rcb,
 
 	vnt_rf_rssi_to_dbm(priv, *rssi, &rx_dbm);
 
-	priv->byBBPreEDRSSI = (u8)rx_dbm + 1;
-	priv->current_rssi = priv->byBBPreEDRSSI;
+	priv->bb_pre_ed_rssi = (u8)rx_dbm + 1;
+	priv->current_rssi = priv->bb_pre_ed_rssi;
 
 	frame = skb_data + 8;
 
-- 
2.0.1

