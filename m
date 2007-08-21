Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132AbXHUPK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:10:27 -0400
Message-Id: <20070821150047.864726000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 19/27] cfg80211: extend radiotap parser by all remaining  fields
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These fields are defined so the parser might as well understand them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/radiotap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/wireless/radiotap.c	2007-08-21 14:42:05.635923881 +0200
+++ wireless-dev/net/wireless/radiotap.c	2007-08-21 14:52:58.095923881 +0200
@@ -161,7 +161,11 @@ int ieee80211_radiotap_iterator_next(
 		[IEEE80211_RADIOTAP_DBM_TX_POWER] = 0x11,
 		[IEEE80211_RADIOTAP_ANTENNA] = 0x11,
 		[IEEE80211_RADIOTAP_DB_ANTSIGNAL] = 0x11,
-		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11
+		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11,
+		[IEEE80211_RADIOTAP_RX_FLAGS] = 0x22,
+		[IEEE80211_RADIOTAP_TX_FLAGS] = 0x22,
+		[IEEE80211_RADIOTAP_RTS_RETRIES] = 0x11,
+		[IEEE80211_RADIOTAP_DATA_RETRIES] = 0x11,
 		/*
 		 * add more here as they are defined in
 		 * include/net/ieee80211_radiotap.h

-- 

