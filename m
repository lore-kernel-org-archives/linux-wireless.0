Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39744 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3KETW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:58 -0500
Received: by mail-pd0-f176.google.com with SMTP id g10so8903225pdj.7
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:57 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 10/17] mac80211: remove unused mesh_mgmt_ies_add() prototype
Date: Tue,  5 Nov 2013 11:16:58 -0800
Message-Id: <1383679025-7150-10-git-send-email-thomas@cozybit.com> (sfid-20131105_202304_426628_B051FFFE)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Said function was removed some time ago.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2bc7fd2..3f867e5 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -215,8 +215,6 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 			struct ieee802_11_elems *ie);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
-void mesh_mgmt_ies_add(struct ieee80211_sub_if_data *sdata,
-		       struct sk_buff *skb);
 int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb);
 int mesh_add_meshid_ie(struct ieee80211_sub_if_data *sdata,
-- 
1.8.4.rc3

