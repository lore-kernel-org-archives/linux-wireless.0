Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60734 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1LSUzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 15:55:10 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] rt2800: Add support for the Fujitsu Stylistic Q550
To: linux-wireless@vger.kernel.org, ivdoorn@gmail.com
Date: Mon, 19 Dec 2011 21:07:33 +0000
Message-ID: <20111219210724.27454.1642.stgit@bob.linux.org.uk> (sfid-20111219_215514_726451_584B7E38)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Just another USB identifier.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f156579..9e5556c 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1158,6 +1158,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x7392, 0x7722) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
+	/* Fujitsu Stylistic 550 */
+	{ USB_DEVICE(0x1690, 0x0761) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */

