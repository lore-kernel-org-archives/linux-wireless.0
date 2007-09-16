Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbXIPMIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:19 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:18 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/24] rt2x00: New USB ID's for rt73usb and rt2500usb
Date: Sun, 16 Sep 2007 14:19:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.01916.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add several new USB id's for the rt73usb driver
and add a single new USB id for the rt2500usb driver.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 ++
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 2c2d8b7..5bdf64f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1783,6 +1783,8 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	{ USB_DEVICE(0x0411, 0x0066), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x0411, 0x0067), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x0411, 0x008b), USB_DEVICE_DATA(&rt2500usb_ops) },
+	{ USB_DEVICE(0x0411, 0x0097), USB_DEVICE_DATA(&rt2500usb_ops) },
+
 	/* MSI */
 	{ USB_DEVICE(0x0db0, 0x6861), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x0db0, 0x6865), USB_DEVICE_DATA(&rt2500usb_ops) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 561e29b..67a6644 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2080,6 +2080,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x13b1, 0x0023), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* MSI */
 	{ USB_DEVICE(0x0db0, 0x6877), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0db0, 0x6874), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0xa861), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0xa874), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Ralink */
@@ -2088,6 +2089,9 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x18e8, 0x6238), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Senao */
+	{ USB_DEVICE(0x1740, 0x7100), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x9712), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x90ac), USB_DEVICE_DATA(&rt73usb_ops) },
-- 
1.5.3
