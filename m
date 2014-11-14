Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935250AbaKNM1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 07:27:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] wireless: rt2x00: add new rt2800usb devices
Date: Fri, 14 Nov 2014 13:25:53 +0100
Message-Id: <1415968006-9521-53-git-send-email-jslaby@suse.cz> (sfid-20141114_132758_627458_A1C41DCD)
In-Reply-To: <1415968006-9521-1-git-send-email-jslaby@suse.cz>
References: <1415968006-9521-1-git-send-email-jslaby@suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

commit 6a06e554daef86c4e8d290284927b081fedb249e upstream.

0x0b05 0x17e8 RT5372 USB 2.0  bgn 2x2 ASUS USB-N14
0x0411 0x0253 RT5572 USB 2.0 abgn 2x2 BUFFALO WLP-U2-300D
0x0df6 0x0078 RT???? Sitecom N300

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b6cb308beda1..ec816e0459cc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1238,6 +1238,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
 	{ USB_DEVICE(0x043e, 0x7a32) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x17e8) },
 	/* Azurewave */
 	{ USB_DEVICE(0x13d3, 0x3329) },
 	{ USB_DEVICE(0x13d3, 0x3365) },
@@ -1274,6 +1276,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x057c, 0x8501) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x0241) },
+	{ USB_DEVICE(0x0411, 0x0253) },
 	/* D-Link */
 	{ USB_DEVICE(0x2001, 0x3c1a) },
 	{ USB_DEVICE(0x2001, 0x3c21) },
@@ -1364,6 +1367,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x0053) },
 	{ USB_DEVICE(0x0df6, 0x0069) },
 	{ USB_DEVICE(0x0df6, 0x006f) },
+	{ USB_DEVICE(0x0df6, 0x0078) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },
-- 
2.1.3

