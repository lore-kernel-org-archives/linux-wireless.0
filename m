Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38833 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1CPOMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:12:50 -0400
Received: by bwz15 with SMTP id 15so1545094bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:12:49 -0700 (PDT)
From: Peter Lemenkov <lemenkov@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>,
	Peter Lemenkov <lemenkov@gmail.com>
Subject: [PATCH 3/4] rt2x00: Add 2L Central Europe BV 8070 under CONFIG_RT2800USB_UNKNOWN
Date: Wed, 16 Mar 2011 17:12:17 +0300
Message-Id: <1300284739-7797-4-git-send-email-lemenkov@gmail.com>
In-Reply-To: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 1f2ea95..3aa32fd 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -937,6 +937,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c13), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c15), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c17), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Edimax */
+	{ USB_DEVICE(0x7392, 0x4085), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gemtek */
-- 
1.7.4

