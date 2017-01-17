Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751391AbdAQX3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 18:29:41 -0500
From: Jes.Sorensen@gmail.com
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] rtl8xxxu: Add USB ID for D-Link DWA-131 rev E1 (rtl8192eu)
Date: Tue, 17 Jan 2017 18:18:54 -0500
Message-Id: <20170117231856.5075-4-Jes.Sorensen@gmail.com> (sfid-20170118_003535_365619_050C3D72)
In-Reply-To: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
References: <20170117231856.5075-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Axel Köllhofer <AxelKoellhofer@web.de>

This was tested by David Patiño.

Reported-by: David Patiño <davidpatino82@gmail.com>
Signed-off-by: Axel Köllhofer <AxelKoellhofer@web.de>
Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 016ea24..a8386f4 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6200,6 +6200,9 @@ static struct usb_device_id dev_table[] = {
 /* TP-Link TL-WN822N v4 */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0108, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* D-Link DWA-131 rev E1, tested by David Patiño */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3319, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 /* Tested by Myckel Habets */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0109, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
-- 
2.7.4
