Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbZJ0T4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 15:56:46 -0400
Subject: [PATCH] mac80211: remove outdated comment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 20:56:21 +0100
Message-ID: <1256673381.4237.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This comment hasn't been a real TODO item for a long
time now since we fixed that quite a while ago.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |    2 --
 1 file changed, 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-10-27 17:12:54.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-10-27 17:19:16.000000000 +0100
@@ -12,8 +12,6 @@
  * published by the Free Software Foundation.
  */
 
-/* TODO: figure out how to avoid that the "current BSS" expires */
-
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>


