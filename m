Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49309 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbXB1OHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:31 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562649nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:30 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/28] rt2x00: New USB ID's
Date: Wed, 28 Feb 2007 15:07:15 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.15936.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new USB ID's for rt73usb

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 895d68b..10246dd 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -3470,6 +3470,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x7050) },
 	{ USB_DEVICE(0x050d, 0x705a) },
+	{ USB_DEVICE(0x050d, 0x905b) },
 	/* Billionton */
 	{ USB_DEVICE(0x1631, 0xc019) },
 	/* CNet */
@@ -3480,6 +3481,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c03) },
 	{ USB_DEVICE(0x07d1, 0x3c04) },
+	/* Gemtek */
+	{ USB_DEVICE(0x15a9, 0x0004) },
 	/* Gigabyte */
 	{ USB_DEVICE(0x1044, 0x8008) },
 	{ USB_DEVICE(0x1044, 0x800a) },
@@ -3487,6 +3490,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x1472, 0x0009) },
 	/* Hercules */
 	{ USB_DEVICE(0x06f8, 0xe010) },
+	{ USB_DEVICE(0x06f8, 0xe020) },
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x0020) },
 	{ USB_DEVICE(0x13b1, 0x0023) },
@@ -3505,6 +3509,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x90ac) },
 	/* Surecom */
 	{ USB_DEVICE(0x0769, 0x31f3) },
+	/* Planex */
+	{ USB_DEVICE(0x2019, 0xab01) },
 	{ 0, }
 };
 
