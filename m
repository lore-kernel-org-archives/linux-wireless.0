Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:62210 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbZC1Twx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 15:52:53 -0400
Received: by ey-out-2122.google.com with SMTP id 4so441059eyf.37
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 12:52:50 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/4] rt2x00: Add rt73usb USB IDs
Date: Sat, 28 Mar 2009 20:52:14 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <200903282051.25112.IvDoorn@gmail.com> <200903282051.41343.IvDoorn@gmail.com> <200903282051.58660.IvDoorn@gmail.com>
In-Reply-To: <200903282051.58660.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903282052.15095.IvDoorn@gmail.com> (sfid-20090328_205312_446141_03C78489)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 420fff4..853b2b2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2369,6 +2369,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00d8), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0411, 0x0116), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0411, 0x0119), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
 	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
-- 
1.5.6.1

