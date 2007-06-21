Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXFVIlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:16 -0400
Message-Id: <20070621221800.021680000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 11/14] mac80211: regdomain.c needs to include ieee80211_i.h
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/regdomain.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-dev.orig/net/mac80211/regdomain.c	2007-06-21 23:36:58.758638003 +0200
+++ wireless-dev/net/mac80211/regdomain.c	2007-06-21 23:37:19.988638003 +0200
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <net/mac80211.h>
+#include "ieee80211_i.h"
 
 static int ieee80211_regdom = 0x10; /* FCC */
 module_param(ieee80211_regdom, int, 0444);

-- 

