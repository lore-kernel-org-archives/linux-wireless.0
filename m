Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXIFNqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:07 -0400
Message-Id: <20070905234628.181948000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 14/21] mac80211 maintainership
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds myself to the maintainer list for mac80211 and
changes the git tree URL to John's tree since Jiri doesn't seem
to be around any more.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- wireless-dev.orig/MAINTAINERS	2007-09-06 01:34:55.144453431 +0200
+++ wireless-dev/MAINTAINERS	2007-09-06 01:35:22.694453431 +0200
@@ -2464,9 +2464,11 @@ P:	Jiri Benc
 M:	jbenc@suse.cz
 P:	Michael Wu
 M:	flamingice@sourmilk.net
+P:	Johannes Berg
+M:	johannes@sipsolutions.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-dev.git (mac80211 branch)
 S:	Maintained
 
 MACVLAN DRIVER

-- 

