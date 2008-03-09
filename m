Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYCIVux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:53 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:53 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 08/24] rt2x00: Add new D-Link USB ID
Date: Sun, 9 Mar 2008 22:42:32 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092242.32267.IvDoorn@gmail.com> (sfid-20080309_215103_916310_3B2F354D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9b4feb3..4506423 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2137,6 +2137,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c03), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c04), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x07d1, 0x3c07), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0004), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Gigabyte */
-- 
1.5.4.3

