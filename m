Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34502 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0DZUK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas_tf: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:25 -0400
Message-Id: <1272312565-22771-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas_tf/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 3b1db84..a6b30d7 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -555,7 +555,6 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 	stats.freq = priv->cur_freq;
 	stats.band = IEEE80211_BAND_2GHZ;
 	stats.signal = prxpd->snr;
-	stats.noise = prxpd->nf;
 	/* Marvell rate index has a hole at value 4 */
 	if (prxpd->rx_rate > 4)
 		--prxpd->rx_rate;
-- 
1.6.6.1

