Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:38256 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932263AbeEUV0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 17:26:53 -0400
Received: by mail-oi0-f68.google.com with SMTP id k17-v6so14314451oih.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 14:26:53 -0700 (PDT)
From: Guy Chronister <guylovesbritt@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: guychronister@outlook.com, Guy Chronister <guylovesbritt@gmail.com>
Subject: [PATCH] Added support for Dell Wireless 1537 which is an Qualcomm Atheros AR6004X with an sdio ID of 0x19. hardware ID is 0271:0419. And tested it on a Dell Venue 11 Pro 7130 with a compiled kernel.
Date: Mon, 21 May 2018 16:26:44 -0500
Message-Id: <20180521212644.7838-1-guylovesbritt@gmail.com> (sfid-20180521_232706_974343_DF8085E9)
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
