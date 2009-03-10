Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65079 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbZCJFOD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 01:14:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 22:14:02 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18869.63009.971276.808729@gargle.gargle.HOWL> (sfid-20090310_061416_037899_6AF241D1)
Date: Tue, 10 Mar 2009 10:39:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Add spectrum management to HW capabilities
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7844f18..a8cdc51 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1583,7 +1583,8 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_PS_NULLFUNC_STACK;
+		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_SPECTRUM_MGMT;
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
-- 
1.6.1

