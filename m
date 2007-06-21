Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXFVIks (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:40:48 -0400
Message-Id: <20070621221759.017419000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 09/14] mac80211: remove some unnecessary includes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c |    4 ----
 1 file changed, 4 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-21 23:21:43.858638003 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-21 23:24:21.928638003 +0200
@@ -20,8 +20,6 @@
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <linux/rtnetlink.h>
-#include <net/iw_handler.h>
-#include <linux/compiler.h>
 #include <linux/bitmap.h>
 #include <net/cfg80211.h>
 
@@ -29,8 +27,6 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "wep.h"
-#include "wpa.h"
-#include "tkip.h"
 #include "wme.h"
 #include "aes_ccm.h"
 #include "ieee80211_led.h"

-- 

