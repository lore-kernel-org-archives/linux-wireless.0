Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49214 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab0ENXof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 19:44:35 -0400
Received: by wwe15 with SMTP id 15so176224wwe.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 16:44:33 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, herton@mandriva.com.br,
	htl10@users.sourceforge.net, Larry.Finger@lwfinger.net,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] wireless: rtl818x: rtl8187 add ids
Date: Sat, 15 May 2010 01:44:20 +0200
Message-Id: <1273880660-11072-2-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1273880660-11072-1-git-send-email-xose.vazquez@gmail.com>
References: <1273880660-11072-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

taken from windows inf file

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index b332c1e..f641bde 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -53,6 +53,7 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	{USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8197), .driver_info = DEVICE_RTL8187B},
 	{USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
+	{USB_DEVICE(0x0bda, 0x8199), .driver_info = DEVICE_RTL8187B},
 	/* Surecom */
 	{USB_DEVICE(0x0769, 0x11F2), .driver_info = DEVICE_RTL8187},
 	/* Logitech */
@@ -79,6 +80,10 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	{USB_DEVICE(0x1b75, 0x8187), .driver_info = DEVICE_RTL8187},
 	/* Linksys */
 	{USB_DEVICE(0x1737, 0x0073), .driver_info = DEVICE_RTL8187B},
+	/* Trust */
+	{USB_DEVICE(0x145f, 0x0161), .driver_info = DEVICE_RTL8187},
+	/* Edimax */
+	{USB_DEVICE(0x7392, 0x7612), .driver_info = DEVICE_RTL8187},
 	{}
 };
 
-- 
1.6.6.1

