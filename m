Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:34251 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdFYPn4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 11:43:56 -0400
Received: by mail-ot0-f193.google.com with SMTP id p48so9379232otc.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jun 2017 08:43:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 06/10] rtlwifi: Rename rtl_desc92_rate to rtl_desc_rate
Date: Sun, 25 Jun 2017 10:43:40 -0500
Message-Id: <20170625154344.19213-7-Larry.Finger@lwfinger.net> (sfid-20170625_174403_592963_F83F3EEF)
In-Reply-To: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
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
v2 - no changes
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
