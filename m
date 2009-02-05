Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZBEQOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 11:14:06 -0500
Message-Id: <20090205161131.637416934@sipsolutions.net> (sfid-20090205_171410_190541_DE74B2A0)
References: <20090205160738.990564487@sipsolutions.net>
Date: Thu, 05 Feb 2009 17:07:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] mac80211: remove stray aggregation debugfs definition
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/sta_info.h |    1-
 net/mac80211/sta_info.h |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/mac80211/sta_info.h	2009-01-26 13:25:46.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-01-26 13:25:49.000000000 +0100
@@ -65,7 +65,6 @@ enum ieee80211_sta_info_flags {
 #define HT_AGG_STATE_OPERATIONAL	(HT_ADDBA_REQUESTED_MSK |	\
 					 HT_ADDBA_DRV_READY_MSK |	\
 					 HT_ADDBA_RECEIVED_MSK)
-#define HT_AGG_STATE_DEBUGFS_CTL	BIT(7)
 
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).

-- 

