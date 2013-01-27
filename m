Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54071 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3A0Wkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 17:40:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH NEXT] rtlwifi: Eliminate two empty routines
Date: Sun, 27 Jan 2013 16:40:34 -0600
Message-Id: <1359326434-16093-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130127_234058_189540_A9521813)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rc.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index c1e065f..204f46c 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -217,19 +217,6 @@ static void rtl_tx_status(void *ppriv,
 	}
 }
 
-static void rtl_rate_init(void *ppriv,
-			  struct ieee80211_supported_band *sband,
-			  struct ieee80211_sta *sta, void *priv_sta)
-{
-}
-
-static void rtl_rate_update(void *ppriv,
-			    struct ieee80211_supported_band *sband,
-			    struct ieee80211_sta *sta, void *priv_sta,
-			    u32 changed)
-{
-}
-
 static void *rtl_rate_alloc(struct ieee80211_hw *hw,
 		struct dentry *debugfsdir)
 {
@@ -274,8 +261,6 @@ static struct rate_control_ops rtl_rate_ops = {
 	.free = rtl_rate_free,
 	.alloc_sta = rtl_rate_alloc_sta,
 	.free_sta = rtl_rate_free_sta,
-	.rate_init = rtl_rate_init,
-	.rate_update = rtl_rate_update,
 	.tx_status = rtl_tx_status,
 	.get_rate = rtl_get_rate,
 };
-- 
1.8.1

