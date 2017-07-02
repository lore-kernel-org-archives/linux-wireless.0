Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35739 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751996AbdGBSMx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Jul 2017 14:12:53 -0400
Received: by mail-oi0-f68.google.com with SMTP id l130so17397655oib.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Jul 2017 11:12:53 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v4 06/10] rtlwifi: Rename rtl_desc92_rate to rtl_desc_rate
Date: Sun,  2 Jul 2017 13:12:35 -0500
Message-Id: <20170702181239.17911-7-Larry.Finger@lwfinger.net> (sfid-20170702_201310_708991_F6EBACA4)
In-Reply-To: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
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
v3 - no changes
v4 - no changes
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
