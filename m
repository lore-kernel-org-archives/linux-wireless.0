Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759891AbZADAKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 19:10:54 -0500
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: add USB ID for the Linksys WUSB200.
Date: Sun, 4 Jan 2009 01:10:49 +0100
Cc: rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901040110.51629.s.L-H@gmx.de> (sfid-20090104_011059_119325_0B432772)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add USB ID for the Linksys WUSB200 Wireless-G Business USB Adapter to 
rt73usb.

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: stable <stable@kernel.org>

---
 drivers/net/wireless/rt2x00/rt73usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d638a8a..96a8d69 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2321,6 +2321,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x0020), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x13b1, 0x0023), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x13b1, 0x0028), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* MSI */
 	{ USB_DEVICE(0x0db0, 0x6877), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x6874), USB_DEVICE_DATA(&rt73usb_ops) },
-- 
1.5.6.5
