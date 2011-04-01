Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33673 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab1DAPgU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 11:36:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 08:35:55 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] mac80211: remove few obsolete flags
Date: Fri, 1 Apr 2011 21:06:13 +0530
Message-ID: <1301672173-18984-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/mlme.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 64d92d5..865fed4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -90,20 +90,11 @@ enum rx_mgmt_action {
 	/* no action required */
 	RX_MGMT_NONE,
 
-	/* caller must call cfg80211_send_rx_auth() */
-	RX_MGMT_CFG80211_AUTH,
-
-	/* caller must call cfg80211_send_rx_assoc() */
-	RX_MGMT_CFG80211_ASSOC,
-
 	/* caller must call cfg80211_send_deauth() */
 	RX_MGMT_CFG80211_DEAUTH,
 
 	/* caller must call cfg80211_send_disassoc() */
 	RX_MGMT_CFG80211_DISASSOC,
-
-	/* caller must tell cfg80211 about internal error */
-	RX_MGMT_CFG80211_ASSOC_ERROR,
 };
 
 /* utils */
-- 
1.7.0.4

