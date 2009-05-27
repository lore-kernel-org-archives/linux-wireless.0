Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42447 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762868AbZE0Hap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 03:30:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Przemyslaw Kulczycki <azrael@autocom.pl>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8187: add USB ID for Linksys WUSB54GC-EU v2 USB wifi dongle
Date: Wed, 27 May 2009 09:28:15 +0200
Message-Id: <1243409295-8363-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13383

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 6499ccc..2914de0 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -74,6 +74,8 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	{USB_DEVICE(0x18E8, 0x6232), .driver_info = DEVICE_RTL8187},
 	/* AirLive */
 	{USB_DEVICE(0x1b75, 0x8187), .driver_info = DEVICE_RTL8187},
+	/* Linksys */
+	{USB_DEVICE(0x1737, 0x0073), .driver_info = DEVICE_RTL8187B},
 	{}
 };
 
-- 
1.6.0.6

