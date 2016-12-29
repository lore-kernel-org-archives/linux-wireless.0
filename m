Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53888 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbcL2QBX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 11:01:23 -0500
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: fix spelling mistake: "contry" -> "country"
Date: Thu, 29 Dec 2016 16:00:29 +0000
Message-Id: <20161229160029.22117-1-colin.king@canonical.com> (sfid-20161229_170151_211505_5C02F991)
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
index 6ee6bf8..558c31b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -440,7 +440,7 @@ int rtl_regd_init(struct ieee80211_hw *hw,
 
 	if (rtlpriv->regd.country_code >= COUNTRY_CODE_MAX) {
 		RT_TRACE(rtlpriv, COMP_REGD, DBG_DMESG,
-			 "rtl: EEPROM indicates invalid contry code, world wide 13 should be used\n");
+			 "rtl: EEPROM indicates invalid country code, world wide 13 should be used\n");
 
 		rtlpriv->regd.country_code = COUNTRY_CODE_WORLD_WIDE_13;
 	}
-- 
2.10.2
