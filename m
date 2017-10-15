Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46761 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdJOByI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Oct 2017 21:54:08 -0400
Received: by mail-oi0-f67.google.com with SMTP id n82so20150880oig.3
        for <linux-wireless@vger.kernel.org>; Sat, 14 Oct 2017 18:54:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>, kbuild-all@01.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] rtlwifi: Fix typo in if ... else if ... else construct
Date: Sat, 14 Oct 2017 20:54:02 -0500
Message-Id: <20171015015402.11217-1-Larry.Finger@lwfinger.net> (sfid-20171015_035412_303801_3C894168)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kbuild test robot reports two conditions with no effect (if == else).
These are the result of copy and paste typographical errors.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
Cc: kbuild-all@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
---

Kalle,

This material is for the 4.15 stream.

Larry
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index ea18aa7afecb..66737f6b7359 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -835,7 +835,7 @@ static u8 _rtl_get_vht_highest_n_rate(struct ieee80211_hw *hw,
 		else if ((tx_mcs_map  & 0x000c) >> 2 ==
 			IEEE80211_VHT_MCS_SUPPORT_0_8)
 			hw_rate =
-			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_2SS_MCS9];
+			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_2SS_MCS8];
 		else
 			hw_rate =
 			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_2SS_MCS9];
@@ -847,7 +847,7 @@ static u8 _rtl_get_vht_highest_n_rate(struct ieee80211_hw *hw,
 		else if ((tx_mcs_map  & 0x0003) ==
 			IEEE80211_VHT_MCS_SUPPORT_0_8)
 			hw_rate =
-			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_1SS_MCS9];
+			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_1SS_MCS8];
 		else
 			hw_rate =
 			rtlpriv->cfg->maps[RTL_RC_VHT_RATE_1SS_MCS9];
-- 
2.12.3
