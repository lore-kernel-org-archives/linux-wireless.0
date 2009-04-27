Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:36746 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743AbZD0V6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2009 17:58:34 -0400
Received: by ey-out-2122.google.com with SMTP id 9so58406eyd.37
        for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2009 14:58:33 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: rt2x00: Add new USB ID for rt2800usb
Date: Mon, 27 Apr 2009 23:58:31 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904272358.31224.IvDoorn@gmail.com> (sfid-20090427_235846_420871_7E0A01FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f5a31d9..9d967b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2943,6 +2943,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Linksys */
 	{ USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1737, 0x0077), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0162), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0789, 0x0163), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.2.3

