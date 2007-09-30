Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38263 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbXI3Sl1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:41:27 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 26/26] at76_usb: Add ID for at76c503a based CNETUSB611
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:41:25 -0400
Message-ID: <20070930184125.23921.90095.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 8a8fce2..d2e3c55 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -167,6 +167,8 @@ static struct usb_device_id dev_table[] = {
 	{USB_DEVICE(0x03eb, 0x4102), USB_DEVICE_DATA(BOARD_503)},
 	/* Dick Smith Electronics XH1153 802.11b USB adapter */
 	{USB_DEVICE(0x1371, 0x5743), USB_DEVICE_DATA(BOARD_503)},
+	/* CNet CNUSB611 */
+	{USB_DEVICE(0x1371, 0x0001), USB_DEVICE_DATA(BOARD_503)},
 	/* FiberLine FL-WL200U */
 	{USB_DEVICE(0x1371, 0x0002), USB_DEVICE_DATA(BOARD_503)},
 	/* BenQ AWL400 USB stick */
