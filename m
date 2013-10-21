Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:55191 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3JURCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:02:21 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm4so4363316wib.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:02:20 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] cfg80211: fix nl80211.h documentation for DFS enum states
Date: Mon, 21 Oct 2013 19:02:14 +0200
Message-Id: <1382374934-24188-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_190224_681096_233A8ECD)
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

