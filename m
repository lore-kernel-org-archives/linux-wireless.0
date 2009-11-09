Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:56166 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbZKIMjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:39:46 -0500
Received: by mail-fx0-f221.google.com with SMTP id 21so156761fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:39:51 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 02/21] mac80211: set MESH_TTL to 31
Date: Mon,  9 Nov 2009 12:39:22 +0000
Message-Id: <1257770381-7680-3-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the mesh time to live field to 31 according to draft 3.03.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index dd1c193..9948107 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -174,7 +174,7 @@ struct mesh_rmc {
 #define MESH_CFG_CMP_LEN 	(IEEE80211_MESH_CONFIG_LEN - 2)
 
 /* Default values, timeouts in ms */
-#define MESH_TTL 		5
+#define MESH_TTL 		31
 #define MESH_MAX_RETR	 	3
 #define MESH_RET_T 		100
 #define MESH_CONF_T 		100
-- 
1.5.6.5

