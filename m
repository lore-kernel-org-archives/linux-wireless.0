Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55462 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932095AbdJJH6C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 03:58:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] MAINTAINERS: update Johannes Berg's entries
Date: Tue, 10 Oct 2017 09:57:59 +0200
Message-Id: <20171010075759.28377-1-johannes@sipsolutions.net> (sfid-20171010_095820_481512_C0F97D0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Update my MAINTAINERS file entries to list all the right files.
Since I'm also the de-facto wireless extensions maintainer,
there's little point in excluding those.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f0c37be4e04a..e90cdecd7b5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3329,17 +3329,22 @@ S:	Maintained
 F:	drivers/auxdisplay/cfag12864bfb.c
 F:	include/linux/cfag12864b.h
 
-CFG80211 and NL80211
+802.11 (including CFG80211/NL80211)
 M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
+F:	net/wireless/
 F:	include/uapi/linux/nl80211.h
+F:	include/linux/ieee80211.h
+F:	include/net/wext.h
 F:	include/net/cfg80211.h
-F:	net/wireless/*
-X:	net/wireless/wext*
+F:	include/net/iw_handler.h
+F:	include/net/ieee80211_radiotap.h
+F:	Documentation/driver-api/80211/cfg80211.rst
+F:	Documentation/networking/regulatory.txt
 
 CHAR and MISC DRIVERS
 M:	Arnd Bergmann <arnd@arndb.de>
@@ -8207,6 +8212,7 @@ F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
 F:	net/mac80211/
 F:	drivers/net/wireless/mac80211_hwsim.[ch]
+F:	Documentation/networking/mac80211_hwsim/README
 
 MAILBOX API
 M:	Jassi Brar <jassisinghbrar@gmail.com>
@@ -11491,6 +11497,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
 F:	Documentation/rfkill.txt
+F:	Documentation/ABI/stable/sysfs-class-rfkill
 F:	net/rfkill/
 
 RHASHTABLE
-- 
2.14.2
