Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50337 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaKJLbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 06:31:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Luis Henriques <luis.henriques@canonical.com>,
	kernel-team@lists.ubuntu.com
Subject: [3.16.y-ckt extended stable] Patch "wireless: rt2x00: add new rt2800usb devices" has been added to staging queue
Date: Mon, 10 Nov 2014 11:30:59 +0000
Message-Id: <1415619059-7150-1-git-send-email-luis.henriques@canonical.com> (sfid-20141110_123114_710632_4A534908)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a note to let you know that I have just added a patch titled

    wireless: rt2x00: add new rt2800usb devices

to the linux-3.16.y-queue branch of the 3.16.y-ckt extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.16.y-queue

This patch is scheduled to be released in version 3.16.7-ckt1.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.16.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Luis

------

>From 7ad1b700adf44cf6765359529058726f4b34a996 Mon Sep 17 00:00:00 2001
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 11 Jul 2014 21:46:57 +0200
Subject: wireless: rt2x00: add new rt2800usb devices

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
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 832006b5aab1..573897b8e878 100644
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
2.1.0

