Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34274 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdFBOPf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:35 -0400
Received: by mail-pf0-f196.google.com with SMTP id w69so11905603pfk.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:35 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 1/6] rsi: add usb RS9113 chipset support
Date: Fri,  2 Jun 2017 19:43:00 +0530
Message-Id: <1496412785-8720-2-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161538_285076_048219EA)
In-Reply-To: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

usb device id and vendor id for RS9113 chipset are included.
So it can be used through usb interface.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index f5de693..bcd7f45 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -666,6 +666,7 @@ static const struct usb_device_id rsi_dev_table[] = {
 	{ USB_DEVICE(0x041B, 0x0301) },
 	{ USB_DEVICE(0x041B, 0x0201) },
 	{ USB_DEVICE(0x041B, 0x9330) },
+	{ USB_DEVICE(0x1618, 0x9113) },
 	{ /* Blank */},
 };
 
-- 
2.7.4
