Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47846 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZJTSDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 14:03:47 -0400
Received: by fxm18 with SMTP id 18so6726852fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 11:03:51 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211: trivial: fix spelling in mesh_hwmp
Date: Tue, 20 Oct 2009 11:04:22 -0700
Message-Id: <1256061862-23368-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a couple of typos in the description of hwmp_route_info_get(), no
functional changes.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e12a786..c300911 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -259,12 +259,12 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
  * @hwmp_ie: hwmp information element (PREP or PREQ)
  *
  * This function updates the path routing information to the originator and the
- * transmitter of a HWMP PREQ or PREP fram.
+ * transmitter of a HWMP PREQ or PREP frame.
  *
  * Returns: metric to frame originator or 0 if the frame should not be further
  * processed
  *
- * Notes: this function is the only place (besides user-provided info) where
+ * Notes: this function is the only place (beside user-provided info) where
  * path routing information is updated.
  */
 static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
-- 
1.5.6.3

