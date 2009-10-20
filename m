Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51384 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZJTTQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 15:16:59 -0400
Received: by fxm18 with SMTP id 18so6807095fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 12:17:03 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] mac80211: trivial: fix spelling in mesh_hwmp
Date: Tue, 20 Oct 2009 12:17:34 -0700
Message-Id: <1256066254-26398-1-git-send-email-andrey@cozybit.com>
In-Reply-To: <20091020110735.445205d1.rdunlap@xenotime.net>
References: <20091020110735.445205d1.rdunlap@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a typo in the description of hwmp_route_info_get(), no function
changes.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e12a786..29b82e9 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -259,7 +259,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
  * @hwmp_ie: hwmp information element (PREP or PREQ)
  *
  * This function updates the path routing information to the originator and the
- * transmitter of a HWMP PREQ or PREP fram.
+ * transmitter of a HWMP PREQ or PREP frame.
  *
  * Returns: metric to frame originator or 0 if the frame should not be further
  * processed
-- 
1.5.6.3

