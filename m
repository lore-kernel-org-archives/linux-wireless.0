Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46820 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbdEBHdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 03:33:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix multi scheduled scan kernel-doc
Date: Tue,  2 May 2017 09:33:40 +0200
Message-Id: <20170502073340.13002-1-johannes@sipsolutions.net> (sfid-20170502_093400_048733_D5093CF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Replace @results_wk with @report_results, which was missed
in an earlier patch between revisions thereof.

Fixes: b34939b98369 ("cfg80211: add request id to cfg80211_sched_scan_*() api")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6e90f1a4950f..561989142f34 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1666,7 +1666,7 @@ struct cfg80211_bss_select_adjust {
  * 	(others are filtered out).
  *	If ommited, all results are passed.
  * @n_match_sets: number of match sets
- * @results_wk: worker for processing results notification.
+ * @report_results: indicates that results were reported for this request
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @scan_start: start time of the scheduled scan
-- 
2.11.0
