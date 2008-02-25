Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYBYJwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 04:52:54 -0500
Subject: [PATCH] mac80211: clarify mesh Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 10:13:31 +0100
Message-Id: <1203930811.13162.48.camel@johannes.berg> (sfid-20080225_095311_875922_150CCE24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This clarifies that the mesh networking code is currently
based on Draft 1.08 of the 802.11 Mesh Networking amendment.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/Kconfig	2008-02-24 12:53:10.000000000 +0100
+++ everything/net/mac80211/Kconfig	2008-02-24 12:53:44.000000000 +0100
@@ -85,8 +85,9 @@ config MAC80211_MESH
 	bool "Enable mac80211 mesh networking (pre-802.11s) support"
 	depends on MAC80211 && EXPERIMENTAL && BROKEN
 	---help---
-	 This options enables support of pre-802.11s mesh interfaces.
-	 For more information visit http://o11s.org
+	 This options enables support of Draft 802.11s mesh networking.
+	 The implementation is based on Draft 1.08 of the Mesh Networking
+	 amendment. For more information visit http://o11s.org/.
 
 
 config MAC80211_LEDS


