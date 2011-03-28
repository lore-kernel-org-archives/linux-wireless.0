Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41176 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1C1LhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:37:10 -0400
Received: by wya21 with SMTP id 21so2745055wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:37:09 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/13] rt2x00: Add support for the ZyXEL NWD-211AN USB
Date: Mon, 28 Mar 2011 13:34:50 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com> <201103281333.41794.IvDoorn@gmail.com> <201103281334.16711.IvDoorn@gmail.com>
In-Reply-To: <201103281334.16711.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281334.52023.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Add new USB ID

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 1ff8b57..e09460e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -876,6 +876,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x5a57, 0x5257), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x3416), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0586, 0x3418), USB_DEVICE_DATA(&rt2800usb_ops) },
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.7.2.3

