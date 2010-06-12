Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 14/24] ath9k: remove declarations of some nonexistant functions
Date: Sat, 12 Jun 2010 00:33:52 -0400
Message-Id: <1276317242-15540-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a0f1567..6b5a26f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -628,8 +628,6 @@ irqreturn_t ath_isr(int irq, void *dev);
 int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
-const char *ath_mac_bb_name(u32 mac_bb_version);
-const char *ath_rf_name(u16 rf_version);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			   struct ath9k_channel *ichan);
-- 
1.6.3.3

