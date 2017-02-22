Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46867 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933888AbdBVXg1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 18:36:27 -0500
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: fix spelling mistake: "conuntry" -> "country"
Date: Wed, 22 Feb 2017 23:35:52 +0000
Message-Id: <20170222233552.8196-1-colin.king@canonical.com> (sfid-20170223_003634_771861_F3CAEF85)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in RT_TRACE message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/regd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 558c31b..1bf3eb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -435,7 +435,7 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 		channel_plan_to_country_code(rtlpriv->efuse.channel_plan);
 
 	RT_TRACE(rtlpriv, COMP_REGD, DBG_DMESG,
-		 "rtl: EEPROM regdomain: 0x%0x conuntry code: %d\n",
+		 "rtl: EEPROM regdomain: 0x%0x country code: %d\n",
 		 rtlpriv->efuse.channel_plan, rtlpriv->regd.country_code);
 
 	if (rtlpriv->regd.country_code >= COUNTRY_CODE_MAX) {
-- 
2.10.2
