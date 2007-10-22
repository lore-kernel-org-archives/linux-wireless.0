Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXJWJzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 05:55:40 -0400
Subject: [PATCH] add myself as mac80211 maintainer
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 21:13:52 +0200
Message-Id: <1193080432.9793.46.camel@johannes.berg> (sfid-20071023_105543_791359_D2723EF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds myself as mac80211 maintainer and updates the git URL to point
to the wireless-2.6 tree.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Is the list of names within a subsystem supposed to be alphabetically
sorted as well? I didn't last time I submitted this patch (or rather a
similar one). Not really sure.

I would appreciate if this could go into 2.6.24 since that has seen many
changes by me and I can't always read linux-wireless as closely as I
wish.

--- wireless-dev.orig/MAINTAINERS	2007-10-22 21:06:12.538268270 +0200
+++ wireless-dev/MAINTAINERS	2007-10-22 21:08:14.868268270 +0200
@@ -2471,11 +2471,13 @@ S:	Maintained
 MAC80211
 P:	Jiri Benc
 M:	jbenc@suse.cz
+P:	Johannes Berg
+M:	johannes@sipsolutions.net
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
 MACVLAN DRIVER


