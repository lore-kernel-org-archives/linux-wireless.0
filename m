Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbXHWQtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:47 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFsO-00010a-RA
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:45 +0100
Message-Id: <20070823164525.677795000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 11/11] mac80211 maintainership
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

--- wireless-dev.orig/MAINTAINERS	2007-08-23 18:38:36.901897709 +0200
+++ wireless-dev/MAINTAINERS	2007-08-23 18:38:46.241897709 +0200
@@ -2443,9 +2443,11 @@ P:	Jiri Benc
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

