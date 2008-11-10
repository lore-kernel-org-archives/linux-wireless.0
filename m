Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:50710 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYKJXsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 18:48:08 -0500
Received: from mail.promwad.com ([212.98.183.232] helo=intranet.promwad.com)
	by promwad.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1KzgUH-00058K-3z
	for linux-wireless@vger.kernel.org; Tue, 11 Nov 2008 01:48:06 +0200
Received: from intranet.promwad.com ([192.168.10.1] helo=promwad.com)
	by intranet.promwad.com with esmtpa (Exim 4.69)
	(envelope-from <ivan.kuten@promwad.com>)
	id 1KzgUF-0006mn-Ru
	for linux-wireless@vger.kernel.org; Tue, 11 Nov 2008 01:48:03 +0200
MIME-Version: 1.0
Date: Tue, 11 Nov 2008 01:47:58 +0200
From: Ivan Kuten <ivan.kuten@promwad.com>
To: linux-wireless@vger.kernel.org
Subject: rtl8187: patch adding Abocom usb id
Message-ID: <806c81b61e7dedacfda32d6638548dbb@promwad.com> (sfid-20081111_004822_219265_37EA84D0)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187: Add Abocom usb id

Signed-off-by: Ivan Kuten <ivan.kuten@promwad.com>

-------------

--- linux-2.6.28-rc3/drivers/net/wireless/rtl8187_dev.c 2008-11-10
18:53:50.000000000 +0200
+++ linux-2.6.28-rc3.new/drivers/net/wireless/rtl8187_dev.c     2008-11-10
19:02:34.000000000 +0200
@@ -48,6 +48,8 @@
        {USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
        /* Sitecom */
        {USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+       /* Abocom */
+       {USB_DEVICE(0x13d1, 0xabe6), .driver_info = DEVICE_RTL8187},
        {}
 };

--------------

Regards,
Ivan


