Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50061 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2EHEAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 00:00:49 -0400
Received: by yhmm54 with SMTP id m54so4930006yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 21:00:49 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 4/4] mac80211: Add debugfs entry for mesh ht_opmode
Date: Mon,  7 May 2012 21:00:32 -0700
Message-Id: <1336449632-9057-4-git-send-email-ashok@cozybit.com> (sfid-20120508_060116_741460_F6DC500A)
In-Reply-To: <1336449632-9057-1-git-send-email-ashok@cozybit.com>
References: <1336449632-9057-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index ea0122d..7ed433c 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -509,6 +509,7 @@ IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
+IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -608,6 +609,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 	MESHPARAMS_ADD(rssi_threshold);
+	MESHPARAMS_ADD(ht_opmode);
 #undef MESHPARAMS_ADD
 }
 #endif
-- 
1.7.5.4

