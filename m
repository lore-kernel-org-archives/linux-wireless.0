Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GIMtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 08:49:18 -0400
Message-Id: <20110709124854.852223800@sipsolutions.net> (sfid-20110709_144929_395056_74B088C1)
Date: Sat, 09 Jul 2011 14:48:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: fix docbook
References: <20110709124829.025946360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Looks like I forgot to document the "gfp" parameter
to cfg80211_gtk_rekey_notify, add it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/cfg80211.h	2011-07-09 14:42:30.000000000 +0200
+++ b/include/net/cfg80211.h	2011-07-09 14:42:35.000000000 +0200
@@ -3055,6 +3055,7 @@ void cfg80211_cqm_pktloss_notify(struct
  * @dev: network device
  * @bssid: BSSID of AP (to avoid races)
  * @replay_ctr: new replay counter
+ * @gfp: allocation flags
  */
 void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
 			       const u8 *replay_ctr, gfp_t gfp);


