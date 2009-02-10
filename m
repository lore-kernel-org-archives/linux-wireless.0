Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbZBJUeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:34:07 -0500
Message-Id: <20090210202554.050078602@sipsolutions.net> (sfid-20090210_213411_888887_F9AF4F4B)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/27] mac80211: remove stray aggregation debugfs definition
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.h |    1-
 net/mac80211/sta_info.h |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/mac80211/sta_info.h	2009-02-10 20:59:27.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-02-10 20:59:31.000000000 +0100
@@ -65,7 +65,6 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_OPERATIONAL	(HT_ADDBA_REQUESTED_MSK |	\
 					 HT_ADDBA_DRV_READY_MSK |	\
 					 HT_ADDBA_RECEIVED_MSK)
-#define HT_AGG_STATE_DEBUGFS_CTL	BIT(7)
 
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).

-- 

