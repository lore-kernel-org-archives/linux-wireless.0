Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51398 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab3EZOFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 May 2013 10:05:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3/3] ath9k: advertise support for active monitor interfaces
Date: Sun, 26 May 2013 16:05:07 +0200
Message-Id: <1369577107-87931-3-git-send-email-nbd@openwrt.org> (sfid-20130526_160535_169661_74EAE99F)
In-Reply-To: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
References: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c0aa4ff..86b14e8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -764,7 +764,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_SUPPORTS_RC_TABLE;
+		IEEE80211_HW_SUPPORTS_RC_TABLE |
+		IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
-- 
1.8.0.2

