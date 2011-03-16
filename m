Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38833 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1CPOM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:12:56 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1545094bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:12:55 -0700 (PDT)
From: Peter Lemenkov <lemenkov@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>,
	Peter Lemenkov <lemenkov@gmail.com>
Subject: [PATCH 2/4] rt2x00: Add Planex Communications, Inc. RT8070 under CONFIG_RT2800USB_UNKNOWN
Date: Wed, 16 Mar 2011 17:12:16 +0300
Message-Id: <1300284739-7797-3-git-send-email-lemenkov@gmail.com>
In-Reply-To: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 03a5308..1f2ea95 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -961,6 +961,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1d4d, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x0011), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
+	{ USB_DEVICE(0x2019, 0x5201), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x2019, 0xab24), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.7.4

