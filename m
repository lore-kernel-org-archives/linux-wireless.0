Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:43906 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab2EGJWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:22:09 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] [trivial] nl80211: fix typos in comments
Date: Mon,  7 May 2012 11:21:59 +0200
Message-Id: <1336382519-6093-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120507_112212_430533_75D084EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 include/linux/nl80211.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2540e86..f296a64 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1994,9 +1994,9 @@ enum nl80211_reg_rule_flags {
  * enum nl80211_dfs_regions - regulatory DFS regions
  *
  * @NL80211_DFS_UNSET: Country has no DFS master region specified
- * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
- * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
- * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
+ * @NL80211_DFS_FCC: Country follows DFS master rules from FCC
+ * @NL80211_DFS_ETSI: Country follows DFS master rules from ETSI
+ * @NL80211_DFS_JP: Country follows DFS master rules from JP/MKK/Telec
  */
 enum nl80211_dfs_regions {
 	NL80211_DFS_UNSET	= 0,
-- 
1.7.4.1

