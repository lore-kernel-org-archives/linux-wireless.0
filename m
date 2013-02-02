Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f170.google.com ([209.85.213.170]:41336 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab3BBC6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 21:58:36 -0500
Received: by mail-ye0-f170.google.com with SMTP id m12so1167116yen.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 18:58:35 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: rt2x00: rt2800usb add Sweex ids
Date: Sat,  2 Feb 2013 03:33:44 +0100
Message-Id: <1359772424-17250-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130202_035846_478924_93872C1E)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Info coming from Sweex Windows driver and wikidevi.com
0x177f,0x0163 Sweex LW163 RT3370 1x1, int. antenna
0x177f,0x0164 Sweex LW164 RT8070 1x1, Nano dongle
0x177f,0x0165 Sweex LW165 RT3370 1x1, ext. antenna
0x177f,0x0324 Sweex LW324 RT3072 2x2  with 32Mb NOR flash, autoinstall

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 42b5b65..8a57646 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1099,9 +1099,11 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x15a9, 0x0006) },
 	/* Sweex */
 	{ USB_DEVICE(0x177f, 0x0153) },
+	{ USB_DEVICE(0x177f, 0x0164) },
 	{ USB_DEVICE(0x177f, 0x0302) },
 	{ USB_DEVICE(0x177f, 0x0313) },
 	{ USB_DEVICE(0x177f, 0x0323) },
+	{ USB_DEVICE(0x177f, 0x0324) },
 	/* U-Media */
 	{ USB_DEVICE(0x157e, 0x300e) },
 	{ USB_DEVICE(0x157e, 0x3013) },
@@ -1133,6 +1135,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x8070) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0050) },
+	/* Sweex */
+	{ USB_DEVICE(0x177f, 0x0163) },
+	{ USB_DEVICE(0x177f, 0x0165) },
 #endif
 #ifdef CONFIG_RT2800USB_RT35XX
 	/* Allwin */
-- 
1.7.11.7

