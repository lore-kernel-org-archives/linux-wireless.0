Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1LNI3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 03:29:17 -0500
Subject: [PATCH] nl80211: add TDLS peer flag to policy
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 09:29:15 +0100
Message-ID: <1323851355.3380.5.camel@jlt3.sipsolutions.net> (sfid-20111214_092928_804890_9EE2F054)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was evidently missed in the TDLS patch (07ba55d7).

Cc: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/nl80211.c	2011-12-14 09:26:45.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-12-14 09:27:15.000000000 +0100
@@ -2246,6 +2246,7 @@ static const struct nla_policy sta_flags
 	[NL80211_STA_FLAG_WME] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_TDLS_PEER] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,


