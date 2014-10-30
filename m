Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38052 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974AbaJ3LTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 07:19:05 -0400
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH -stable] wireless: rt2x00: add new rt2800usb devices
Date: Thu, 30 Oct 2014 12:18:43 +0100
Message-Id: <1414667923-2331-1-git-send-email-xose.vazquez@gmail.com> (sfid-20141030_121913_795548_26D5870B)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
0x0df6 0x0078 RT???? Sitecom N300

Cc: stable@vger.kernel.org
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 832006b..573897b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1284,6 +1284,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
 	{ USB_DEVICE(0x043e, 0x7a32) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x17e8) },
 	/* Azurewave */
 	{ USB_DEVICE(0x13d3, 0x3329) },
 	{ USB_DEVICE(0x13d3, 0x3365) },
@@ -1320,6 +1322,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x057c, 0x8501) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x0241) },
+	{ USB_DEVICE(0x0411, 0x0253) },
 	/* D-Link */
 	{ USB_DEVICE(0x2001, 0x3c1a) },
 	{ USB_DEVICE(0x2001, 0x3c21) },
@@ -1410,6 +1413,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x0053) },
 	{ USB_DEVICE(0x0df6, 0x0069) },
 	{ USB_DEVICE(0x0df6, 0x006f) },
+	{ USB_DEVICE(0x0df6, 0x0078) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },
-- 
1.9.3

