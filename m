Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:61782 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbZLVXDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:44 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/5] rt2x00: Add USB ID for Linksys WUSB 600N rev 2.
Date: Wed, 23 Dec 2009 00:03:21 +0100
Message-Id: <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a rt2870 based device.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 40295b4..aff984b 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -933,6 +933,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1737, 0x0077), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1737, 0x0079), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0162), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0789, 0x0163), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.5.7

