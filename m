Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36127 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdFPOik (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:38:40 -0400
Received: by mail-pg0-f68.google.com with SMTP id v18so6542963pgb.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:38:40 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 1/6] rsi: add usb RS9113 chipset support
Date: Fri, 16 Jun 2017 20:05:36 +0530
Message-Id: <1497623741-2082-2-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_163843_095371_4E5F414E)
In-Reply-To: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com>
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
