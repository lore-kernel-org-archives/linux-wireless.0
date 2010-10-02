Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0JBJf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:28 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658555wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:28 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/20] rt2x00: Add rt73usb device ID
Date: Sat, 2 Oct 2010 11:30:19 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021129.31357.IvDoorn@gmail.com> <201010021130.00255.IvDoorn@gmail.com>
In-Reply-To: <201010021130.00255.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021130.20755.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index cc6a72b..f78bc2a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2365,6 +2365,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x0116), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x0119), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0411, 0x0137), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CEIVA */
 	{ USB_DEVICE(0x178d, 0x02be), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
-- 
1.7.2.3

