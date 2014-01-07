Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaAGLLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 06:11:08 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] mac80211: clean up garbage in comment
Date: Tue,  7 Jan 2014 13:09:38 +0200
Message-Id: <1389092979-11957-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140107_121131_613732_D8B188AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not clear how this landed here.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/wpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0752f84..7ac88ff 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -127,7 +127,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		 * APs with pairwise keys should never receive Michael MIC
 		 * errors for non-zero keyidx because these are reserved for
 		 * group keys and only the AP is sending real multicast
-		 * frames in the BSS. (
+		 * frames in the BSS.
 		 */
 		return RX_DROP_UNUSABLE;
 	}
-- 
1.8.3.2

