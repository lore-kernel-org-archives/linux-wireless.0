Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46454 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3HLJpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 01/15] ath9k: Add MAX_AMSDU to supported HT capabilities
Date: Mon, 12 Aug 2013 15:11:28 +0530
Message-Id: <1376300502-2741-2-git-send-email-sujith@msujith.org> (sfid-20130812_114526_652478_640F88DA)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3b56c2e..6c1875e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -258,7 +258,8 @@ static void setup_ht_cap(struct ath_softc *sc,
 	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 		       IEEE80211_HT_CAP_SM_PS |
 		       IEEE80211_HT_CAP_SGI_40 |
-		       IEEE80211_HT_CAP_DSSSCCK40;
+		       IEEE80211_HT_CAP_DSSSCCK40 |
+		       IEEE80211_HT_CAP_MAX_AMSDU;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_LDPC)
 		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
-- 
1.8.3.4

