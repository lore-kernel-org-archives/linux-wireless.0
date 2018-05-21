Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:42588 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbeEUQ2x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 12:28:53 -0400
Received: by mail-ot0-f195.google.com with SMTP id l13-v6so17493834otk.9
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 09:28:52 -0700 (PDT)
From: Guy Chronister <guylovesbritt@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: guychronister@outlook.com, Guy Chronister <guylovesbritt@gmail.com>
Subject: [PATCH] Added Dell Wireless 1537 Ath6kl sdio card (0x19) to the list.
Date: Mon, 21 May 2018 11:28:45 -0500
Message-Id: <20180521162845.5793-1-guylovesbritt@gmail.com> (sfid-20180521_182856_516500_035D7174)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Guy Chronister <guylovesbritt@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 2195b1b7a8a6..bb50680580f3 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1415,6 +1415,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x1))},
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x2))},
 	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x18))},
+	{SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x19))},
 	{},
 };
 
-- 
2.17.0
