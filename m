Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38365 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3GHO4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:56:21 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 15/18] ath9k: announce that ath9k supports 5/10 MHz
Date: Mon,  8 Jul 2013 16:56:03 +0200
Message-Id: <1373295366-12823-16-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_165635_998786_8BB807E4)
In-Reply-To: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index bd909ba..85a5a87 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -844,6 +844,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
 
 #ifdef CONFIG_PM_SLEEP
 	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
-- 
1.7.10.4

