Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44387 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXI3Skm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:42 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 19/26] at76_usb: Add ID for Corega Wireless LAN USB-11 mini  and mini2
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:40 -0400
Message-ID: <20070930184040.23921.28565.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Original patch by Weihua Yao <weihuayao@gmail.com>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 1c181bb..fb339ab 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -185,6 +185,10 @@ static struct usb_device_id dev_table[] = {
 	{USB_DEVICE(0x2019, 0x3220), USB_DEVICE_DATA(BOARD_503)},
 	/* Internal WLAN adapter in h5[4,5]xx series iPAQs */
 	{USB_DEVICE(0x049f, 0x0032), USB_DEVICE_DATA(BOARD_503)},
+	/* Corega Wireless LAN USB-11 mini */
+	{USB_DEVICE(0x07aa, 0x0011), USB_DEVICE_DATA(BOARD_503)},
+	/* Corega Wireless LAN USB-11 mini2 */
+	{USB_DEVICE(0x07aa, 0x0018), USB_DEVICE_DATA(BOARD_503)},
 	/*
 	 * at76c503-rfmd-acc
 	 */
