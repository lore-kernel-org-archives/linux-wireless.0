Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:56012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbXDAOCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2007 10:02:37 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1294455uga
        for <linux-wireless@vger.kernel.org>; Sun, 01 Apr 2007 07:02:36 -0700 (PDT)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: new USB ID for rt73usb
Date: Sun, 1 Apr 2007 16:01:55 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704011601.56030.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will add a new USB ID for the rt73usb driver

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 7b3b878..21bb298 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -2938,6 +2938,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x1690, 0x0722) },
 	/* ASUS */
 	{ USB_DEVICE(0x0b05, 0x1723) },
+	{ USB_DEVICE(0x0b05, 0x1724) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x7050) },
 	{ USB_DEVICE(0x050d, 0x705a) },
