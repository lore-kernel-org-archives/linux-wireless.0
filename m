Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36423 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764354AbdEYRsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:48:24 -0400
Received: by mail-oi0-f68.google.com with SMTP id w138so38629152oiw.3
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:48:23 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 4/7] rtlwifi: btcoex: 92e: rename function that was missing to be consistent
Date: Thu, 25 May 2017 12:48:11 -0500
Message-Id: <20170525174814.25005-5-Larry.Finger@lwfinger.net> (sfid-20170525_194903_001098_F5B137EC)
In-Reply-To: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
References: <20170525174814.25005-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

rename the function name to be consistent with other btcoex functions

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 9015512ed647..44c25724529e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -3194,7 +3194,7 @@ void ex_btc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	btc8192e2ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
+void ex_btc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
-- 
2.12.0
