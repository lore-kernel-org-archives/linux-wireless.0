Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33061 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753435AbdBKLyq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Feb 2017 06:54:46 -0500
Received: by mail-pg0-f68.google.com with SMTP id 194so5048633pgd.0
        for <linux-wireless@vger.kernel.org>; Sat, 11 Feb 2017 03:54:46 -0800 (PST)
From: Aaryn Coutanche <aaryncoutanche@gmail.com>
To: jes.sorensen@gmail.com
Cc: Aaryn Coutanche <aaryncoutanche@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8xxxu: Add (0x2357 0x0107) to the tested devices list.
Date: Sun, 12 Feb 2017 00:54:27 +1300
Message-Id: <1486814067-9874-1-git-send-email-aaryncoutanche@gmail.com> (sfid-20170211_125455_802236_0735D6F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aaryn Coutanche <aaryncoutanche@gmail.com>

---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 3a86675..2ad2b3a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6196,6 +6196,9 @@ static struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8723au_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* Tested by Aaryn Coutanche */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0107, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 /* Tested by Myckel Habets */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0109, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
-- 
2.7.4

Signed-off-by: Aaryn Coutanche <aaryncoutanche@gmail.com>
