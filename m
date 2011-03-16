Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1CPOMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:12:53 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1544936bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:12:52 -0700 (PDT)
From: Peter Lemenkov <lemenkov@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>,
	Peter Lemenkov <lemenkov@gmail.com>
Subject: [PATCH 4/4] rt2x00: Add unknown Toshiba device, mentioned in rt3572sta sources, under CONFIG_RT2800USB_UNKNOWN
Date: Wed, 16 Mar 2011 17:12:18 +0300
Message-Id: <1300284739-7797-5-git-send-email-lemenkov@gmail.com>
In-Reply-To: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3aa32fd..438e64f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -975,6 +975,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Sweex */
 	{ USB_DEVICE(0x177f, 0x0153), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x177f, 0x0313), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Toshiba */
+	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x341a), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
-- 
1.7.4

