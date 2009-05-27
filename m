Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbZE0SyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:54:06 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Peter Grabienski <Peter.Grabienski@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Michael Fortin <Michael.Fortin@Atheros.com>,
	Johnny Cheng <Johnny.Cheng@Atheros.com>
Subject: [PATCH] ar9170: add AVM FRITZ devices
Date: Wed, 27 May 2009 14:54:07 -0400
Message-Id: <1243450447-11749-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds:

USB 0x057C:0x8401       AVM FRITZ!WLAN USB Stick N
USB 0x057C:0x8402       AVM FRITZ!WLAN USB Stick N 2.4

Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
Cc: Stephen Chen <Stephen.Chen@Atheros.com>
Cc: Michael Fortin <Michael.Fortin@Atheros.com>
Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/usb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index d7c13c0..7731b1f 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -81,6 +81,10 @@ static struct usb_device_id ar9170_usb_ids[] = {
 	{ USB_DEVICE(0x2019, 0x5304) },
 	/* IO-Data WNGDNUS2 */
 	{ USB_DEVICE(0x04bb, 0x093f) },
+	/* AVM FRITZ!WLAN USB Stick N */
+	{ USB_DEVICE(0x057C, 0x8401) },
+	/* AVM FRITZ!WLAN USB Stick N 2.4 */
+	{ USB_DEVICE(0x057C, 0x8402) },
 
 	/* terminate */
 	{}
-- 
1.6.2.2.446.gfbdc0

