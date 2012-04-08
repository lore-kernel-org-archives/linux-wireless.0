Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55422 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2DHQA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 12:00:29 -0400
Received: by vbbff1 with SMTP id ff1so1884693vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 09:00:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 8 Apr 2012 18:00:28 +0200
Message-ID: <CAA2SeN+7FsyQKmCK62tzEzrHLVi6-H21wZ+bdTjS2rLDDdauCA@mail.gmail.com> (sfid-20120408_180032_758288_C0921866)
Subject: [PATCH] rtlwifi: ID for Belkin Surf N300 XR
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I added ID for Belkin Surf N300 XR wireless usb adapter to rtlwifi driver.

Regards

Lorenzo

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -340,6 +340,7 @@
 	/****** 8192CU ********/
 	{RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belcom-Sercomm*/
 	{RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belcom-Edimax*/
+	{RTL_USB_DEVICE(0x050d, 0x1004, rtl92cu_hal_cfg)}, /*Belkin-SurfN300*/
 	{RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel -Abocom*/
 	{RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
 	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
