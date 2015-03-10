Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:20591 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbbCJQtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:49:39 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 3/3] ath9k: allow 40MHz radar detection width
Date: Tue, 10 Mar 2015 17:49:31 +0100
Message-Id: <1426006171-2555-4-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150310_174946_469147_B29B2CEC)
In-Reply-To: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6c6e884..bfa4ff6 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -763,7 +763,8 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
-					BIT(NL80211_CHAN_WIDTH_20),
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40),
 	}
 #endif
 };
-- 
1.9.1

