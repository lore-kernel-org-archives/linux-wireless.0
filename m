Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40025 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3EISKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:10:49 -0400
From: a@pandem0nium
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 7/8] ath9k: announce that ath9k supports 5/10 MHz
Date: Thu,  9 May 2013 20:10:35 +0200
Message-Id: <1368123036-22721-8-git-send-email-a> (sfid-20130509_201107_640063_EE5B8247)
In-Reply-To: <1368123036-22721-1-git-send-email-a>
References: <1368123036-22721-1-git-send-email-a>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0959729..30c3ddf 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -794,6 +794,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
 
 #ifdef CONFIG_PM_SLEEP
 
-- 
1.7.10.4

