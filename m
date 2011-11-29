Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32146 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1K2NwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 08:52:02 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/1] mac80211: remove unused function declaration
Date: Tue, 29 Nov 2011 19:21:53 +0530
Message-ID: <1322574713-12993-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_145212_819401_D62F15FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/sta_info.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6280e8b..a83e514 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -497,7 +497,6 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
  */
 int sta_info_insert(struct sta_info *sta);
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
-int sta_info_insert_atomic(struct sta_info *sta);
 int sta_info_reinsert(struct sta_info *sta);
 
 int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
-- 
1.7.0.4

