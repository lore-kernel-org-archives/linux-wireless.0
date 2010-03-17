Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39517 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0CQTpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 15:45:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: correct typos in "unavailable upon resume" warning
Date: Wed, 17 Mar 2010 15:33:38 -0400
Message-Id: <1268854418-6662-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/util.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c453226..a9d9098 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1097,8 +1097,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		 */
 		res = drv_start(local);
 		if (res) {
-			WARN(local->suspended, "Harware became unavailable "
-			     "upon resume. This is could be a software issue"
+			WARN(local->suspended, "Hardware became unavailable "
+			     "upon resume. This is could be a software issue "
 			     "prior to suspend or a hardware issue\n");
 			return res;
 		}
-- 
1.6.2.5

