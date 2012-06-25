Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab2FYXBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 19:01:14 -0400
Date: Mon, 25 Jun 2012 18:01:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: xose.vazquez@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: New USB IDs
Message-ID: <4fe8edb8.nIHkD/+vuVsWEUTA%Larry.Finger@lwfinger.net> (sfid-20120626_010118_338194_9585157C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest Realtek driver for the RTL8188CU and RTL8192CU chips adds three
new USB IDs.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -301,9 +301,11 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9041, rtl92cu_hal_cfg)}, /*NetGear WNA1000M*/
+	{RTL_USB_DEVICE(0x0bda, 0x5088, rtl92cu_hal_cfg)}, /*Thinkware-CC&C*/
 	{RTL_USB_DEVICE(0x0df6, 0x0052, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0df6, 0x005c, rtl92cu_hal_cfg)}, /*Sitecom - Edimax*/
 	{RTL_USB_DEVICE(0x0eb0, 0x9071, rtl92cu_hal_cfg)}, /*NO Brand - Etop*/
+	{RTL_USB_DEVICE(0x4856, 0x0091, rtl92cu_hal_cfg)}, /*NetweeN - Feixun*/
 	/* HP - Lite-On ,8188CUS Slim Combo */
 	{RTL_USB_DEVICE(0x103c, 0x1629, rtl92cu_hal_cfg)},
 	{RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
@@ -346,6 +348,7 @@ static struct usb_device_id rtl8192c_usb
 	{RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
 	{RTL_USB_DEVICE(0x0846, 0x9021, rtl92cu_hal_cfg)}, /*Netgear-Sercomm*/
 	{RTL_USB_DEVICE(0x0b05, 0x17ab, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
+	{RTL_USB_DEVICE(0x0bda, 0x8186, rtl92cu_hal_cfg)}, /*Realtek 92CE-VAU*/
 	{RTL_USB_DEVICE(0x0df6, 0x0061, rtl92cu_hal_cfg)}, /*Sitecom-Edimax*/
 	{RTL_USB_DEVICE(0x0e66, 0x0019, rtl92cu_hal_cfg)}, /*Hawking-Edimax*/
 	{RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
