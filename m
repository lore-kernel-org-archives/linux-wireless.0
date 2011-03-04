Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45779 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab1CDDLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:11:52 -0500
Received: by gyh20 with SMTP id 20so654114gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:11:51 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH 2/7] mac80211: New constant definitions for SAE
Date: Thu,  3 Mar 2011 19:11:42 -0800
Message-Id: <1299208307-9428-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4e0990b..6adaa58 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1817,6 +1817,7 @@ enum nl80211_bss_status {
  * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
  * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
  * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
+ * @NL80211_AUTHTYPE_SAE: Simultaneous Authentication of Equals
  * @__NL80211_AUTHTYPE_NUM: internal
  * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
  * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by
@@ -1828,6 +1829,7 @@ enum nl80211_auth_type {
 	NL80211_AUTHTYPE_SHARED_KEY,
 	NL80211_AUTHTYPE_FT,
 	NL80211_AUTHTYPE_NETWORK_EAP,
+	NL80211_AUTHTYPE_SAE,
 
 	/* keep last */
 	__NL80211_AUTHTYPE_NUM,
-- 
1.7.0.4

