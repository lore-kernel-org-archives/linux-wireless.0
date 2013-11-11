Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45540 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3KKMaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 07:30:08 -0500
Received: by mail-wg0-f47.google.com with SMTP id y10so936546wgg.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 04:30:07 -0800 (PST)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH] mac80211_hwsim: claim CCK support for HT clients
Date: Mon, 11 Nov 2013 13:29:33 +0100
Message-Id: <1384172973-21638-1-git-send-email-karl.beldan@gmail.com> (sfid-20131111_133012_120022_69FA3EF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2cd3f54..bb737bb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2305,7 +2305,8 @@ static int __init init_mac80211_hwsim(void)
 			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			    IEEE80211_HW_AMPDU_AGGREGATION |
 			    IEEE80211_HW_WANT_MONITOR_VIF |
-			    IEEE80211_HW_QUEUE_CONTROL;
+			    IEEE80211_HW_QUEUE_CONTROL |
+			    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 		if (rctbl)
 			hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
 
-- 
1.8.2

