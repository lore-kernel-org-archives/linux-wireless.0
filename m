Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40169 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab1DRNgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:11 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833906fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:10 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/23] rt2x00: Add USB IDs.
Date: Mon, 18 Apr 2011 15:32:33 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181531.51867.IvDoorn@gmail.com> <201104181532.14262.IvDoorn@gmail.com>
In-Reply-To: <201104181532.14262.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181532.34476.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Add USB IDs that are listed in the latest Ralink Windows and/or Linux drivers.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6f7c161..fd8aa99 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -775,6 +775,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07b8, 0x3072) },
 	{ USB_DEVICE(0x1482, 0x3c09) },
 	/* AirTies */
+	{ USB_DEVICE(0x1eda, 0x2012) },
 	{ USB_DEVICE(0x1eda, 0x2310) },
 	/* Allwin */
 	{ USB_DEVICE(0x8516, 0x2070) },
@@ -933,6 +934,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x0042) },
 	{ USB_DEVICE(0x0df6, 0x0047) },
 	{ USB_DEVICE(0x0df6, 0x0048) },
+	{ USB_DEVICE(0x0df6, 0x0051) },
+	{ USB_DEVICE(0x0df6, 0x005f) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618) },
 	{ USB_DEVICE(0x083a, 0x7511) },
@@ -963,6 +966,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0586, 0x3416) },
 	{ USB_DEVICE(0x0586, 0x3418) },
 	{ USB_DEVICE(0x0586, 0x341e) },
+	{ USB_DEVICE(0x0586, 0x343e) },
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370) },
@@ -998,6 +1002,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	 * Unclear what kind of devices these are (they aren't supported by the
 	 * vendor linux driver).
 	 */
+	/* Abocom */
+	{ USB_DEVICE(0x07b8, 0x3073) },
+	{ USB_DEVICE(0x07b8, 0x3074) },
 	/* Alpha Networks */
 	{ USB_DEVICE(0x14b2, 0x3c08) },
 	{ USB_DEVICE(0x14b2, 0x3c11) },
@@ -1005,14 +1012,17 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0e0b, 0x9031) },
 	{ USB_DEVICE(0x0e0b, 0x9041) },
 	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x166a) },
 	{ USB_DEVICE(0x0b05, 0x1760) },
 	{ USB_DEVICE(0x0b05, 0x1761) },
 	{ USB_DEVICE(0x0b05, 0x1790) },
+	{ USB_DEVICE(0x0b05, 0x179d) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262) },
 	{ USB_DEVICE(0x13d3, 0x3284) },
 	{ USB_DEVICE(0x13d3, 0x3322) },
 	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x1003) },
 	{ USB_DEVICE(0x050d, 0x825a) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x012e) },
@@ -1028,20 +1038,29 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c13) },
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c17) },
+	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x4085) },
+	{ USB_DEVICE(0x7392, 0x7722) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */
 	{ USB_DEVICE(0x1044, 0x800c) },
+	/* Huawei */
+	{ USB_DEVICE(0x148f, 0xf101) },
+	/* I-O DATA */
+	{ USB_DEVICE(0x04bb, 0x094b) },
 	/* LevelOne */
 	{ USB_DEVICE(0x1740, 0x0605) },
 	{ USB_DEVICE(0x1740, 0x0615) },
 	/* Linksys */
 	{ USB_DEVICE(0x1737, 0x0077) },
 	{ USB_DEVICE(0x1737, 0x0078) },
+	/* Logitec */
+	{ USB_DEVICE(0x0789, 0x0168) },
+	{ USB_DEVICE(0x0789, 0x0169) },
 	/* Motorola */
 	{ USB_DEVICE(0x100d, 0x9032) },
 	/* Ovislink */
@@ -1056,6 +1075,15 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x2019, 0xab24) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259) },
+	/* RadioShack */
+	{ USB_DEVICE(0x08b9, 0x1197) },
+	/* Sitecom */
+	{ USB_DEVICE(0x0df6, 0x003c) },
+	{ USB_DEVICE(0x0df6, 0x004a) },
+	{ USB_DEVICE(0x0df6, 0x004d) },
+	{ USB_DEVICE(0x0df6, 0x0053) },
+	{ USB_DEVICE(0x0df6, 0x0060) },
+	{ USB_DEVICE(0x0df6, 0x0062) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },
-- 
1.7.2.3

