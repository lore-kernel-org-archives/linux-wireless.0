Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZESVuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 17:50:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath9k: set max default eirp to 20 dBm
Date: Tue, 19 May 2009 17:49:46 -0400
Message-Id: <1242769787-29467-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
References: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is always discarded anyway but lets just set this to our
safest lowest.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7fab2d4..72ead61 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -35,14 +35,14 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 #define CHAN2G(_freq, _idx)  { \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
-	.max_power = 30, \
+	.max_power = 20, \
 }
 
 #define CHAN5G(_freq, _idx) { \
 	.band = IEEE80211_BAND_5GHZ, \
 	.center_freq = (_freq), \
 	.hw_value = (_idx), \
-	.max_power = 30, \
+	.max_power = 20, \
 }
 
 /* Some 2 GHz radios are actually tunable on 2312-2732
-- 
1.6.0.6

