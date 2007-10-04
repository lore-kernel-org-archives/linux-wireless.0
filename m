Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43828 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbXJDEIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 00:08:34 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8187: Add device ID for HP wireless print kit usb dongle
Date: Thu, 04 Oct 2007 00:04:07 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Message-Id: <20071004040407.23959.40989.stgit@magic.sourmilk.net> (sfid-20071004_050842_171865_671F3111)
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This adds the device ID for the HP wireless print kit usb dongle.

Thanks to Thierry Merle for the patch to the original rtl8187 driver.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8187_dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index b0a92f5..0ef887d 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -36,6 +36,8 @@ static struct usb_device_id rtl8187_table[] __devinitdata = {
 	/* Netgear */
 	{USB_DEVICE(0x0846, 0x6100)},
 	{USB_DEVICE(0x0846, 0x6a00)},
+	/* HP */
+	{USB_DEVICE(0x03f0, 0xca02)},
 	{}
 };
 

