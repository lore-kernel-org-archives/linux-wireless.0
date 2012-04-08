Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57864 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab2DHSMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 14:12:35 -0400
Received: by vbbff1 with SMTP id ff1so1912921vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 11:12:35 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 8 Apr 2012 20:12:35 +0200
Message-ID: <CAA2SeNKqQQehes3uG3viOLRavcti0A2HbxNC1X26-bptzXyU+w@mail.gmail.com> (sfid-20120408_201239_449702_C7C4AD27)
Subject: [PATCH v2] rtlwifi: support for Belkin Surf N300 XR
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added support for Belkin Surf N300 XR wireless usb adapter to rtlwifi driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -338,6 +338,7 @@
 	{RTL_USB_DEVICE(0x2019, 0x1201, rtl92cu_hal_cfg)}, /*Planex-Vencer*/

 	/****** 8192CU ********/
+	{RTL_USB_DEVICE(0x050d, 0x1004, rtl92cu_hal_cfg)}, /*Belcom-SurfN300*/
 	{RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belcom-Sercomm*/
 	{RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belcom-Edimax*/
 	{RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel -Abocom*/
