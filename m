Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:52466 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZCXU6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:58:11 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Mike Kershaw <dragorn@kismetwireless.net>
Subject: [PATCH] ar9170: add Cace Airpcap NX usb_id
Date: Tue, 24 Mar 2009 21:58:08 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20090324202633.GA21202@drd1813.lan>
In-Reply-To: <20090324202633.GA21202@drd1813.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903242158.08286.chunkeey@web.de> (sfid-20090324_215815_016680_1D611540)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a new device to ar9170usb.

Reported-by: Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ar9170/usb.c b/drivers/net/wireless/ar9170/usb.c
index ad29684..43e8d8d 100644
--- a/drivers/net/wireless/ar9170/usb.c
+++ b/drivers/net/wireless/ar9170/usb.c
@@ -59,6 +59,8 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9170) },
 	/* Atheros TG121N */
 	{ USB_DEVICE(0x0cf3, 0x1001) },
+	/* Cace Airpcap NX */
+	{ USB_DEVICE(0xcace, 0x0300) },
 	/* D-Link DWA 160A */
 	{ USB_DEVICE(0x07d1, 0x3c10) },
 	/* Netgear WNDA3100 */

