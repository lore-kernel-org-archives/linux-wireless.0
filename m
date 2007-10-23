Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXJWPEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 11:04:14 -0400
Subject: [PATCH v2] add myself as mac80211 maintainer
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1193080432.9793.46.camel@johannes.berg> (sfid-20071023_105543_791359_D2723EF7)
References: <1193080432.9793.46.camel@johannes.berg>
	 (sfid-20071023_105543_791359_D2723EF7)
Content-Type: text/plain
Date: Tue, 23 Oct 2007 17:05:25 +0200
Message-Id: <1193151925.7733.19.camel@johannes.berg> (sfid-20071023_160417_467977_A4B43681)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds myself as mac80211 maintainer and updates the git URL to point
to the wireless-2.6 tree. Also move Jiri down so he isn't first in list.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>
---
 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- wireless-dev.orig/MAINTAINERS	2007-10-23 13:37:15.748259069 +0200
+++ wireless-dev/MAINTAINERS	2007-10-23 17:04:22.791135956 +0200
@@ -2469,13 +2469,15 @@ W:	http://www.tazenda.demon.co.uk/phil/l
 S:	Maintained
 
 MAC80211
-P:	Jiri Benc
-M:	jbenc@suse.cz
 P:	Michael Wu
 M:	flamingice@sourmilk.net
+P:	Johannes Berg
+M:	johannes@sipsolutions.net
+P:	Jiri Benc
+M:	jbenc@suse.cz
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
 MACVLAN DRIVER


