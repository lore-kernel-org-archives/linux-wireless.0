Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:53354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYCOUjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 16:39:02 -0400
Received: by fg-out-1718.google.com with SMTP id l27so857676fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2008 13:39:01 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: PATCH 2/2] rt2x00: Add id for Corega CG-WLUSB2GPX
Date: Sat, 15 Mar 2008 21:38:29 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200803152137.51308.IvDoorn@gmail.com>
In-Reply-To: <200803152137.51308.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803152138.29450.IvDoorn@gmail.com> (sfid-20080315_203919_821872_D085EF13)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masakazu Mokuno <mokuno@sm.sony.co.jp>

This adds the id for Corega CG-WLUSB2GPX.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b50f476..83f8287 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2163,6 +2163,8 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x1371, 0x9032), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c22), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Corega */
+	{ USB_DEVICE(0x07aa, 0x002e), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c03), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c04), USB_DEVICE_DATA(&rt73usb_ops) },
-- 
1.5.4.3

