Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50005 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab3F1TNa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:30 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 19/19] rt2x00: rt2800usb: add USB device ID for Linksys AE3000
Date: Fri, 28 Jun 2013 21:12:33 +0200
Message-Id: <1372446753-11408-20-git-send-email-juhosg@openwrt.org> (sfid-20130628_211342_416033_F887C814)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linksys AE3000 device is based on the RT3573
chipset. The support for this chipset is available
already, and the AE3000 device works with the driver.

Only managed mode works correctly at the moment,
for AP mode additional changes are needed in the
driver.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index c24c1fd..6136871 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1183,6 +1183,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x04bb, 0x0944) },
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x002f) },
+	{ USB_DEVICE(0x13b1, 0x003b) },
 	{ USB_DEVICE(0x1737, 0x0079) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3572) },
-- 
1.7.10

