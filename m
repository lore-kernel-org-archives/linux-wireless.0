Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36762 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbYBDRM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 12:12:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Is not EXPERIMENTAL anymore
Date: Mon, 4 Feb 2008 18:11:41 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802041811.41580.mb@bu3sch.de> (sfid-20080204_171233_903660_2D4F06FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the EXPERIMENTAL dependency, as the existing mac80211
features are stable.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/net/mac80211/Kconfig
===================================================================
--- wireless-2.6.orig/net/mac80211/Kconfig	2008-01-16 11:33:56.000000000 +0100
+++ wireless-2.6/net/mac80211/Kconfig	2008-02-04 18:10:01.000000000 +0100
@@ -1,6 +1,5 @@
 config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
-	depends on EXPERIMENTAL
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_ARC4

-- 
Greetings Michael.
