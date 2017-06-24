Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33884 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754621AbdFXBxU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 21:53:20 -0400
Received: by mail-ot0-f193.google.com with SMTP id p48so6525495otc.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 18:53:20 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/10] rtlwifi: Rename rtl_desc92_rate to rtl_desc_rate
Date: Fri, 23 Jun 2017 20:53:05 -0500
Message-Id: <20170624015309.28099-7-Larry.Finger@lwfinger.net> (sfid-20170624_035336_616384_5B38E9F4)
In-Reply-To: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
References: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This is a common enumeration, so we use a common name.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 77c3b186900e..4c6d01eb065d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -592,7 +592,7 @@ enum rtl_hal_state {
 	_HAL_STATE_START = 1,
 };
 
-enum rtl_desc92_rate {
+enum rtl_desc_rate {
 	DESC_RATE1M = 0x00,
 	DESC_RATE2M = 0x01,
 	DESC_RATE5_5M = 0x02,
-- 
2.12.3
