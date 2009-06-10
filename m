Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZFJITp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 04:19:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 10/18] ath9k: remove unused ath_rc_isvalid_txmask()
Date: Wed, 10 Jun 2009 04:19:27 -0400
Message-Id: <1244621975-1238-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
References: <1244621975-1238-1-git-send-email-lrodriguez@atheros.com>
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

