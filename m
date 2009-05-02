Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZEBFR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 01:17:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: fix comment on regulatory hint processing
Date: Sat,  2 May 2009 01:17:27 -0400
Message-Id: <1241241447-1162-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9bb16d3..48db569 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1554,7 +1554,7 @@ new_request:
 	return call_crda(last_request->alpha2);
 }
 
-/* This currently only processes user and driver regulatory hints */
+/* This processes *all* regulatory hints */
 static void reg_process_hint(struct regulatory_request *reg_request)
 {
 	int r = 0;
-- 
1.6.0.6

