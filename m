Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 6/9] ath9k: Remove pointless ath9k_ps_restore() in ath_detach()
Date: Tue, 14 Jul 2009 20:17:12 -0400
Message-Id: <1247617035-15402-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 46f4a69..90cecce 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1286,7 +1286,6 @@ void ath_detach(struct ath_softc *sc)
 
 	ath9k_hw_detach(sc->sc_ah);
 	ath9k_exit_debug(sc);
-	ath9k_ps_restore(sc);
 }
 
 static int ath9k_reg_notifier(struct wiphy *wiphy,
-- 
1.6.0.6

