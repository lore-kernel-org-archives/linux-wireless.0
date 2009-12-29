Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49073 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbZL2KoM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2009 05:44:12 -0500
Date: Tue, 29 Dec 2009 12:43:58 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: No need to include WEXT headers here
Message-ID: <20091229104358.GA16996@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the forgotten linux/wireless.h inclusion from mac80211.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/main.c |    1 -
 net/mac80211/scan.c |    1 -
 net/mac80211/util.c |    1 -
 3 files changed, 3 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2009-12-29 10:50:57.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-12-29 10:52:32.000000000 +0200
@@ -17,7 +17,6 @@
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
-#include <linux/wireless.h>
 #include <linux/rtnetlink.h>
 #include <linux/bitmap.h>
 #include <linux/pm_qos_params.h>
--- wireless-testing.orig/net/mac80211/scan.c	2009-12-29 10:50:57.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-12-29 10:52:32.000000000 +0200
@@ -12,7 +12,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/wireless.h>
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <net/mac80211.h>
--- wireless-testing.orig/net/mac80211/util.c	2009-12-29 10:50:57.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-12-29 10:52:32.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
-#include <linux/wireless.h>
 #include <linux/bitmap.h>
 #include <linux/crc32.h>
 #include <net/net_namespace.h>


-- 
Jouni Malinen                                            PGP id EFC895FA
