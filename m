Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35994 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2EaKSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 06:18:15 -0400
Received: by pbbrp8 with SMTP id rp8so1260389pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 03:18:15 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: Add missing mesh parameter dot11MeshForwarding for debugfs
Date: Thu, 31 May 2012 18:17:30 +0800
Message-Id: <1338459450-31728-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120531_121819_745552_11621429)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/debugfs_netdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index fa62a5e..8920c4b 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -610,6 +610,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
 	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
+	MESHPARAMS_ADD(dot11MeshForwarding);
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
 	MESHPARAMS_ADD(rssi_threshold);
 	MESHPARAMS_ADD(ht_opmode);
-- 
1.7.0.4

