Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1CPOMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:12:49 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1544936bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:12:49 -0700 (PDT)
From: Peter Lemenkov <lemenkov@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>,
	Peter Lemenkov <lemenkov@gmail.com>
Subject: [PATCH 1/4] rt2x00: Add rt2870 device id
Date: Wed, 16 Mar 2011 17:12:15 +0300
Message-Id: <1300284739-7797-2-git-send-email-lemenkov@gmail.com>
In-Reply-To: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ID for Asus USB-N11 Wi-FI adapter. Tested by me.

Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 197a36c..03a5308 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -719,6 +719,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -913,7 +914,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1790), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.7.4

