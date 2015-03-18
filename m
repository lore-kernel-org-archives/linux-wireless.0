Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:38066 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbbCRGRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 02:17:46 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] mac80211: fix typo in debug output
Date: Wed, 18 Mar 2015 07:17:37 +0100
Message-Id: <1426659457-1448-1-git-send-email-michael-dev@fami-braun.de> (sfid-20150318_071749_689785_B62ACB31)
In-Reply-To: <1426628001.1985.62.camel@sipsolutions.net>
References: <1426628001.1985.62.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 74f509c..62007ca 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2297,7 +2297,7 @@ int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ht_dbg(sdata,
-	       "SMSP %d requested in AP mode, sending Action frame to %d stations\n",
+	       "SMPS %d requested in AP mode, sending Action frame to %d stations\n",
 	       smps_mode, atomic_read(&sdata->u.ap.num_mcast_sta));
 
 	mutex_lock(&sdata->local->sta_mtx);
-- 
1.9.1

