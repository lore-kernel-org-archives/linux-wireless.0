Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZAZSfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 13:35:31 -0500
Subject: [PATCH] mac80211: remove Michael Wu as maintainer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 19:35:28 +0100
Message-Id: <1232994928.4533.33.camel@johannes.local> (sfid-20090126_193535_026194_17F3226B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

His email address keeps bouncing, and he's not interested in mac80211
patches etc. anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

--- wireless-testing.orig/MAINTAINERS	2009-01-26 19:34:20.000000000 +0100
+++ wireless-testing/MAINTAINERS	2009-01-26 19:34:25.000000000 +0100
@@ -2835,8 +2835,6 @@ S:	Maintained
 MAC80211
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
-P:	Michael Wu
-M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git


