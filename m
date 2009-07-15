Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbZGOAO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:28 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 09/21] ath9k: remove unused ath_rc_isvalid_txmask()
Date: Tue, 14 Jul 2009 20:14:01 -0400
Message-Id: <1247616853-11221-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index c8f800e..b0e3702 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -454,13 +454,6 @@ static inline void ath_rc_set_valid_txmask(struct ath_rate_priv *ath_rc_priv,
 	ath_rc_priv->valid_rate_index[index] = valid_tx_rate ? 1 : 0;
 }
 
-static inline int ath_rc_isvalid_txmask(struct ath_rate_priv *ath_rc_priv,
-					u8 index)
-{
-	ASSERT(index <= ath_rc_priv->rate_table_size);
-	return ath_rc_priv->valid_rate_index[index];
-}
-
 static inline
 int ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
 				struct ath_rate_priv *ath_rc_priv,
-- 
1.6.0.6

