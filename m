Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46658 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbXI3Six (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:38:53 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 02/26] at76_usb: Fix some device names in the device table
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:38:51 -0400
Message-ID: <20070930183851.23921.50478.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add vendor where it's missing.  Use spelling preferred by the vendors.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   40 ++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 9ef401e..99b120a 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -70,33 +70,35 @@ static struct usb_device_id dev_table[] = {
 	{USB_DEVICE(0x03eb, 0x7603), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Linksys WUSB11 v2.1/v2.6 */
 	{USB_DEVICE(0x066b, 0x2211), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* Netgear MA 101 Rev. A */
+	/* Netgear MA101 rev. A */
 	{USB_DEVICE(0x0864, 0x4100), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* Tekram U-300C / Allnet ALL0193 */
+	/* Tekram U300C / Allnet ALL0193 */
 	{USB_DEVICE(0x0b3b, 0x1612), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* HP HN210W PKW-J7801A */
+	/* HP HN210W J7801A */
 	{USB_DEVICE(0x03f0, 0x011c), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Sitecom/Z-Com/Zyxel M4Y-750 */
 	{USB_DEVICE(0x0cde, 0x0001), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Dynalink/Askey WLL013 (intersil) */
 	{USB_DEVICE(0x069a, 0x0320), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* EZ connect 11Mpbs Wireless USB Adapter SMC2662W (v1) */
+	/* EZ connect 11Mpbs Wireless USB Adapter SMC2662W v1 */
 	{USB_DEVICE(0x0d5c, 0xa001), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* AWL-300 */
+	/* BenQ AWL300 */
 	{USB_DEVICE(0x04a5, 0x9000), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* AWU-120, Compex WLU11 */
+	/* Addtron AWU-120, Compex WLU11 */
 	{USB_DEVICE(0x05dd, 0xff31), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* AP310 AnyPoint II USB */
+	/* Intel AP310 AnyPoint II USB */
 	{USB_DEVICE(0x8086, 0x0200), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Dynalink L11U */
 	{USB_DEVICE(0x0d8e, 0x7100), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* Arescom WL-210, FCC id 07J-GL2411USB */
 	{USB_DEVICE(0x0d8e, 0x7110), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* IO-DATA WN-B11/USB */
+	/* I-O DATA WN-B11/USB */
 	{USB_DEVICE(0x04bb, 0x0919), USB_DEVICE_DATA(BOARD_503_ISL3861)},
 	/* BT Voyager 1010 */
 	{USB_DEVICE(0x069a, 0x0821), USB_DEVICE_DATA(BOARD_503_ISL3861)},
-	/* at76c503-i3863 */
+	/*
+	 * at76c503-i3863
+	 */
 	/* Generic AT76C503/3863 device */
 	{USB_DEVICE(0x03eb, 0x7604), USB_DEVICE_DATA(BOARD_503_ISL3863)},
 	/* Samsung SWL-2100U */
@@ -112,21 +114,21 @@ static struct usb_device_id dev_table[] = {
 	{USB_DEVICE(0x077b, 0x2219), USB_DEVICE_DATA(BOARD_503)},
 	/* Network Everywhere NWU11B */
 	{USB_DEVICE(0x077b, 0x2227), USB_DEVICE_DATA(BOARD_503)},
-	/* Netgear MA 101 Rev. B */
+	/* Netgear MA101 rev. B */
 	{USB_DEVICE(0x0864, 0x4102), USB_DEVICE_DATA(BOARD_503)},
-	/* DWL-120 rev. E */
+	/* D-Link DWL-120 rev. E */
 	{USB_DEVICE(0x2001, 0x3200), USB_DEVICE_DATA(BOARD_503)},
 	/* Actiontec 802UAT1, HWU01150-01UK */
 	{USB_DEVICE(0x1668, 0x7605), USB_DEVICE_DATA(BOARD_503)},
 	/* AirVast W-Buddie WN210 */
 	{USB_DEVICE(0x03eb, 0x4102), USB_DEVICE_DATA(BOARD_503)},
-	/* XH1153 802.11b USB adapter */
+	/* Dick Smith Electronics XH1153 802.11b USB adapter */
 	{USB_DEVICE(0x1371, 0x5743), USB_DEVICE_DATA(BOARD_503)},
-	/* WL-200U */
+	/* FiberLine FL-WL200U */
 	{USB_DEVICE(0x1371, 0x0002), USB_DEVICE_DATA(BOARD_503)},
-	/* BenQ AWL-400 USB stick */
+	/* BenQ AWL400 USB stick */
 	{USB_DEVICE(0x04a5, 0x9001), USB_DEVICE_DATA(BOARD_503)},
-	/* 3COM 3CRSHEW696 */
+	/* 3Com 3CRSHEW696 */
 	{USB_DEVICE(0x0506, 0x0a01), USB_DEVICE_DATA(BOARD_503)},
 	/* Siemens Santis ADSL WLAN USB adapter WLL 013 */
 	{USB_DEVICE(0x0681, 0x001b), USB_DEVICE_DATA(BOARD_503)},
@@ -143,9 +145,9 @@ static struct usb_device_id dev_table[] = {
 	/*
 	 * at76c503-rfmd-acc
 	 */
-	/* SMC 2664W */
+	/* SMC2664W */
 	{USB_DEVICE(0x083a, 0x3501), USB_DEVICE_DATA(BOARD_503_ACC)},
-	/* Belkin F5D6050, SMC 2662W v2, SMC 2662W-AR */
+	/* Belkin F5D6050, SMC2662W v2, SMC2662W-AR */
 	{USB_DEVICE(0x0d5c, 0xa002), USB_DEVICE_DATA(BOARD_503_ACC)},
 	/*
 	 * at76c505-rfmd
@@ -157,9 +159,9 @@ static struct usb_device_id dev_table[] = {
 	 */
 	/* Generic AT76C505/RFMD, OvisLink WL-1130USB */
 	{USB_DEVICE(0x03eb, 0x7613), USB_DEVICE_DATA(BOARD_505_2958)},
-	/* Fiberline WL-240U */
+	/* Fiberline FL-WL240U */
 	{USB_DEVICE(0x1371, 0x0014), USB_DEVICE_DATA(BOARD_505_2958)},
-	/* CNet CNUSB 611G */
+	/* CNet CNUSB-611G */
 	{USB_DEVICE(0x1371, 0x0013), USB_DEVICE_DATA(BOARD_505_2958)},
 	/* Linksys WUSB11 v2.8 */
 	{USB_DEVICE(0x1915, 0x2233), USB_DEVICE_DATA(BOARD_505_2958)},
