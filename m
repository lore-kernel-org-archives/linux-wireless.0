Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:42541 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab3G3UJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 16:09:02 -0400
Received: by mail-we0-f181.google.com with SMTP id p58so5328861wes.26
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 13:09:01 -0700 (PDT)
Message-ID: <1375214934.5852.10.camel@canaries64> (sfid-20130730_220906_582734_96883B3C)
Subject: [PATCH 2/2] staging: vt6656: device.h unused variables
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Jul 2013 21:08:54 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wACKDuration
wRTSTransmitLen
byRTSServiceField
byRTSSignalField


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 5324c24..4986910 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -591,11 +591,6 @@ struct vnt_private {
 	u8 abyBSSID[ETH_ALEN];
 	u8 abyDesireBSSID[ETH_ALEN];
 
-	u16 wACKDuration;
-	u16 wRTSTransmitLen;
-	u8 byRTSServiceField;
-	u8 byRTSSignalField;
-
 	u32 dwMaxReceiveLifetime;  /* dot11MaxReceiveLifetime */
 
 	int bCCK;
-- 
1.8.1.2


