Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2IENy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:54:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't use kerneldoc for ieee80211_add_rx_radiotap_header
Date: Wed,  5 Sep 2012 15:55:33 +0200
Message-Id: <1346853333-17869-1-git-send-email-johannes@sipsolutions.net> (sfid-20120905_155500_676104_FDD24AF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Doing so creates warnings, but the function is internal and
not part of the 802.11 docbooks, so it from kerneldoc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b382605..61c621e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -103,7 +103,7 @@ ieee80211_rx_radiotap_len(struct ieee80211_local *local,
 	return len;
 }
 
-/**
+/*
  * ieee80211_add_rx_radiotap_header - add radiotap header
  *
  * add a radiotap header containing all the fields which the hardware provided.
-- 
1.7.10.4

