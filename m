Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46006 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2LVRvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 12:51:35 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so2855400bku.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 09:51:33 -0800 (PST)
In-Reply-To: <20121222171854.3ee183a36a12491da52553a9@o2.pl>
References: <20121222171854.3ee183a36a12491da52553a9@o2.pl>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 22 Dec 2012 18:30:01 +0100
Subject: [PATCH v2] p54usb: add USB ID for T-Com Sinus 154 data II
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, tsg@o2.pl
Message-Id: <E1TmT8k-0006UE-3m@debian64.localnet> (sfid-20121222_185149_863104_2E7ABC53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomasz Guszkowski <tsg@o2.pl>

Added USB ID for T-Com Sinus 154 data II.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomasz Guszkowski <tsg@o2.pl>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
---
Thank you for reporting this one. A few minutes ago, I added
the device to our Supported USB wireless devices' list at:
<http://http://wireless.kernel.org/en/users/Drivers/p54/devices>

Changes from v1:
	- put device id into the ISL3887 section
	  [which it probably is, since it needs the LM87 FW]
	- Added Cc -stable
	  [-stable allows usbid patches anytime]
	- cc'd John

Regards

Chrisitan
---
 drivers/net/wireless/p54/p54usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index e71c702..64b944b 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -82,6 +82,7 @@ static struct usb_device_id p54u_table[] = {
 	{USB_DEVICE(0x06a9, 0x000e)},	/* Westell 802.11g USB (A90-211WG-01) */
 	{USB_DEVICE(0x06b9, 0x0121)},	/* Thomson SpeedTouch 121g */
 	{USB_DEVICE(0x0707, 0xee13)},   /* SMC 2862W-G version 2 */
+	{USB_DEVICE(0x083a, 0x4503)},	/* T-Com Sinus 154 data II */
 	{USB_DEVICE(0x083a, 0x4521)},   /* Siemens Gigaset USB Adapter 54 version 2 */
 	{USB_DEVICE(0x083a, 0xc501)},	/* Zoom Wireless-G 4410 */
 	{USB_DEVICE(0x083a, 0xf503)},	/* Accton FD7050E ver 1010ec  */
-- 
1.7.10.4

