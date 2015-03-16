Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from quad.pendre.co.uk ([195.137.4.79]:60722 "EHLO quad.pendre.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397AbbCPU2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 16:28:31 -0400
Message-ID: <55073A9A.3040402@elrepo.org> (sfid-20150316_213011_177937_440E59E0)
Date: Mon, 16 Mar 2015 20:18:34 +0000
From: Phil Perry <phil@elrepo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtlwifi: rtl8192cu: Add device ID for D-Link DWA-131 (Version
 B1) adapter
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the device ID for the D-Link DWA-131 (Version B1)
adapter which uses this driver.

Signed-off-by: Philip J Perry <phil@elrepo.org>

diff -Naurp a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c	2015-03-06
22:53:42.000000000 +0000
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c	2015-03-16
19:24:55.000000000 +0000
@@ -377,6 +377,7 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
 	{RTL_USB_DEVICE(0x2001, 0x3309, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
 	{RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
+	{RTL_USB_DEVICE(0x2001, 0x330d, rtl92cu_hal_cfg)}, /*D-Link*/
 	{RTL_USB_DEVICE(0x2019, 0xab2b, rtl92cu_hal_cfg)}, /*Planex -Abocom*/
 	{RTL_USB_DEVICE(0x20f4, 0x624d, rtl92cu_hal_cfg)}, /*TRENDNet*/
 	{RTL_USB_DEVICE(0x2357, 0x0100, rtl92cu_hal_cfg)}, /*TP-Link WN8200ND*/
