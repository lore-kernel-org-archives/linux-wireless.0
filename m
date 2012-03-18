Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33516 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab2CRMIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 08:08:36 -0400
Received: by wejx9 with SMTP id x9so5136426wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2012 05:08:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: remove outdated comment
Date: Sun, 18 Mar 2012 14:08:50 +0200
Message-Id: <1332072530-15466-1-git-send-email-eliad@wizery.com> (sfid-20120318_130839_274017_1E216DD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The on-oper-channel optimization was reverted,
so remove the outdated comment as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7f99551..83233fd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -102,9 +102,6 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 
 	might_sleep();
 
-	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
-	 * may need to change as well.
-	 */
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (local->scan_channel) {
 		chan = local->scan_channel;
-- 
1.7.6.401.g6a319

