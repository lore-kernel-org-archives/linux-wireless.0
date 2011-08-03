Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43682 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HCTJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 15:09:56 -0400
Received: by ewy4 with SMTP id 4so565470ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 12:09:54 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Add new rt73 buffalo USB id
Date: Wed, 3 Aug 2011 21:09:49 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"Maik-Holger Freudenberg" <hhfeuer@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201108032109.50549.IvDoorn@gmail.com> (sfid-20110803_210959_116062_2C6039AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Reported-by: Maik-Holger Freudenberg <hhfeuer@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt73usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6a93939..0baeb89 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2420,6 +2420,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00d8) },
 	{ USB_DEVICE(0x0411, 0x00d9) },
+	{ USB_DEVICE(0x0411, 0x00e6) },
 	{ USB_DEVICE(0x0411, 0x00f4) },
 	{ USB_DEVICE(0x0411, 0x0116) },
 	{ USB_DEVICE(0x0411, 0x0119) },
-- 
1.7.2.3

