Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4080 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966239AbXHMGZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:57 -0400
Date: Sun, 12 Aug 2007 23:25:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, johannes@sipsolutions.net,
	akpm@linux-foundation.org
Subject: [PATCH] [121/2many] MAINTAINERS - CFG80211 and NL80211
Message-ID: <46bff948.otglyA7i5BhTYKIi%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0f5a92f..9157b5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1177,6 +1177,11 @@ P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	include/linux/nl80211.h
+F:	include/net/cfg80211.h
+F:	net/wireless/core.*
+F:	net/wireless/sysfs.*
+F:	net/wireless/radiotap.c
 
 CHECKPATCH
 P:	Andy Whitcroft
