Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:64458 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaGTMdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:33:54 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so6412168wes.34
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:33:53 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 1/2] iw: sync nl80211_attrs
Date: Sun, 20 Jul 2014 14:33:48 +0200
Message-Id: <1405859629-32326-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143357_977472_BBDAF5BD)
In-Reply-To: <1405859629-32326-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859629-32326-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync nl80211_attrs with mac80211 stack

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 nl80211.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index be9519b..f1db15b 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -1591,6 +1591,9 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
+ *	the TDLS link initiator.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1931,6 +1934,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
 
+	NL80211_ATTR_TDLS_INITIATOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
-- 
1.9.1

