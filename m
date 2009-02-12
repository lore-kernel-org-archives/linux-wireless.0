Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2871 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975AbZBLSjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/6] ath9k: remove prototype for ath9k_regd_get_current_country
Date: Thu, 12 Feb 2009 13:38:57 -0500
Message-Id: <1234463938-1350-6-git-send-email-me@bobcopeland.com> (sfid-20090212_193924_023329_9C638A98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_regd_get_current_country() doesn't exist.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/regd.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index f74f8ff..d48160d 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -242,7 +242,5 @@ int ath9k_regd_init(struct ath_hw *ah);
 bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah);
 u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan);
 int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
-void ath9k_regd_get_current_country(struct ath_hw *ah,
-				    struct ath9k_country_entry *ctry);
 
 #endif
-- 
1.6.0.6


