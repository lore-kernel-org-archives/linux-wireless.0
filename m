Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45981 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbYE0Ou6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 10:50:58 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	reinette.chatre@intel.com
Cc: linux-wireless@vger.kernel.org, Yi Zhu <yi.zhu@intel.com>
Subject: [PATCH 1/3] mac80211: fix a typo in ieee80211_handle_filtered_frame comment
Date: Tue, 27 May 2008 17:50:50 +0300
Message-Id: <1211899852-22712-2-git-send-email-tomas.winkler@intel.com> (sfid-20080527_165101_612641_F36CAB25)
In-Reply-To: <1211899852-22712-1-git-send-email-tomas.winkler@intel.com>
References: <1211899852-22712-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yi Zhu <yi.zhu@intel.com>

fix a typo in ieee80211_handle_filtered_frame comment

Signed-off-by: Yi Zhu <yi.zhu@intel.com>
---
 net/mac80211/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b0fddb7..7eb59b5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1340,7 +1340,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	/*
 	 * Clear the TX filter mask for this STA when sending the next
 	 * packet. If the STA went to power save mode, this will happen
-	 * happen when it wakes up for the next time.
+	 * when it wakes up for the next time.
 	 */
 	set_sta_flags(sta, WLAN_STA_CLEAR_PS_FILT);
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

