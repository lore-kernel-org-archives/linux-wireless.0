Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42823 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3JGX2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 19:28:02 -0400
Received: by mail-ie0-f172.google.com with SMTP id x13so17943529ief.17
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 16:28:02 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] cfg80211: fix nl80211.h documentation for DFS enum states
Date: Mon,  7 Oct 2013 16:27:55 -0700
Message-Id: <1381188475-5195-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131008_012807_768458_043630FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The names are prefixed incorrectly on the documentation.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/uapi/linux/nl80211.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 71b519f..6ab79ea 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3860,11 +3860,11 @@ enum nl80211_radar_event {
  *
  * Channel states used by the DFS code.
  *
- * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
+ * @NL80211_DFS_USABLE: The channel can be used, but channel availability
  *	check (CAC) must be performed before using it for AP or IBSS.
- * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
+ * @NL80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
  *	is therefore marked as not available.
- * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
+ * @NL80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
  */
 
 enum nl80211_dfs_state {
-- 
1.8.4.rc3

