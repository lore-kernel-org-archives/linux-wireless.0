Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47869 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaEQIxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:19 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so5811923wgh.31
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/22] staging: vt6656: vnt_private remove dead variables
Date: Sat, 17 May 2014 09:50:37 +0100
Message-Id: <1400316639-4430-20-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112148_224366_B66A4346)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byFOETuning
byAutoPwrTunning

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 6 ------
 drivers/staging/vt6656/main_usb.c | 2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index f3072dd..a8637ec 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -672,12 +672,6 @@ struct vnt_private {
 
 	int bRadioCmd;
 
-	/* For FOE Tuning */
-	u8  byFOETuning;
-
-	/* For Auto Power Tunning */
-	u8  byAutoPwrTunning;
-
 	/* BaseBand Loopback Use */
 	u8 byBBCR4d;
 	u8 byBBCRc9;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c00a16c..a9d9cc8 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -263,8 +263,6 @@ device_set_options(struct vnt_private *pDevice) {
     pDevice->byPacketType = pDevice->byBBType;
     pDevice->byAutoFBCtrl = AUTO_FB_0;
     pDevice->bUpdateBBVGA = true;
-    pDevice->byFOETuning = 0;
-    pDevice->byAutoPwrTunning = 0;
     pDevice->byPreambleType = 0;
     pDevice->bExistSWNetAddr = false;
     /* pDevice->bDiversityRegCtlON = true; */
-- 
1.9.1

