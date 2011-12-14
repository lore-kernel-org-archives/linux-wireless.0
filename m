Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47588 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1LNOQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 09:16:26 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 1/2] mac80211: remove an unnecessary paraenthesis
Date: Wed, 14 Dec 2011 19:46:07 +0530
Message-ID: <1323872168-6831-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111214_151629_163437_8137C690)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 09019d1..67a6be1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -819,7 +819,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	}
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
+	    !(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		netif_tx_stop_all_queues(sdata->dev);
 
 		if (drv_tx_frames_pending(local))
-- 
1.7.0.4

