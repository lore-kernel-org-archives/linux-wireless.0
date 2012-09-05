Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab2IENxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:53:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] cfg80211: add kerneldoc entry for "vht_cap"
Date: Wed,  5 Sep 2012 15:54:23 +0200
Message-Id: <1346853263-17817-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_155349_779515_4FCDD520)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c518f1..60597cf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -243,6 +243,7 @@ struct ieee80211_sta_vht_cap {
  *	rates" IE, i.e. CCK rates first, then OFDM.
  * @n_bitrates: Number of bitrates in @bitrates
  * @ht_cap: HT capabilities in this band
+ * @vht_cap: VHT capabilities in this band
  */
 struct ieee80211_supported_band {
 	struct ieee80211_channel *channels;
-- 
1.7.10.4

