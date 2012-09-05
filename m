Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2IEOyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:54:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Hila Gonen <hila.gonen@intel.com>
Subject: [PATCH] cfg80211: fix indentation
Date: Wed,  5 Sep 2012 16:54:41 +0200
Message-Id: <1346856881-17246-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_165411_389594_CAD1B3D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hila Gonen <hila.gonen@intel.com>

checkpatch pointed out an issue, fix it.

Signed-off-by: Hila Gonen <hila.gonen@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 848523a..9730c98 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -815,7 +815,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 		return NULL;
 
 	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
-	            (signal < 0 || signal > 100)))
+		    (signal < 0 || signal > 100)))
 		return NULL;
 
 	if (WARN_ON(len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
-- 
1.7.10.4

