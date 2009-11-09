Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:2277 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbZKIMkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:40:00 -0500
Received: by fg-out-1718.google.com with SMTP id d23so702887fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:40:05 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 04/21] mac80211: fix typo in a comment
Date: Mon,  9 Nov 2009 12:39:24 +0000
Message-Id: <1257770381-7680-5-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_plink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f98c8d2..4188752 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -79,7 +79,7 @@ void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 /**
  * mesh_plink_fsm_restart - restart a mesh peer link finite state machine
  *
- * @sta: mes peer link to restart
+ * @sta: mesh peer link to restart
  *
  * Locking: this function must be called holding sta->lock
  */
-- 
1.5.6.5

