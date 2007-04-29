Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44857 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754488AbXD2Aga (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 20:36:30 -0400
Date: Sun, 29 Apr 2007 02:36:25 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-dev: add maintainers entry for mac80211
Message-ID: <20070429023625.305b15fe@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add MAINTAINERS entry for mac80211.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2215,6 +2215,16 @@ M:	philb@gnu.org
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 
+MAC80211
+P:	Jiri Benc
+M:	jbenc@suse.cz
+P:	Michael Wu
+M:	flamingice@sourmilk.net
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
+S:	Maintained
+
 MARVELL YUKON / SYSKONNECT DRIVER
 P:	Mirko Lindner
 M: 	mlindner@syskonnect.de
