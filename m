Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54982 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaEBOkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 10:40:21 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: luciano.coelho@intel.com, johannes.berg@intel.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] cfg80211/mac80211: Fix warning on make xmldocs caused by cfg80211.h
Date: Fri,  2 May 2014 23:39:57 +0900
Message-Id: <1399041597-27409-2-git-send-email-standby24x7@gmail.com> (sfid-20140502_164036_772172_A38817A4)
In-Reply-To: <1399041597-27409-1-git-send-email-standby24x7@gmail.com>
References: <1399041597-27409-1-git-send-email-standby24x7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following error messages caused by wrong description.

Warning(include/net/cfg80211.h:461): No description found
for parameter 'nl80211_iftype'

Change "iftype" to "nl80211_iftype" fix the errors.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7eae46c..695c562 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -452,7 +452,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
  * cfg80211_chandef_dfs_required - checks if radar detection is required
  * @wiphy: the wiphy to validate against
  * @chandef: the channel definition to check
- * @iftype: the interface type as specified in &enum nl80211_iftype
+ * @nl80211_iftype: the interface type as specified in &enum nl80211_iftype
  * Returns:
  *	1 if radar detection is required, 0 if it is not, < 0 on error
  */
-- 
2.0.0.rc1.15.g7e76a2f

