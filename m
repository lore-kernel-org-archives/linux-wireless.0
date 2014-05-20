Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43769 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaETTpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 15:45:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k: fixup "ath9k_htc: fix build with disabled debug"
Date: Tue, 20 May 2014 15:38:17 -0400
Message-Id: <1400614697-25844-1-git-send-email-linville@tuxdriver.com> (sfid-20140520_214517_336075_658EFA7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently Oleksij's compile testing was no better than mine initially
was... :-(

Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ca801a0130e1..09a5d72f3ff5 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -378,7 +378,7 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 #define TX_QSTAT_INC(c) do { } while (0)
 
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
-					 struct ath_rx_status *rs);
+					 struct ath_rx_status *rs)
 {
 }
 
-- 
1.9.0

